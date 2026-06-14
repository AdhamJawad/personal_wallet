import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/transaction_filter_option.dart';
import '../../domain/enums/transaction_sort_option.dart';
import '../../domain/models/ledger_transaction.dart';

part 'transaction_state.freezed.dart';

@freezed
abstract class TransactionState with _$TransactionState {
  const TransactionState._();

  const factory TransactionState({
    @Default(false) bool isLoading,
    @Default(<LedgerTransaction>[]) List<LedgerTransaction> transactions,
    LedgerTransaction? selectedTransaction,
    @Default('') String searchQuery,
    @Default(TransactionFilterOption.all) TransactionFilterOption filterOption,
    @Default(TransactionSortOption.newest) TransactionSortOption sortOption,
    String? errorMessage,
  }) = _TransactionState;

  List<LedgerTransaction> get visibleTransactions {
    final String normalizedQuery = searchQuery.trim().toLowerCase();
    final Iterable<LedgerTransaction>
    filteredTransactions = transactions.where((LedgerTransaction transaction) {
      final bool matchesFilter = switch (filterOption) {
        TransactionFilterOption.all => true,
        TransactionFilterOption.deposit => transaction.type.name == 'deposit',
        TransactionFilterOption.withdraw => transaction.type.name == 'withdraw',
        TransactionFilterOption.transfer => transaction.type.name == 'transfer',
        TransactionFilterOption.exchange => transaction.type.name == 'exchange',
      };

      if (!matchesFilter) {
        return false;
      }

      if (normalizedQuery.isEmpty) {
        return true;
      }

      return transaction.reference.value.toLowerCase().contains(
            normalizedQuery,
          ) ||
          (transaction.note ?? '').toLowerCase().contains(normalizedQuery) ||
          transaction.type.name.toLowerCase().contains(normalizedQuery);
    });

    final List<LedgerTransaction> sortedTransactions = filteredTransactions
        .toList();

    sortedTransactions.sort((LedgerTransaction left, LedgerTransaction right) {
      switch (sortOption) {
        case TransactionSortOption.newest:
          return right.createdAt.compareTo(left.createdAt);
        case TransactionSortOption.oldest:
          return left.createdAt.compareTo(right.createdAt);
        case TransactionSortOption.highestAmount:
          return right.sourceAmountMinor.compareTo(left.sourceAmountMinor);
        case TransactionSortOption.lowestAmount:
          return left.sourceAmountMinor.compareTo(right.sourceAmountMinor);
      }
    });

    return sortedTransactions;
  }
}
