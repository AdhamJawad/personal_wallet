import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../../debts/domain/models/settlement_summary.dart';
import '../../../debts/domain/repositories/debt_repository.dart';
import '../../../notifications/domain/services/notification_publisher.dart';
import '../../../transactions/data/services/mock_ledger_store.dart';
import '../../../transactions/domain/models/ledger_transaction.dart';
import '../../../transactions/domain/models/transaction_reference.dart';
import '../../domain/enums/transfer_status.dart';
import '../../domain/models/transfer_summary.dart';
import '../../domain/models/user_transfer.dart';
import 'local_transfer_repository.dart';

class MockTransferRepository implements LocalTransferRepository {
  MockTransferRepository({
    required LocalStore localStore,
    required MockLedgerStore ledgerStore,
    required DebtRepository debtRepository,
    required SyncQueueRepository syncQueueRepository,
    required NotificationPublisher notificationPublisher,
    required AuditLogger auditLogger,
  }) : _localStore = localStore,
       _ledgerStore = ledgerStore,
       _debtRepository = debtRepository,
       _syncQueueRepository = syncQueueRepository,
       _notificationPublisher = notificationPublisher,
       _auditLogger = auditLogger;

  final LocalStore _localStore;
  final MockLedgerStore _ledgerStore;
  final DebtRepository _debtRepository;
  final SyncQueueRepository _syncQueueRepository;
  final NotificationPublisher _notificationPublisher;
  final AuditLogger _auditLogger;

  static const String _canonicalTransfersKey = 'transfers.records';

  static String _legacyTransfersKey(String ownerUserId) =>
      'transfers.$ownerUserId';

  Future<List<UserTransfer>> _loadTransfers(String ownerUserId) async {
    final List<UserTransfer> canonicalTransfers = await _loadCanonicalTransfers(
      ownerUserId,
    );
    return canonicalTransfers
        .where((UserTransfer item) => item.involvesUser(ownerUserId))
        .toList(growable: false);
  }

  Future<List<UserTransfer>> _loadCanonicalTransfers(String ownerUserId) async {
    final String? canonicalRawValue = await _localStore.read(
      boxName: AppConstants.transactionsBox,
      key: _canonicalTransfersKey,
    );
    final List<UserTransfer> canonicalTransfers =
        canonicalRawValue == null || canonicalRawValue.isEmpty
        ? <UserTransfer>[]
        : _decodeTransfers(canonicalRawValue);

    final String legacyKey = _legacyTransfersKey(ownerUserId);
    final String? legacyRawValue = await _localStore.read(
      boxName: AppConstants.transactionsBox,
      key: legacyKey,
    );

    if (legacyRawValue == null || legacyRawValue.isEmpty) {
      return canonicalTransfers;
    }

    final List<UserTransfer> legacyTransfers = _decodeTransfers(
      legacyRawValue,
      ownerUserId: ownerUserId,
    );
    final List<UserTransfer> mergedTransfers = _mergeTransfers(
      canonicalTransfers,
      legacyTransfers,
    );

    if (!_sameTransferSet(canonicalTransfers, mergedTransfers)) {
      await _saveCanonicalTransfers(mergedTransfers);
    }
    await _localStore.delete(
      boxName: AppConstants.transactionsBox,
      key: legacyKey,
    );
    return mergedTransfers;
  }

