import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../../contacts/domain/models/contact.dart';
import '../../../contacts/domain/repositories/contact_repository.dart';
import '../../../notifications/domain/services/notification_publisher.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_repayment.dart';
import '../../domain/models/debt_settlement.dart';
import '../../domain/models/debt_summary.dart';
import '../../domain/models/settlement_summary.dart';
import 'local_debt_repository.dart';
import '../models/mock_debt_record.dart';

class MockDebtRepository implements LocalDebtRepository {
  MockDebtRepository({
    required LocalStore localStore,
    required ContactRepository contactRepository,
    required SyncQueueRepository syncQueueRepository,
    required NotificationPublisher notificationPublisher,
    required AuditLogger auditLogger,
  }) : _localStore = localStore,
       _contactRepository = contactRepository,
       _syncQueueRepository = syncQueueRepository,
       _notificationPublisher = notificationPublisher,
       _auditLogger = auditLogger;

  final LocalStore _localStore;
  final ContactRepository _contactRepository;
  final SyncQueueRepository _syncQueueRepository;
  final NotificationPublisher _notificationPublisher;
  final AuditLogger _auditLogger;

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
          (dynamic item) =>
              MockDebtRecord.fromJson(item as Map<String, dynamic>),
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
          currency: Currency.usd,
          originalAmount: '100',
          note: 'Personal loan to Ali',
          createdAt: now.subtract(const Duration(days: 18)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
        repayments: <DebtRepayment>[
          DebtRepayment(
            id: IdGenerator.next(),
            debtId: 'debt_owed_to_me_ali',
            amount: '30',
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
          currency: Currency.syp,
          originalAmount: '750000',
          note: 'Inventory balance',
          createdAt: now.subtract(const Duration(days: 12)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        repayments: <DebtRepayment>[
          DebtRepayment(
            id: IdGenerator.next(),
            debtId: 'debt_i_owe_store',
            amount: '250000',
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
          currency: Currency.usd,
          originalAmount: '180',
          note: 'Shared trip advance to Ahmad',
          createdAt: now.subtract(const Duration(days: 9)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
        repayments: const <DebtRepayment>[],
      ),
    ];
  }

  Future<DebtSummary> _toSummary(
    String ownerUserId,
    MockDebtRecord record,
  ) async {
    final Contact? contact = await _contactRepository.getContactById(
      ownerUserId: ownerUserId,
      contactId: record.debt.counterpartyContactId,
    );

    if (contact == null) {
      throw const DebtRepositoryException('Debt contact was not found.');
    }

    final num originalAmount = num.tryParse(record.debt.originalAmount) ?? 0;
    final num repaidAmount = record.repayments.fold<num>(
      0,
      (num total, DebtRepayment repayment) =>
          total + (num.tryParse(repayment.amount) ?? 0),
    );
    final num settledAmount = record.settlements.fold<num>(
      0,
      (num total, DebtSettlement settlement) =>
          total + (num.tryParse(settlement.amount) ?? 0),
    );
    final num totalRecovered = repaidAmount + settledAmount;
    final num resolvedRemainingAmount = originalAmount - totalRecovered;
    final List<SettlementSummary> settlements = <SettlementSummary>[];
    num remainingAfterSettlement = originalAmount - repaidAmount;
    DateTime latestActivityAt = record.debt.updatedAt;

    for (final DebtSettlement settlement in record.settlements) {
      remainingAfterSettlement -= num.tryParse(settlement.amount) ?? 0;
      if (settlement.createdAt.isAfter(latestActivityAt)) {
        latestActivityAt = settlement.createdAt;
      }
      settlements.add(
        SettlementSummary(
          settlement: settlement,
          transferReference: settlement.transferReference,
          counterpartyDisplayName: contact.name,
          remainingAmountAfterSettlement: remainingAfterSettlement
              .clamp(0, double.infinity)
              .toString(),
          isCompleted: remainingAfterSettlement <= 0,
        ),
      );
    }

    for (final DebtRepayment repayment in record.repayments) {
      if (repayment.createdAt.isAfter(latestActivityAt)) {
        latestActivityAt = repayment.createdAt;
      }
    }

    return DebtSummary(
      debt: record.debt.copyWith(
        updatedAt: latestActivityAt,
        completedAt: resolvedRemainingAmount <= 0
            ? record.settlements.lastOrNull?.createdAt ??
                  record.repayments.lastOrNull?.createdAt ??
                  record.debt.completedAt
            : null,
      ),
      contact: contact,
      repayments: record.repayments,
      settlements: settlements,
      repaidAmount: totalRecovered.toString(),
      remainingAmount: resolvedRemainingAmount
          .clamp(0, double.infinity)
          .toString(),
      isCompleted: resolvedRemainingAmount <= 0,
      currency: record.debt.currency,
    );
  }

  @override
  Future<DebtSummary> createDebt({
    required String ownerUserId,
    required String contactId,
    required bool isOwedToMe,
    required String currencyCode,
    required String amount,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    final Currency currency = Currency.values.firstWhere(
      (Currency item) => item.name == currencyCode.toLowerCase(),
    );
    final MockDebtRecord record = MockDebtRecord(
      debt: Debt(
        id: IdGenerator.next(),
        ownerUserId: ownerUserId,
        counterpartyContactId: contactId,
        isOwedToMe: isOwedToMe,
        currency: currency,
        originalAmount: amount,
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
        'amount': amount,
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
    required String amount,
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

    final DebtRepayment repayment = DebtRepayment(
      id: IdGenerator.next(),
      debtId: debtId,
      amount: amount,
      note: note,
      createdAt: now,
    );

    final MockDebtRecord updatedRecord = records[index].copyWith(
      debt: records[index].debt.copyWith(updatedAt: now),
      repayments: List<DebtRepayment>.from(records[index].repayments)
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
        'amount': amount,
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
  Future<SettlementSummary> createSettlement({
    required String ownerUserId,
    required String debtId,
    required String transferId,
    required String ledgerTransactionId,
    required String transferReference,
    required String amount,
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
      ownerUserId: ownerUserId,
      transferId: transferId,
      ledgerTransactionId: ledgerTransactionId,
      transferReference: transferReference,
      currency: existingRecord.debt.currency,
      amount: amount,
      note: note,
      createdAt: now,
    );

    final MockDebtRecord updatedRecord = existingRecord.copyWith(
      debt: existingRecord.debt.copyWith(updatedAt: now),
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
        'transferId': transferId,
        'ledgerTransactionId': ledgerTransactionId,
        'transferReference': transferReference,
        'amount': amount,
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

    final DebtSummary summary = await _toSummary(ownerUserId, updatedRecord);
    return summary.settlements.firstWhere(
      (SettlementSummary item) => item.settlement.id == settlement.id,
    );
  }

  @override
  Future<List<DebtSummary>> fetchDebts(String ownerUserId) async {
    final List<MockDebtRecord> records = await _loadRecords(ownerUserId);
    return Future.wait(
      records.map((MockDebtRecord record) => _toSummary(ownerUserId, record)),
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
}

class DebtRepositoryException implements Exception {
  const DebtRepositoryException(this.message);

  final String message;

  @override
  String toString() => message;
}
