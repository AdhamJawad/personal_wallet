import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/debt_status.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../../contacts/domain/models/contact.dart';
import '../../../contacts/domain/repositories/contact_repository.dart';
import '../../../notifications/domain/services/notification_publisher.dart';
import '../../../transfers/domain/models/user_transfer.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_repayment.dart';
import '../../domain/models/debt_settlement.dart';
import '../../domain/models/debt_summary.dart';
import 'local_debt_repository.dart';
import '../models/mock_debt_record.dart';
import '../services/debt_projection_builder.dart';

class MockDebtRepository implements LocalDebtRepository {
  MockDebtRepository({
    required LocalStore localStore,
    required ContactRepository contactRepository,
    required SyncQueueRepository syncQueueRepository,
    required NotificationPublisher notificationPublisher,
    required AuditLogger auditLogger,
    DebtProjectionBuilder projectionBuilder = const DebtProjectionBuilder(),
  }) : _localStore = localStore,
       _contactRepository = contactRepository,
       _syncQueueRepository = syncQueueRepository,
       _notificationPublisher = notificationPublisher,
       _auditLogger = auditLogger,
       _projectionBuilder = projectionBuilder;

  final LocalStore _localStore;
  final ContactRepository _contactRepository;
  final SyncQueueRepository _syncQueueRepository;
  final NotificationPublisher _notificationPublisher;
  final AuditLogger _auditLogger;
  final DebtProjectionBuilder _projectionBuilder;

  static const String _canonicalTransfersKey = 'transfers.records';

  Future<List<MockDebtRecord>> _loadRecords(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.debtsBox,
      key: ownerUserId,
    );

