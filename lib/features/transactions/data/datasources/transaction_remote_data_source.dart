import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/ledger_transaction.dart';

abstract interface class TransactionRemoteDataSource
    implements RemoteDataSource {
  Future<LedgerTransaction> createDeposit({
    required String ownerUserId,
    required String walletId,
    required String currencyCode,
    required int amountMinor,
    String? note,
    String? attachmentLabel,
  });
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
  });
  Future<LedgerTransaction> createTransfer({
    required String ownerUserId,
    required String sourceWalletId,
    required String destinationWalletId,
    required String currencyCode,
    required int amountMinor,
    String? note,
  });
  Future<LedgerTransaction> createWithdraw({
    required String ownerUserId,
    required String walletId,
    required String currencyCode,
    required int amountMinor,
    String? note,
    String? attachmentLabel,
  });
  Future<List<LedgerTransaction>> fetchTransactions(String ownerUserId);
  Future<LedgerTransaction?> getTransactionById({
    required String ownerUserId,
    required String transactionId,
  });
}
