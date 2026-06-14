import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../domain/models/ledger_transaction.dart';
import 'local_transaction_repository.dart';
import '../services/mock_ledger_store.dart';

class MockTransactionRepository implements LocalTransactionRepository {
  MockTransactionRepository(
    this._ledgerStore,
    this._syncQueueRepository,
    this._auditLogger,
  );

  final MockLedgerStore _ledgerStore;
  final SyncQueueRepository _syncQueueRepository;
  final AuditLogger _auditLogger;

  Future<LedgerTransaction> _append(
    String ownerUserId,
    LedgerTransaction Function() createTransaction,
  ) async {
    final List<LedgerTransaction> transactions = await _ledgerStore
        .loadTransactions(ownerUserId);
    final LedgerTransaction transaction = createTransaction();

    final List<LedgerTransaction> updatedTransactions =
        List<LedgerTransaction>.from(transactions)..add(transaction);

    await _ledgerStore.saveTransactions(ownerUserId, updatedTransactions);
    return transaction;
  }

  @override
  Future<LedgerTransaction> createDeposit({
    required String ownerUserId,
    required String walletId,
    required String currencyCode,
    required int amountMinor,
    String? note,
    String? attachmentLabel,
  }) async {
    final reference = await _ledgerStore.nextReference(ownerUserId);

    return _append(ownerUserId, () {
      return LedgerTransaction(
        id: IdGenerator.next(),
        reference: reference,
        type: TransactionType.deposit,
        initiatedByUserId: ownerUserId,
        destinationWalletId: walletId,
        sourceCurrencyCode: currencyCode,
        sourceAmountMinor: amountMinor,
        note: note,
        attachmentLabel: attachmentLabel,
        createdAt: DateTime.now().toUtc(),
      );
    }).then((LedgerTransaction transaction) async {
      await _syncQueueRepository.addOperation(
        ownerUserId: ownerUserId,
        entityId: transaction.id,
        type: SyncOperationType.depositCreate,
        payload: <String, dynamic>{
          'walletId': walletId,
          'currencyCode': currencyCode,
          'amountMinor': amountMinor,
          'transactionId': transaction.id,
        },
      );
      await _auditLogger.log(
        ownerUserId: ownerUserId,
        type: AuditEventType.transactionCreated,
        entityId: transaction.id,
        relatedEntityType: 'transaction',
        metadata: <String, dynamic>{'type': 'deposit'},
      );
      return transaction;
    });
  }

  @override
  Future<LedgerTransaction> createExchange({
    required String ownerUserId,
    required String walletId,
    required String sourceCurrencyCode,
    required String destinationCurrencyCode,
    required int sourceAmountMinor,
    required String exchangeRate,
    required int destinationAmountMinor,
    String? note,
    String? attachmentLabel,
  }) async {
    final reference = await _ledgerStore.nextReference(ownerUserId);

    return _append(ownerUserId, () {
      return LedgerTransaction(
        id: IdGenerator.next(),
        reference: reference,
        type: TransactionType.exchange,
        initiatedByUserId: ownerUserId,
        sourceWalletId: walletId,
        sourceCurrencyCode: sourceCurrencyCode,
        destinationCurrencyCode: destinationCurrencyCode,
        sourceAmountMinor: sourceAmountMinor,
        destinationAmountMinor: destinationAmountMinor,
        exchangeRate: exchangeRate,
        note: note,
        attachmentLabel: attachmentLabel,
        createdAt: DateTime.now().toUtc(),
      );
    }).then((LedgerTransaction transaction) async {
      await _syncQueueRepository.addOperation(
        ownerUserId: ownerUserId,
        entityId: transaction.id,
        type: SyncOperationType.exchangeCreate,
        payload: <String, dynamic>{
          'walletId': walletId,
          'sourceCurrencyCode': sourceCurrencyCode,
          'destinationCurrencyCode': destinationCurrencyCode,
          'sourceAmountMinor': sourceAmountMinor,
          'exchangeRate': exchangeRate,
          'destinationAmountMinor': destinationAmountMinor,
          'transactionId': transaction.id,
        },
      );
      await _auditLogger.log(
        ownerUserId: ownerUserId,
        type: AuditEventType.transactionCreated,
        entityId: transaction.id,
        relatedEntityType: 'transaction',
        metadata: <String, dynamic>{'type': 'exchange'},
      );
      return transaction;
    });
  }

