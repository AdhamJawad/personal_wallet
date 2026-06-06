import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/debt_status.dart';

part 'debt_record.freezed.dart';
part 'debt_record.g.dart';

@freezed
abstract class DebtRecord with _$DebtRecord {
  const factory DebtRecord({
    required String id,
    required String lenderPartyId,
    required String borrowerPartyId,
    required Currency currency,
    required String principalAmount,
    required String repaidAmount,
    required DebtStatus status,
    String? note,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _DebtRecord;

  factory DebtRecord.fromJson(Map<String, dynamic> json) =>
      _$DebtRecordFromJson(json);
}
