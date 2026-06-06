import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/currency.dart';

part 'debt.freezed.dart';
part 'debt.g.dart';

@freezed
abstract class Debt with _$Debt {
  const factory Debt({
    required String id,
    required String ownerUserId,
    required String counterpartyContactId,
    required bool isOwedToMe,
    required Currency currency,
    required String originalAmount,
    String? note,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
    @DateTimeConverter() DateTime? completedAt,
  }) = _Debt;

  factory Debt.fromJson(Map<String, dynamic> json) => _$DebtFromJson(json);
}
