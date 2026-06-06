import 'package:freezed_annotation/freezed_annotation.dart';

import 'debt_settlement.dart';

part 'settlement_summary.freezed.dart';
part 'settlement_summary.g.dart';

@freezed
abstract class SettlementSummary with _$SettlementSummary {
  const factory SettlementSummary({
    required DebtSettlement settlement,
    required String transferReference,
    required String counterpartyDisplayName,
    required String remainingAmountAfterSettlement,
    required bool isCompleted,
  }) = _SettlementSummary;

  factory SettlementSummary.fromJson(Map<String, dynamic> json) =>
      _$SettlementSummaryFromJson(json);
}
