import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/models/money.dart';

part 'ledger_balance_summary.freezed.dart';
part 'ledger_balance_summary.g.dart';

@freezed
abstract class LedgerBalanceSummary with _$LedgerBalanceSummary {
  const factory LedgerBalanceSummary({
    required String walletId,
    required Money usdBalance,
    required Money sypBalance,
  }) = _LedgerBalanceSummary;

  factory LedgerBalanceSummary.fromJson(Map<String, dynamic> json) =>
      _$LedgerBalanceSummaryFromJson(json);
}
