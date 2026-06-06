import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../../debts/domain/models/settlement_summary.dart';
import '../../../debts/domain/repositories/debt_repository.dart';
import '../../../notifications/domain/services/notification_publisher.dart';
import '../../../transactions/data/services/mock_ledger_store.dart';
import '../../../transactions/domain/models/ledger_transaction.dart';
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

  static String _transfersKey(String ownerUserId) => 'transfers.$ownerUserId';

  Future<List<UserTransfer>> _loadTransfers(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.transactionsBox,
      key: _transfersKey(ownerUserId),
    );

    if (rawValue == null || rawValue.isEmpty) {
      return const <UserTransfer>[];
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) =>
              UserTransfer.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> _saveTransfers(
    String ownerUserId,
    List<UserTransfer> transfers,
  ) async {
    await _localStore.write(
      boxName: AppConstants.transactionsBox,
      key: _transfersKey(ownerUserId),
      value: jsonEncode(
        transfers.map((UserTransfer item) => item.toJson()).toList(),
      ),
    );
  }

  TransferSummary _toSummary(String ownerUserId, UserTransfer transfer) {
    final bool isIncoming = transfer.senderUserId != ownerUserId;
    return TransferSummary(
      transfer: transfer,
      isIncoming: isIncoming,
      isDebtSettlement: transfer.linkedDebtSettlementId != null,
      counterpartyDisplayName: isIncoming
          ? transfer.senderDisplayName
          : transfer.recipientDisplayName,
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
    required Currency currency,
    required String amount,
    String? note,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final String transferId = IdGenerator.next();
    final senderReference = await _ledgerStore.nextReference(ownerUserId);
    final recipientReference = await _ledgerStore.nextReference(recipientUserId);

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
        sourceCurrency: currency,
        sourceAmount: amount,
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
        sourceCurrency: currency,
        sourceAmount: amount,
        note: note,
        transferRecordId: transferId,
        relatedTransactionId: senderLedger.id,
        createdAt: now,
      ),
    );

    final UserTransfer senderTransfer = UserTransfer(
      id: transferId,
      ownerUserId: ownerUserId,
      reference: senderReference,
      senderUserId: ownerUserId,
      senderDisplayName: senderDisplayName,
      recipientUserId: recipientUserId,
      recipientDisplayName: recipientDisplayName,
      senderWalletId: senderWalletId,
      recipientWalletId: 'wallet_main',
      currency: currency,
      amount: amount,
      note: note,
      ledgerTransactionId: senderLedger.id,
      mirroredLedgerTransactionId: recipientLedger.id,
      createdAt: now,
    );
    final UserTransfer recipientTransfer = senderTransfer.copyWith(
      ownerUserId: recipientUserId,
      reference: recipientReference,
      ledgerTransactionId: recipientLedger.id,
      mirroredLedgerTransactionId: senderLedger.id,
    );

    final List<UserTransfer> senderTransfers = await _loadTransfers(ownerUserId);
    await _saveTransfers(
      ownerUserId,
      List<UserTransfer>.from(senderTransfers)..add(senderTransfer),
    );

    final List<UserTransfer> recipientTransfers = await _loadTransfers(
      recipientUserId,
    );
    await _saveTransfers(
      recipientUserId,
      List<UserTransfer>.from(recipientTransfers)..add(recipientTransfer),
    );
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: senderTransfer.id,
      type: SyncOperationType.userTransferCreate,
      payload: <String, dynamic>{
        'transferId': senderTransfer.id,
        'senderWalletId': senderWalletId,
        'recipientUserId': recipientUserId,
        'currency': currency.name,
        'amount': amount,
      },
    );
    await _notificationPublisher.publish(
      ownerUserId: ownerUserId,
      type: 'transferSent',
      title: 'Transfer sent',
      message: 'You sent $amount ${currency.name.toUpperCase()} to $recipientDisplayName.',
      relatedEntityId: senderTransfer.id,
      relatedEntityType: 'transfer',
    );
    await _notificationPublisher.publish(
      ownerUserId: recipientUserId,
      type: 'transferReceived',
      title: 'Transfer received',
      message: 'You received $amount ${currency.name.toUpperCase()} from $senderDisplayName.',
      relatedEntityId: recipientTransfer.id,
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
    required Currency currency,
    required String amount,
    String? note,
  }) async {
    final TransferSummary transfer = await createTransfer(
      ownerUserId: ownerUserId,
      senderDisplayName: senderDisplayName,
      senderWalletId: senderWalletId,
      recipientUserId: recipientUserId,
      recipientDisplayName: recipientDisplayName,
      currency: currency,
      amount: amount,
      note: note,
    );

    final SettlementSummary settlement = await _debtRepository.createSettlement(
      ownerUserId: ownerUserId,
      debtId: debtId,
      transferId: transfer.transfer.id,
      ledgerTransactionId: transfer.transfer.ledgerTransactionId,
      transferReference: transfer.transfer.reference.value,
      amount: amount,
      note: note,
    );

    final List<UserTransfer> ownerTransfers = await _loadTransfers(ownerUserId);
    final List<UserTransfer> updatedOwnerTransfers = ownerTransfers
        .map((UserTransfer item) {
          if (item.id != transfer.transfer.id) {
            return item;
          }
          return item.copyWith(
            linkedDebtSettlementId: settlement.settlement.id,
          );
        })
        .toList(growable: false);
    await _saveTransfers(ownerUserId, updatedOwnerTransfers);

    final List<UserTransfer> recipientTransfers = await _loadTransfers(
      recipientUserId,
    );
    final List<UserTransfer> updatedRecipientTransfers = recipientTransfers
        .map((UserTransfer item) {
          if (item.id != transfer.transfer.id) {
            return item;
          }
          return item.copyWith(
            linkedDebtSettlementId: settlement.settlement.id,
          );
        })
        .toList(growable: false);
    await _saveTransfers(recipientUserId, updatedRecipientTransfers);

    final List<LedgerTransaction> ownerLedger = await _ledgerStore
        .loadTransactions(ownerUserId);
    final List<LedgerTransaction> rewrittenOwnerLedger = ownerLedger
        .map((LedgerTransaction item) {
          if (item.transferRecordId != transfer.transfer.id) {
            return item;
          }
          return item.copyWith(debtSettlementId: settlement.settlement.id);
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
          return item.copyWith(debtSettlementId: settlement.settlement.id);
        })
        .toList(growable: false);
    await _ledgerStore.saveTransactions(recipientUserId, rewrittenRecipientLedger);

    return settlement;
  }

  @override
  Future<List<TransferSummary>> fetchTransfers(String ownerUserId) async {
    final List<UserTransfer> transfers = await _loadTransfers(ownerUserId);
    final List<UserTransfer> orderedTransfers = List<UserTransfer>.from(transfers)
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
}
