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
    final Map<String, num> usdTotals = <String, num>{
      for (final String walletId in walletIds) walletId: 0,
    };
    final Map<String, num> sypTotals = <String, num>{
      for (final String walletId in walletIds) walletId: 0,
    };

    void applyAmount(String walletId, Currency currency, num delta) {
      if (currency == Currency.usd) {
        usdTotals[walletId] = (usdTotals[walletId] ?? 0) + delta;
      } else {
        sypTotals[walletId] = (sypTotals[walletId] ?? 0) + delta;
      }
    }

    for (final LedgerTransaction transaction in transactions) {
      final num sourceAmount = num.tryParse(transaction.sourceAmount) ?? 0;
      final num destinationAmount =
          num.tryParse(transaction.destinationAmount ?? '0') ?? 0;

      switch (transaction.type) {
        case TransactionType.deposit:
          if (transaction.destinationWalletId != null) {
            applyAmount(
              transaction.destinationWalletId!,
              transaction.sourceCurrency,
              sourceAmount,
            );
          }
        case TransactionType.withdraw:
          if (transaction.sourceWalletId != null) {
            applyAmount(
              transaction.sourceWalletId!,
              transaction.sourceCurrency,
              -sourceAmount,
            );
          }
        case TransactionType.transfer:
          if (transaction.sourceWalletId != null) {
            applyAmount(
              transaction.sourceWalletId!,
              transaction.sourceCurrency,
              -sourceAmount,
            );
          }
          if (transaction.destinationWalletId != null) {
            applyAmount(
              transaction.destinationWalletId!,
              transaction.sourceCurrency,
              sourceAmount,
            );
          }
        case TransactionType.exchange:
          if (transaction.sourceWalletId != null) {
            applyAmount(
              transaction.sourceWalletId!,
              transaction.sourceCurrency,
              -sourceAmount,
            );
            if (transaction.destinationCurrency != null &&
                transaction.destinationAmount != null) {
              applyAmount(
                transaction.sourceWalletId!,
                transaction.destinationCurrency!,
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
            currency: Currency.usd,
            amount: (usdTotals[walletId] ?? 0).toString(),
          ),
          sypBalance: Money(
            currency: Currency.syp,
            amount: (sypTotals[walletId] ?? 0).toString(),
          ),
        ),
    };
  }
}
