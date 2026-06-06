import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/currency.dart';

part 'debt_settlement.freezed.dart';
part 'debt_settlement.g.dart';

@freezed
abstract class DebtSettlement with _$DebtSettlement {
  const factory DebtSettlement({
    required String id,
    required String debtId,
    required String ownerUserId,
    required String transferId,
    required String ledgerTransactionId,
    required String transferReference,
    required Currency currency,
    required String amount,
    String? note,
    @DateTimeConverter() required DateTime createdAt,
  }) = _DebtSettlement;

  factory DebtSettlement.fromJson(Map<String, dynamic> json) =>
      _$DebtSettlementFromJson(json);
}