  List<UserTransfer> _decodeTransfers(String rawValue, {String? ownerUserId}) {
    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) => UserTransfer.fromJson(
            _migrateTransferJson(
              item as Map<String, dynamic>,
              ownerUserId: ownerUserId,
            ),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _saveCanonicalTransfers(List<UserTransfer> transfers) async {
    await _localStore.write(
      boxName: AppConstants.transactionsBox,
      key: _canonicalTransfersKey,
      value: jsonEncode(
        transfers.map((UserTransfer item) => item.toJson()).toList(),
      ),
    );
  }

  TransferSummary _toSummary(String ownerUserId, UserTransfer transfer) {
    final bool isIncoming = transfer.senderUserId != ownerUserId;
    final TransactionReference reference =
        transfer.referenceFor(ownerUserId) ??
        transfer.senderReference ??
        transfer.recipientReference ??
        const TransactionReference(value: 'TR-UNKNOWN', year: 0, sequence: 0);
    final String ledgerTransactionId =
        transfer.ledgerTransactionIdFor(ownerUserId) ??
        transfer.senderLedgerTransactionId ??
        transfer.recipientLedgerTransactionId ??
        '';

    return TransferSummary(
      transfer: transfer,
      ownerUserId: ownerUserId,
      isIncoming: isIncoming,
      isDebtSettlement: transfer.linkedDebtSettlementId != null,
      counterpartyDisplayName: isIncoming
          ? transfer.senderDisplayName
          : transfer.recipientDisplayName,
      reference: reference,
      ledgerTransactionId: ledgerTransactionId,
    );
  }

  Future<LedgerTransaction> _appendLedgerTransaction({
    required String ownerUserId,
    required LedgerTransaction transaction,
  }) async {
    final List<LedgerTransaction> transactions = await _ledgerStore
        .loadTransactions(ownerUserId);
    final List<LedgerTransaction> updatedTransactions =
        List<LedgerTransaction>.from(transactions)..add(transaction);
    await _ledgerStore.saveTransactions(ownerUserId, updatedTransactions);
    return transaction;
  }

  @override
  Future<TransferSummary> createTransfer({
    required String ownerUserId,
    required String senderDisplayName,
    required String senderWalletId,
    required String recipientUserId,
    required String recipientDisplayName,
    required String currencyCode,
    required int amountMinor,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final String transferId = IdGenerator.next();
    final senderReference = await _ledgerStore.nextReference(ownerUserId);
    final recipientReference = await _ledgerStore.nextReference(
      recipientUserId,
    );

    final LedgerTransaction senderLedger = await _appendLedgerTransaction(
      ownerUserId: ownerUserId,
      transaction: LedgerTransaction(
        id: IdGenerator.next(),
        reference: senderReference,
        type: TransactionType.transfer,
        initiatedByUserId: ownerUserId,
        senderDisplayName: senderDisplayName,
        recipientUserId: recipientUserId,
        recipientDisplayName: recipientDisplayName,
        sourceWalletId: senderWalletId,
        sourceCurrencyCode: currencyCode,
        sourceAmountMinor: amountMinor,
        note: note,
        transferRecordId: transferId,
        createdAt: now,
      ),
    );

    final LedgerTransaction recipientLedger = await _appendLedgerTransaction(
      ownerUserId: recipientUserId,
      transaction: LedgerTransaction(
        id: IdGenerator.next(),
        reference: recipientReference,
        type: TransactionType.transfer,
        initiatedByUserId: ownerUserId,
        senderDisplayName: senderDisplayName,
        recipientUserId: recipientUserId,
        recipientDisplayName: recipientDisplayName,
        destinationWalletId: 'wallet_main',
        sourceCurrencyCode: currencyCode,
        sourceAmountMinor: amountMinor,
        note: note,
        transferRecordId: transferId,
        relatedTransactionId: senderLedger.id,
        createdAt: now,
      ),
    );

    final UserTransfer senderTransfer = UserTransfer(
      id: transferId,
      senderUserId: ownerUserId,
      senderDisplayName: senderDisplayName,
      recipientUserId: recipientUserId,
      recipientDisplayName: recipientDisplayName,
      senderWalletId: senderWalletId,
      recipientWalletId: 'wallet_main',
      currencyCode: currencyCode,
      amountMinor: amountMinor,
      status: TransferStatus.completed,
      note: note,
      senderReference: senderReference,
      recipientReference: recipientReference,
      senderLedgerTransactionId: senderLedger.id,
      recipientLedgerTransactionId: recipientLedger.id,
      createdAt: now,
    );

    final List<UserTransfer> existingTransfers = await _loadCanonicalTransfers(
      ownerUserId,
    );
    await _saveCanonicalTransfers(
      List<UserTransfer>.from(existingTransfers)..add(senderTransfer),
    );
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: senderTransfer.id,
      type: SyncOperationType.userTransferCreate,
      payload: <String, dynamic>{
        'transferId': senderTransfer.id,
        'senderWalletId': senderWalletId,
        'recipientUserId': recipientUserId,
        'currencyCode': currencyCode,
        'amountMinor': amountMinor,
      },
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'transferSent',
      title: 'Transfer sent',
      message:
          'You sent ${AmountFormatter.formatMinor(amountMinor)} $currencyCode to $recipientDisplayName.',
      relatedEntityId: senderTransfer.id,
      relatedEntityType: 'transfer',
    );
    await _notificationPublisher.publish(
      ownerUserId: recipientUserId,
      type: 'transferReceived',
      title: 'Transfer received',
      message:
          'You received ${AmountFormatter.formatMinor(amountMinor)} $currencyCode from $senderDisplayName.',
      relatedEntityId: senderTransfer.id,
      relatedEntityType: 'transfer',
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.transferExecuted,
      entityId: senderTransfer.id,
      relatedEntityType: 'transfer',
    );

    return _toSummary(ownerUserId, senderTransfer);
  }

  @override
  Future<SettlementSummary> createDebtSettlement({
    required String ownerUserId,
    required String senderDisplayName,
    required String debtId,
    required String senderWalletId,
    required String recipientUserId,
    required String recipientDisplayName,
    required String currencyCode,
    required int amountMinor,
    String? note,
  }) async {
    final TransferSummary transfer = await createTransfer(
      ownerUserId: ownerUserId,
      senderDisplayName: senderDisplayName,
      senderWalletId: senderWalletId,
      recipientUserId: recipientUserId,
      recipientDisplayName: recipientDisplayName,
      currencyCode: currencyCode,
      amountMinor: amountMinor,
      note: note,
    );

    final debtSettlement = await _debtRepository.createSettlement(
      ownerUserId: ownerUserId,
      debtId: debtId,
      transferId: transfer.transfer.id,
      amountMinor: amountMinor,
      note: note,
    );

    final List<UserTransfer> canonicalTransfers = await _loadCanonicalTransfers(
      ownerUserId,
    );
    final List<UserTransfer> updatedTransfers = canonicalTransfers
        .map((UserTransfer item) {
          if (item.id != transfer.transfer.id) {
            return item;
          }
          return item.copyWith(linkedDebtSettlementId: debtSettlement.id);
        })
        .toList(growable: false);
    await _saveCanonicalTransfers(updatedTransfers);

    final List<LedgerTransaction> ownerLedger = await _ledgerStore
        .loadTransactions(ownerUserId);
    final List<LedgerTransaction> rewrittenOwnerLedger = ownerLedger
        .map((LedgerTransaction item) {
          if (item.transferRecordId != transfer.transfer.id) {
            return item;
          }
          return item.copyWith(debtSettlementId: debtSettlement.id);
        })
        .toList(growable: false);
    await _ledgerStore.saveTransactions(ownerUserId, rewrittenOwnerLedger);

    final List<LedgerTransaction> recipientLedger = await _ledgerStore
        .loadTransactions(recipientUserId);
    final List<LedgerTransaction> rewrittenRecipientLedger = recipientLedger
        .map((LedgerTransaction item) {
          if (item.transferRecordId != transfer.transfer.id) {
            return item;
          }
          return item.copyWith(debtSettlementId: debtSettlement.id);
        })
        .toList(growable: false);
    await _ledgerStore.saveTransactions(
      recipientUserId,
      rewrittenRecipientLedger,
    );

    final debtSummary = await _debtRepository.getDebtById(
      ownerUserId: ownerUserId,
      debtId: debtId,
    );
    if (debtSummary == null) {
      throw StateError('Debt summary was not found after settlement creation.');
    }

    return debtSummary.settlements.firstWhere(
      (SettlementSummary item) => item.settlement.id == debtSettlement.id,
    );
  }

  @override
  Future<List<TransferSummary>> fetchTransfers(String ownerUserId) async {
    final List<UserTransfer> transfers = await _loadTransfers(ownerUserId);
    final List<UserTransfer> orderedTransfers =
        List<UserTransfer>.from(transfers)
          ..sort((UserTransfer left, UserTransfer right) {
            return right.createdAt.compareTo(left.createdAt);
          });
    return orderedTransfers
        .map((UserTransfer item) => _toSummary(ownerUserId, item))
        .toList(growable: false);
  }

  @override
  Future<TransferSummary?> getTransferById({
    required String ownerUserId,
    required String transferId,
  }) async {
    final List<UserTransfer> transfers = await _loadTransfers(ownerUserId);
    final UserTransfer? transfer = transfers.cast<UserTransfer?>().firstWhere(
      (UserTransfer? item) => item?.id == transferId,
      orElse: () => null,
    );
    return transfer == null ? null : _toSummary(ownerUserId, transfer);
  }

  Map<String, dynamic> _migrateTransferJson(
    Map<String, dynamic> json, {
    String? ownerUserId,
  }) {
    final Map<String, dynamic> migrated = Map<String, dynamic>.from(json);
    migrated['currencyCode'] ??= (migrated.remove('currency') as String?)
        ?.toUpperCase();
    if (!migrated.containsKey('amountMinor')) {
      migrated['amountMinor'] = AmountFormatter.parseToMinor(
        (migrated.remove('amount') ?? '0').toString(),
      );
    }
    migrated['status'] ??= TransferStatus.completed.name;

    if (migrated.containsKey('senderReference') ||
        migrated.containsKey('recipientReference')) {
      return migrated;
    }

    final String? legacyOwnerUserId =
        ownerUserId ?? migrated.remove('ownerUserId') as String?;
    final Map<String, dynamic>? legacyReference =
        migrated.remove('reference') as Map<String, dynamic>?;
    final String? legacyLedgerTransactionId =
        migrated.remove('ledgerTransactionId') as String?;
    final String? mirroredLedgerTransactionId =
        migrated.remove('mirroredLedgerTransactionId') as String?;
    final bool isSenderProjection =
        legacyOwnerUserId == migrated['senderUserId'];

    if (isSenderProjection) {
      migrated['senderReference'] = legacyReference;
      migrated['senderLedgerTransactionId'] = legacyLedgerTransactionId;
      migrated['recipientLedgerTransactionId'] = mirroredLedgerTransactionId;
    } else {
      migrated['recipientReference'] = legacyReference;
      migrated['recipientLedgerTransactionId'] = legacyLedgerTransactionId;
      migrated['senderLedgerTransactionId'] = mirroredLedgerTransactionId;
    }
    return migrated;
  }

  List<UserTransfer> _mergeTransfers(
    List<UserTransfer> current,
    List<UserTransfer> incoming,
  ) {
    final Map<String, UserTransfer> merged = <String, UserTransfer>{
      for (final UserTransfer item in current) item.id: item,
    };

    for (final UserTransfer item in incoming) {
      final UserTransfer? existing = merged[item.id];
      if (existing == null) {
        merged[item.id] = item;
        continue;
      }
      merged[item.id] = existing.copyWith(
        senderReference: existing.senderReference ?? item.senderReference,
        recipientReference:
            existing.recipientReference ?? item.recipientReference,
        senderLedgerTransactionId:
            existing.senderLedgerTransactionId ??
            item.senderLedgerTransactionId,
        recipientLedgerTransactionId:
            existing.recipientLedgerTransactionId ??
            item.recipientLedgerTransactionId,
        linkedDebtSettlementId:
            existing.linkedDebtSettlementId ?? item.linkedDebtSettlementId,
      );
    }

    final List<UserTransfer> ordered = merged.values.toList(growable: false)
      ..sort((UserTransfer left, UserTransfer right) {
        return right.createdAt.compareTo(left.createdAt);
      });
    return ordered;
  }

  bool _sameTransferSet(List<UserTransfer> left, List<UserTransfer> right) {
    if (identical(left, right)) {
      return true;
    }
    if (left.length != right.length) {
      return false;
    }
    for (int index = 0; index < left.length; index += 1) {
      if (jsonEncode(left[index].toJson()) !=
          jsonEncode(right[index].toJson())) {
        return false;
      }
    }
    return true;
  }
}