    if (rawValue == null || rawValue.isEmpty) {
      final List<MockDebtRecord> seededRecords = await _seedRecords(
        ownerUserId,
      );
      await _saveRecords(ownerUserId, seededRecords);
      return seededRecords;
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) => MockDebtRecord.fromJson(
            _migrateRecordJson(item as Map<String, dynamic>),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _saveRecords(
    String ownerUserId,
    List<MockDebtRecord> records,
  ) async {
    await _localStore.write(
      boxName: AppConstants.debtsBox,
      key: ownerUserId,
      value: jsonEncode(
        records.map((MockDebtRecord record) => record.toJson()).toList(),
      ),
    );
  }

  Future<List<MockDebtRecord>> _seedRecords(String ownerUserId) async {
    final DateTime now = DateTime.now().toUtc();
    final List<Contact> contacts = await _contactRepository.fetchContacts(
      ownerUserId,
    );

    String contactIdByName(String name) {
      return contacts.firstWhere((Contact contact) => contact.name == name).id;
    }

    return <MockDebtRecord>[
      MockDebtRecord(
        debt: Debt(
          id: 'debt_owed_to_me_ali',
          ownerUserId: ownerUserId,
          counterpartyContactId: contactIdByName('Ali'),
          isOwedToMe: true,
          currencyCode: 'USD',
          originalAmountMinor: 10000,
          note: 'Personal loan to Ali',
          createdAt: now.subtract(const Duration(days: 18)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
        repayments: <DebtRepayment>[
          DebtRepayment(
            id: IdGenerator.next(),
            debtId: 'debt_owed_to_me_ali',
            amountMinor: 3000,
            currencyCode: 'USD',
            note: 'First partial repayment',
            createdAt: now.subtract(const Duration(days: 6)),
          ),
        ],
      ),
      MockDebtRecord(
        debt: Debt(
          id: 'debt_i_owe_store',
          ownerUserId: ownerUserId,
          counterpartyContactId: contactIdByName('Local Store'),
          isOwedToMe: false,
          currencyCode: 'SYP',
          originalAmountMinor: 75000000,
          note: 'Inventory balance',
          createdAt: now.subtract(const Duration(days: 12)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        repayments: <DebtRepayment>[
          DebtRepayment(
            id: IdGenerator.next(),
            debtId: 'debt_i_owe_store',
            amountMinor: 25000000,
            currencyCode: 'SYP',
            note: 'First settlement',
            createdAt: now.subtract(const Duration(days: 4)),
          ),
        ],
      ),
      MockDebtRecord(
        debt: Debt(
          id: 'debt_registered_ahmad',
          ownerUserId: ownerUserId,
          counterpartyContactId: contactIdByName('Ahmad Kareem'),
          isOwedToMe: false,
          currencyCode: 'USD',
          originalAmountMinor: 18000,
          note: 'Shared trip advance to Ahmad',
          createdAt: now.subtract(const Duration(days: 9)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        repayments: const <DebtRepayment>[],
      ),
    ];
  }

  Future<Map<String, UserTransfer>> _loadTransferLookup() async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.transactionsBox,
      key: _canonicalTransfersKey,
    );
    if (rawValue == null || rawValue.isEmpty) {
      return const <String, UserTransfer>{};
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    final List<UserTransfer> transfers = decoded
        .map(
          (dynamic item) => UserTransfer.fromJson(
            _migrateTransferJson(item as Map<String, dynamic>),
          ),
        )
        .toList(growable: false);

    return <String, UserTransfer>{
      for (final UserTransfer transfer in transfers) transfer.id: transfer,
    };
  }

  Future<DebtSummary> _toSummary(
    String ownerUserId,
    MockDebtRecord record, {
    Map<String, UserTransfer>? transferLookup,
  }) async {
    final Contact? contact = await _contactRepository.getContactById(
      ownerUserId: ownerUserId,
      contactId: record.debt.counterpartyContactId,
    );

    if (contact == null) {
      throw const DebtRepositoryException('Debt contact was not found.');
    }

    final Map<String, UserTransfer> resolvedTransferLookup =
        transferLookup ?? await _loadTransferLookup();

    return _projectionBuilder.buildSummary(
      debt: record.debt,
      contact: contact,
      repayments: record.repayments,
      settlements: record.settlements,
      transferReferenceResolver: (DebtSettlement settlement) {
        final UserTransfer? transfer =
            resolvedTransferLookup[settlement.linkedTransferId];
        final String? value =
            transfer?.referenceFor(ownerUserId)?.value ??
            transfer?.senderReference?.value ??
            transfer?.recipientReference?.value;
        return value ?? settlement.linkedTransferId;
      },
    );
  }

  @override
  Future<DebtSummary> createDebt({
    required String ownerUserId,
    required String contactId,
    required bool isOwedToMe,
    required String currencyCode,
    required int amountMinor,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final MockDebtRecord record = MockDebtRecord(
      debt: Debt(
        id: IdGenerator.next(),
        ownerUserId: ownerUserId,
        counterpartyContactId: contactId,
        isOwedToMe: isOwedToMe,
        currencyCode: currencyCode,
        originalAmountMinor: amountMinor,
        status: DebtStatus.active,
        note: note,
        createdAt: now,
        updatedAt: now,
      ),
      repayments: const <DebtRepayment>[],
    );

    final List<MockDebtRecord> updatedRecords = List<MockDebtRecord>.from(
      records,
    )..add(record);
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: record.debt.id,
      type: SyncOperationType.debtCreate,
      payload: <String, dynamic>{
        'contactId': contactId,
        'isOwedToMe': isOwedToMe,
        'currencyCode': currencyCode,
        'amountMinor': amountMinor,
      },
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'debtCreated',
      title: 'Debt created',
      message: 'A new debt record was created.',
      relatedEntityId: record.debt.id,
      relatedEntityType: 'debt',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.debtCreated,
      entityId: record.debt.id,
      relatedEntityType: 'debt',
    );
    return _toSummary(ownerUserId, record);
  }

  @override
  Future<DebtSummary> createRepayment({
    required String ownerUserId,
    required String debtId,
    required int amountMinor,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final int index = records.indexWhere(
      (MockDebtRecord record) => record.debt.id == debtId,
    );

    if (index < 0) {
      throw const DebtRepositoryException('Debt was not found.');
    }

    final MockDebtRecord currentRecord = records[index];
    final DebtRepayment repayment = DebtRepayment(
      id: IdGenerator.next(),
      debtId: debtId,
      amountMinor: amountMinor,
      currencyCode: currentRecord.debt.currencyCode,
      note: note,
      createdAt: now,
    );

    final Debt reconciledDebt = _projectionBuilder.reconcileDebt(
      debt: currentRecord.debt.copyWith(updatedAt: now),
      repayments: List<DebtRepayment>.from(currentRecord.repayments)
        ..add(repayment),
      settlements: currentRecord.settlements,
    );

    final MockDebtRecord updatedRecord = currentRecord.copyWith(
      debt: reconciledDebt,
      repayments: List<DebtRepayment>.from(currentRecord.repayments)
        ..add(repayment),
    );

    final List<MockDebtRecord> updatedRecords = List<MockDebtRecord>.from(
      records,
    )..[index] = updatedRecord;
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: repayment.id,
      type: SyncOperationType.debtRepaymentCreate,
      payload: <String, dynamic>{
        'debtId': debtId,
        'amountMinor': amountMinor,
        'currencyCode': repayment.currencyCode,
        'repaymentId': repayment.id,
      },
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'debtRepaid',
      title: 'Debt repaid',
      message: 'A debt repayment was recorded locally.',
      relatedEntityId: repayment.id,
      relatedEntityType: 'debtRepayment',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.debtRepaid,
      entityId: repayment.id,
      relatedEntityType: 'debtRepayment',
    );
    return _toSummary(ownerUserId, updatedRecord);
  }

  @override
  Future<DebtSummary> updateDebt({
    required String ownerUserId,
    required String debtId,
    required int amountMinor,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final int index = records.indexWhere(
      (MockDebtRecord record) => record.debt.id == debtId,
    );

    if (index < 0) {
      throw const DebtRepositoryException('Debt was not found.');
    }

    final MockDebtRecord currentRecord = records[index];
    final Debt reconciledDebt = _projectionBuilder.reconcileDebt(
      debt: currentRecord.debt.copyWith(
        originalAmountMinor: amountMinor,
        note: note,
        updatedAt: now,
      ),
      repayments: currentRecord.repayments,
      settlements: currentRecord.settlements,
    );
    final MockDebtRecord updatedRecord = currentRecord.copyWith(
      debt: reconciledDebt,
    );

    final List<MockDebtRecord> updatedRecords = List<MockDebtRecord>.from(
      records,
    )..[index] = updatedRecord;
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: debtId,
      type: SyncOperationType.debtUpdate,
      payload: <String, dynamic>{'amountMinor': amountMinor, 'note': note},
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'debtUpdated',
      title: 'Debt updated',
      message: 'A debt record was updated.',
      relatedEntityId: debtId,
      relatedEntityType: 'debt',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.debtUpdated,
      entityId: debtId,
      relatedEntityType: 'debt',
    );
    return _toSummary(ownerUserId, updatedRecord);
  }

  @override
  Future<DebtSummary> closeDebt({
    required String ownerUserId,
    required String debtId,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final int index = records.indexWhere(
      (MockDebtRecord record) => record.debt.id == debtId,
    );

    if (index < 0) {
      throw const DebtRepositoryException('Debt was not found.');
    }

    final MockDebtRecord currentRecord = records[index];
    final MockDebtRecord updatedRecord = currentRecord.copyWith(
      debt: currentRecord.debt.copyWith(
        status: DebtStatus.completed,
        updatedAt: now,
        completedAt: now,
      ),
    );

    final List<MockDebtRecord> updatedRecords = List<MockDebtRecord>.from(
      records,
    )..[index] = updatedRecord;
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: debtId,
      type: SyncOperationType.debtClose,
      payload: <String, dynamic>{
        'status': DebtStatus.completed.name,
        'completedAt': now.toIso8601String(),
      },
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'debtClosed',
      title: 'Debt closed',
      message: 'A debt record was marked as settled.',
      relatedEntityId: debtId,
      relatedEntityType: 'debt',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.debtClosed,
      entityId: debtId,
      relatedEntityType: 'debt',
    );
    return _toSummary(ownerUserId, updatedRecord);
  }

  @override
  Future<DebtSummary> reopenDebt({
    required String ownerUserId,
    required String debtId,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final int index = records.indexWhere(
      (MockDebtRecord record) => record.debt.id == debtId,
    );

    if (index < 0) {
      throw const DebtRepositoryException('Debt was not found.');
    }

    final MockDebtRecord currentRecord = records[index];
    final Debt reconciledDebt = _projectionBuilder.reconcileDebt(
      debt: currentRecord.debt.copyWith(
        status: DebtStatus.active,
        updatedAt: now,
        clearCompletedAt: true,
      ),
      repayments: currentRecord.repayments,
      settlements: currentRecord.settlements,
    );
    final MockDebtRecord updatedRecord = currentRecord.copyWith(
      debt: reconciledDebt,
    );

    final List<MockDebtRecord> updatedRecords = List<MockDebtRecord>.from(
      records,
    )..[index] = updatedRecord;
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: debtId,
      type: SyncOperationType.debtReopen,
      payload: const <String, dynamic>{'status': 'active', 'completedAt': null},
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'debtReopened',
      title: 'Debt reopened',
      message: 'A closed debt record was reopened.',
      relatedEntityId: debtId,
      relatedEntityType: 'debt',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.debtReopened,
      entityId: debtId,
      relatedEntityType: 'debt',
    );
    return _toSummary(ownerUserId, updatedRecord);
  }

  @override
  Future<DebtSettlement> createSettlement({
    required String ownerUserId,
    required String debtId,
    required String transferId,
    required int amountMinor,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final int index = records.indexWhere(
      (MockDebtRecord record) => record.debt.id == debtId,
    );

    if (index < 0) {
      throw const DebtRepositoryException('Debt was not found.');
    }

    final MockDebtRecord existingRecord = records[index];
    final DebtSettlement settlement = DebtSettlement(
      id: IdGenerator.next(),
      debtId: debtId,
      linkedTransferId: transferId,
      currencyCode: existingRecord.debt.currencyCode,
      amountMinor: amountMinor,
      note: note,
      createdAt: now,
    );

    final Debt reconciledDebt = _projectionBuilder.reconcileDebt(
      debt: existingRecord.debt.copyWith(updatedAt: now),
      repayments: existingRecord.repayments,
      settlements: List<DebtSettlement>.from(existingRecord.settlements)
        ..add(settlement),
    );
    final MockDebtRecord updatedRecord = existingRecord.copyWith(
      debt: reconciledDebt,
      settlements: List<DebtSettlement>.from(existingRecord.settlements)
        ..add(settlement),
    );

    final List<MockDebtRecord> updatedRecords = List<MockDebtRecord>.from(
      records,
    )..[index] = updatedRecord;
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: settlement.id,
      type: SyncOperationType.debtSettlementCreate,
      payload: <String, dynamic>{
        'debtId': debtId,
        'linkedTransferId': transferId,
        'amountMinor': amountMinor,
        'currencyCode': settlement.currencyCode,
        'settlementId': settlement.id,
      },
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'debtSettled',
      title: 'Debt settled',
      message: 'A debt settlement was linked to a transfer.',
      relatedEntityId: settlement.id,
      relatedEntityType: 'debtSettlement',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.debtSettled,
      entityId: settlement.id,
      relatedEntityType: 'debtSettlement',
    );
    return settlement;
  }

  @override
  Future<List<DebtSummary>> fetchDebts(String ownerUserId) async {
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final Map<String, UserTransfer> transferLookup =
        await _loadTransferLookup();
    return Future.wait(
      records.map(
        (MockDebtRecord record) =>
            _toSummary(ownerUserId, record, transferLookup: transferLookup),
      ),
    );
  }

  @override
  Future<DebtSummary?> getDebtById({
    required String ownerUserId,
    required String debtId,
  }) async {
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final MockDebtRecord? record = records.cast<MockDebtRecord?>().firstWhere(
      (MockDebtRecord? item) => item?.debt.id == debtId,
      orElse: () => null,
    );

    return record == null ? null : _toSummary(ownerUserId, record);
  }

  Map<String, dynamic> _migrateRecordJson(Map<String, dynamic> json) {
    final Map<String, dynamic> migrated = Map<String, dynamic>.from(json);
    final Map<String, dynamic> debt = Map<String, dynamic>.from(
      migrated['debt'] as Map<String, dynamic>,
    );
    debt['currencyCode'] ??= (debt.remove('currency') as String?)
        ?.toUpperCase();
    if (!debt.containsKey('originalAmountMinor')) {
      debt['originalAmountMinor'] = AmountFormatter.parseToMinor(
        (debt.remove('originalAmount') ?? '0').toString(),
      );
    }
    debt['status'] = switch (debt['status'] as String?) {
      'open' => DebtStatus.active.name,
      'settled' => DebtStatus.completed.name,
      'disputed' => DebtStatus.cancelled.name,
      final String value => value,
      null =>
        debt['completedAt'] == null
            ? DebtStatus.active.name
            : DebtStatus.completed.name,
    };
    migrated['debt'] = debt;

    migrated['repayments'] =
        (migrated['repayments'] as List<dynamic>? ?? const [])
            .map((dynamic item) {
              final Map<String, dynamic> repayment = Map<String, dynamic>.from(
                item as Map<String, dynamic>,
              );
              if (!repayment.containsKey('amountMinor')) {
                repayment['amountMinor'] = AmountFormatter.parseToMinor(
                  (repayment.remove('amount') ?? '0').toString(),
                );
              }
              repayment['currencyCode'] ??= debt['currencyCode'];
              return repayment;
            })
            .toList(growable: false);

    migrated['settlements'] =
        (migrated['settlements'] as List<dynamic>? ?? const [])
            .map((dynamic item) {
              final Map<String, dynamic> settlement = Map<String, dynamic>.from(
                item as Map<String, dynamic>,
              );
              settlement['currencyCode'] ??=
                  (settlement.remove('currency') as String?)?.toUpperCase() ??
                  debt['currencyCode'];
              if (!settlement.containsKey('amountMinor')) {
                settlement['amountMinor'] = AmountFormatter.parseToMinor(
                  (settlement.remove('amount') ?? '0').toString(),
                );
              }
              settlement['linkedTransferId'] ??= settlement.remove(
                'transferId',
              );
              settlement.remove('ownerUserId');
              settlement.remove('ledgerTransactionId');
              settlement.remove('transferReference');
              return settlement;
            })
            .toList(growable: false);

    return migrated;
  }

  Map<String, dynamic> _migrateTransferJson(Map<String, dynamic> json) {
    final Map<String, dynamic> migrated = Map<String, dynamic>.from(json);
    migrated['currencyCode'] ??= (migrated.remove('currency') as String?)
        ?.toUpperCase();
    if (!migrated.containsKey('amountMinor')) {
      migrated['amountMinor'] = AmountFormatter.parseToMinor(
        (migrated.remove('amount') ?? '0').toString(),
      );
    }
    return migrated;
  }
}

class DebtRepositoryException implements Exception {
  const DebtRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