  @override
  Future<LedgerTransaction> createTransfer({
    required String ownerUserId,
    required String sourceWalletId,
    required String destinationWalletId,
    required String currencyCode,
    required int amountMinor,
    String? note,
  }) async {
    final reference = await _ledgerStore.nextReference(ownerUserId);

    return _append(ownerUserId, () {
      return LedgerTransaction(
        id: IdGenerator.next(),
        reference: reference,
        type: TransactionType.transfer,
        initiatedByUserId: ownerUserId,
        sourceWalletId: sourceWalletId,
        destinationWalletId: destinationWalletId,
        sourceCurrencyCode: currencyCode,
        sourceAmountMinor: amountMinor,
        note: note,
        createdAt: DateTime.now().toUtc(),
      );
    }).then((LedgerTransaction transaction) async {
      await _syncQueueRepository.addOperation(
        ownerUserId: ownerUserId,
        entityId: transaction.id,
        type: SyncOperationType.internalTransferCreate,
        payload: <String, dynamic>{
          'sourceWalletId': sourceWalletId,
          'destinationWalletId': destinationWalletId,
          'currencyCode': currencyCode,
          'amountMinor': amountMinor,
          'transactionId': transaction.id,
        },
      );
      await _auditLogger.log(
        ownerUserId: ownerUserId,
        type: AuditEventType.transactionCreated,
        entityId: transaction.id,
        relatedEntityType: 'transaction',
        metadata: <String, dynamic>{'type': 'internalTransfer'},
      );
      return transaction;
    });
  }

  @override
  Future<LedgerTransaction> createWithdraw({
    required String ownerUserId,
    required String walletId,
    required String currencyCode,
    required int amountMinor,
    String? note,
    String? attachmentLabel,
  }) async {
    final reference = await _ledgerStore.nextReference(ownerUserId);

    return _append(ownerUserId, () {
      return LedgerTransaction(
        id: IdGenerator.next(),
        reference: reference,
        type: TransactionType.withdraw,
        initiatedByUserId: ownerUserId,
        sourceWalletId: walletId,
        sourceCurrencyCode: currencyCode,
        sourceAmountMinor: amountMinor,
        note: note,
        attachmentLabel: attachmentLabel,
        createdAt: DateTime.now().toUtc(),
      );
    }).then((LedgerTransaction transaction) async {
      await _syncQueueRepository.addOperation(
        ownerUserId: ownerUserId,
        entityId: transaction.id,
        type: SyncOperationType.withdrawCreate,
        payload: <String, dynamic>{
          'walletId': walletId,
          'currencyCode': currencyCode,
          'amountMinor': amountMinor,
          'transactionId': transaction.id,
        },
      );
      await _auditLogger.log(
        ownerUserId: ownerUserId,
        type: AuditEventType.transactionCreated,
        entityId: transaction.id,
        relatedEntityType: 'transaction',
        metadata: <String, dynamic>{'type': 'withdraw'},
      );
      return transaction;
    });
  }

  @override
  Future<List<LedgerTransaction>> fetchTransactions(String ownerUserId) {
    return _ledgerStore.loadTransactions(ownerUserId);
  }

  @override
  Future<LedgerTransaction?> getTransactionById({
    required String ownerUserId,
    required String transactionId,
  }) async {
    final List<LedgerTransaction> transactions = await _ledgerStore
        .loadTransactions(ownerUserId);

    return transactions.cast<LedgerTransaction?>().firstWhere(
      (LedgerTransaction? item) => item?.id == transactionId,
      orElse: () => null,
    );
  }
}
