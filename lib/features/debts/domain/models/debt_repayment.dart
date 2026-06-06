import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';

part 'debt_repayment.freezed.dart';
part 'debt_repayment.g.dart';

@freezed
abstract class DebtRepayment with _$DebtRepayment {
  const factory DebtRepayment({
    required String id,
    required String debtId,
    required String amount,
    String? note,
    @DateTimeConverter() required DateTime createdAt,
  }) = _DebtRepayment;

  factory DebtRepayment.fromJson(Map<String, dynamic> json) =>
      _$DebtRepaymentFromJson(json);
}
