import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../../shared/domain/models/money.dart';
import '../models/ledger_balance_summary.dart';
import '../models/ledger_transaction.dart';

class BalanceCalculatorService {
  const BalanceCalculatorService();

  Map<String, LedgerBalanceSummary> calculateBalances(
    List<String> walletIds,
    List<LedgerTransaction> transactions,
  ) {
    final Map<String, int> usdTotals = <String, int>{
      for (final String walletId in walletIds) walletId: 0,
    };
    final Map<String, int> sypTotals = <String, int>{
      for (final String walletId in walletIds) walletId: 0,
    };

    void applyAmount(String walletId, String currencyCode, int delta) {
      if (currencyFromCode(currencyCode) == Currency.usd) {
        usdTotals[walletId] = (usdTotals[walletId] ?? 0) + delta;
      } else {
        sypTotals[walletId] = (sypTotals[walletId] ?? 0) + delta;
      }
    }

    for (final LedgerTransaction transaction in transactions) {
      final int sourceAmount = transaction.sourceAmountMinor;
      final int destinationAmount = transaction.destinationAmountMinor ?? 0;

      switch (transaction.type) {
        case TransactionType.deposit:
          if (transaction.destinationWalletId != null) {
            applyAmount(
              transaction.destinationWalletId!,
              transaction.sourceCurrencyCode,
              sourceAmount,
            );
          }
        case TransactionType.withdraw:
          if (transaction.sourceWalletId != null) {
            applyAmount(
              transaction.sourceWalletId!,
              transaction.sourceCurrencyCode,
              -sourceAmount,
            );
          }
        case TransactionType.transfer:
          if (transaction.sourceWalletId != null) {
            applyAmount(
              transaction.sourceWalletId!,
              transaction.sourceCurrencyCode,
              -sourceAmount,
            );
          }
          if (transaction.destinationWalletId != null) {
            applyAmount(
              transaction.destinationWalletId!,
              transaction.sourceCurrencyCode,
              sourceAmount,
            );
          }
        case TransactionType.exchange:
          if (transaction.sourceWalletId != null) {
            applyAmount(
              transaction.sourceWalletId!,
              transaction.sourceCurrencyCode,
              -sourceAmount,
            );
            if (transaction.destinationCurrencyCode != null &&
                transaction.destinationAmountMinor != null) {
              applyAmount(
                transaction.sourceWalletId!,
                transaction.destinationCurrencyCode!,
                destinationAmount,
              );
            }
          }
        case TransactionType.reversal:
        case TransactionType.correction:
      }
    }

    return <String, LedgerBalanceSummary>{
      for (final String walletId in walletIds)
        walletId: LedgerBalanceSummary(
          walletId: walletId,
          usdBalance: Money(
            amountMinor: usdTotals[walletId] ?? 0,
            currencyCode: Currency.usd.code,
          ),
          sypBalance: Money(
            amountMinor: sypTotals[walletId] ?? 0,
            currencyCode: Currency.syp.code,
          ),
        ),
    };
  }
}
