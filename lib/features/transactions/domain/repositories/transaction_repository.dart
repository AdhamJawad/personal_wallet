import '../../../../shared/domain/enums/currency.dart';
import '../models/ledger_transaction.dart';

abstract interface class TransactionRepository {
  Future<LedgerTransaction> createDeposit({
    required String ownerUserId,
    required String walletId,
    required Currency currency,
    required String amount,
    String? note,
    String? attachmentLabel,
  });
  Future<LedgerTransaction> createExchange({
    required String ownerUserId,
    required String walletId,
    required Currency sourceCurrency,
    required Currency destinationCurrency,
    required String amountGiven,
    required String exchangeRate,
    required String amountReceived,
    String? note,
    String? attachmentLabel,
  });
  Future<LedgerTransaction> createTransfer({
    required String ownerUserId,
    required String sourceWalletId,
    required String destinationWalletId,
    required Currency currency,
    required String amount,
    String? note,
  });
  Future<LedgerTransaction> createWithdraw({
    required String ownerUserId,
    required String walletId,
    required Currency currency,
    required String amount,
    String? note,
    String? attachmentLabel,
  });
  Future<List<LedgerTransaction>> fetchTransactions(String ownerUserId);
  Future<LedgerTransaction?> getTransactionById({
    required String ownerUserId,
    required String transactionId,
  });
}
