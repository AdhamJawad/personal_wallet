import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/debt_summary.dart';

part 'debt_state.freezed.dart';

@freezed
abstract class DebtState with _$DebtState {
  const DebtState._();

  const factory DebtState({
    @Default(false) bool isLoading,
    @Default(<DebtSummary>[]) List<DebtSummary> debts,
    DebtSummary? selectedDebt,
    @Default(true) bool showOwedToMe,
    String? errorMessage,
  }) = _DebtState;

  List<DebtSummary> get visibleDebts {
    return debts
        .where((DebtSummary summary) {
          return summary.debt.isOwedToMe == showOwedToMe;
        })
        .toList(growable: false);
  }
}
