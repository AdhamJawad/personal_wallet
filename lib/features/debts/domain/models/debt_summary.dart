import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/enums/currency.dart';
import '../../../contacts/domain/models/contact.dart';
import 'debt.dart';
import 'debt_repayment.dart';
import 'settlement_summary.dart';

part 'debt_summary.freezed.dart';
part 'debt_summary.g.dart';

@freezed
abstract class DebtSummary with _$DebtSummary {
  const DebtSummary._();

  const factory DebtSummary({
    required Debt debt,
    required Contact contact,
    required List<DebtRepayment> repayments,
    @Default(<SettlementSummary>[]) List<SettlementSummary> settlements,
    required String repaidAmount,
    required String remainingAmount,
    required bool isCompleted,
    required Currency currency,
  }) = _DebtSummary;

  factory DebtSummary.fromJson(Map<String, dynamic> json) =>
      _$DebtSummaryFromJson(json);
}
