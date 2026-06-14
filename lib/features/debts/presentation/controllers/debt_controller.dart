import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/utils/amount_formatter.dart';
import '../../domain/models/debt_summary.dart';
import '../../domain/repositories/debt_repository.dart';
import 'debt_state.dart';

class DebtController extends StateNotifier<DebtState> {
  DebtController({
    required DebtRepository debtRepository,
    required String? ownerUserId,
  }) : _debtRepository = debtRepository,
       _ownerUserId = ownerUserId,
       super(const DebtState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final DebtRepository _debtRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;
    if (ownerUserId == null) {
      throw const DebtControllerException('No authenticated user found.');
    }
    return ownerUserId;
  }

  Future<bool> createDebt({
    required String contactId,
    required bool isOwedToMe,
    required String currencyCode,
    required String amount,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final DebtSummary summary = await _debtRepository.createDebt(
        ownerUserId: _resolvedOwnerUserId,
        contactId: contactId,
        isOwedToMe: isOwedToMe,
        currencyCode: currencyCode,
        amountMinor: AmountFormatter.parseToMinor(amount),
        note: note,
      );
      await initialize(selectedDebtId: summary.debt.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> createRepayment({
    required String debtId,
    required String amount,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final DebtSummary summary = await _debtRepository.createRepayment(
        ownerUserId: _resolvedOwnerUserId,
        debtId: debtId,
        amountMinor: AmountFormatter.parseToMinor(amount),
        note: note,
      );
      await initialize(selectedDebtId: summary.debt.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> updateDebt({
    required String debtId,
    required String amount,
    String? note,
  }) async {
    state = state.copyWith(isLoading: true);

    try {
      final DebtSummary summary = await _debtRepository.updateDebt(
        ownerUserId: _resolvedOwnerUserId,
        debtId: debtId,
        amountMinor: AmountFormatter.parseToMinor(amount),
        note: note,
      );
      await initialize(selectedDebtId: summary.debt.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> closeDebt({required String debtId}) async {
    state = state.copyWith(isLoading: true);

    try {
      final DebtSummary summary = await _debtRepository.closeDebt(
        ownerUserId: _resolvedOwnerUserId,
        debtId: debtId,
      );
      await initialize(selectedDebtId: summary.debt.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<bool> reopenDebt({required String debtId}) async {
    state = state.copyWith(isLoading: true);

    try {
      final DebtSummary summary = await _debtRepository.reopenDebt(
        ownerUserId: _resolvedOwnerUserId,
        debtId: debtId,
      );
      await initialize(selectedDebtId: summary.debt.id);
      return true;
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
      return false;
    }
  }

  Future<void> initialize({String? selectedDebtId}) async {
    state = state.copyWith(isLoading: true);

    try {
      final List<DebtSummary> debts = await _debtRepository.fetchDebts(
        _resolvedOwnerUserId,
      );
      final DebtSummary? selectedDebt = selectedDebtId == null
          ? state.selectedDebt
          : debts.cast<DebtSummary?>().firstWhere(
              (DebtSummary? item) => item?.debt.id == selectedDebtId,
              orElse: () => null,
            );

      state = state.copyWith(
        debts: debts,
        selectedDebt: selectedDebt,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> loadDebt(String debtId) async {
    state = state.copyWith(isLoading: true);
    try {
      final DebtSummary? debt = await _debtRepository.getDebtById(
        ownerUserId: _resolvedOwnerUserId,
        debtId: debtId,
      );
      final List<DebtSummary> debts = await _debtRepository.fetchDebts(
        _resolvedOwnerUserId,
      );
      state = state.copyWith(
        debts: debts,
        selectedDebt: debt,
        isLoading: false,
        errorMessage: null,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  void setShowOwedToMe(bool value) {
    state = state.copyWith(showOwedToMe: value);
  }
}

class DebtControllerException implements Exception {
  const DebtControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
