import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/domain/enums/currency.dart';
import '../../domain/enums/transaction_filter_option.dart';
import '../../domain/enums/transaction_sort_option.dart';
import '../../domain/models/ledger_transaction.dart';
import '../../domain/repositories/transaction_repository.dart';
import 'transaction_state.dart';

class TransactionController extends StateNotifier<TransactionState> {
  TransactionController({
    required TransactionRepository transactionRepository,
    required String? ownerUserId,
  }) : _transactionRepository = transactionRepository,
       _ownerUserId = ownerUserId,
       super(const TransactionState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final TransactionRepository _transactionRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const TransactionControllerException(
        'No authenticated user found.',
      );
    }
    return ownerUserId;
  }

  Future<void> _reload({
    String? selectedTransactionId,
    bool preserveSelection = false,
  }) async {
    final List<LedgerTransaction> transactions = await _transactionRepository
        .fetchTransactions(_resolvedOwnerUserId);

    String? activeSelectionId = selectedTransactionId;
    if (preserveSelection && activeSelectionId == null) {
      activeSelectionId = state.selectedTransaction?.id;
    }

    final LedgerTransaction? selectedTransaction = activeSelectionId == null
        ? null
        : transactions.cast<LedgerTransaction?>().firstWhere(
            (LedgerTransaction? item) => item?.id == activeSelectionId,
            orElse: () => null,
          );

    state = state.copyWith(
      transactions: transactions,
      selectedTransaction: selectedTransaction,
      isLoading: false,
      errorMessage: null,
    );
  }

  Future<bool> createDeposit({
    required String walletId,
    required Currency currency,
    required String amount,
    String? note,
    String? attachmentLabel,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final LedgerTransaction transaction = await _transactionRepository
          .createDeposit(
            ownerUserId: _resolvedOwnerUserId,
            walletId: walletId,
            currency: currency,
            amount: amount,
            note: note,
            attachmentLabel: attachmentLabel,
          );
      await _reload(selectedTransactionId: transaction.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> createExchange({
    required String walletId,
    required Currency sourceCurrency,
    required Currency destinationCurrency,
    required String amountGiven,
    required String exchangeRate,
    required String amountReceived,
    String? note,
    String? attachmentLabel,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final LedgerTransaction transaction = await _transactionRepository
          .createExchange(
            ownerUserId: _resolvedOwnerUserId,
            walletId: walletId,
            sourceCurrency: sourceCurrency,
            destinationCurrency: destinationCurrency,
            amountGiven: amountGiven,
            exchangeRate: exchangeRate,
            amountReceived: amountReceived,
            note: note,
            attachmentLabel: attachmentLabel,
          );
      await _reload(selectedTransactionId: transaction.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> createTransfer({
    required String sourceWalletId,
    required String destinationWalletId,
    required Currency currency,
    required String amount,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final LedgerTransaction transaction = await _transactionRepository
          .createTransfer(
            ownerUserId: _resolvedOwnerUserId,
            sourceWalletId: sourceWalletId,
            destinationWalletId: destinationWalletId,
            currency: currency,
            amount: amount,
            note: note,
          );
      await _reload(selectedTransactionId: transaction.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> createWithdraw({
    required String walletId,
    required Currency currency,
    required String amount,
    String? note,
    String? attachmentLabel,
  }) async {
    state = state.copyWith(isLoading: true);
    try {
      final LedgerTransaction transaction = await _transactionRepository
          .createWithdraw(
            ownerUserId: _resolvedOwnerUserId,
            walletId: walletId,
            currency: currency,
            amount: amount,
            note: note,
            attachmentLabel: attachmentLabel,
          );
      await _reload(selectedTransactionId: transaction.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);
    try {
      await _reload();
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> loadTransaction(String transactionId) async {
    state = state.copyWith(isLoading: true);
    try {
      final LedgerTransaction? transaction = await _transactionRepository
          .getTransactionById(
            ownerUserId: _resolvedOwnerUserId,
            transactionId: transactionId,
          );
      await _reload(selectedTransactionId: transaction?.id);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void setFilter(TransactionFilterOption value) {
    state = state.copyWith(filterOption: value);
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSortOption(TransactionSortOption value) {
    state = state.copyWith(sortOption: value);
  }
}

class TransactionControllerException implements Exception {
  const TransactionControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
