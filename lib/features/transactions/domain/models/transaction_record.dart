import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';

part 'transaction_record.freezed.dart';
part 'transaction_record.g.dart';

@freezed
abstract class TransactionRecord with _$TransactionRecord {
  const factory TransactionRecord({
    required String id,
    required TransactionType type,
    required String initiatedByUserId,
    String? sourceWalletId,
    String? destinationWalletId,
    required String sourceAmount,
    required Currency sourceCurrency,
    String? destinationAmount,
    Currency? destinationCurrency,
    String? relatedTransactionId,
    String? note,
    @DateTimeConverter() required DateTime createdAt,
  }) = _TransactionRecord;

  factory TransactionRecord.fromJson(Map<String, dynamic> json) =>
      _$TransactionRecordFromJson(json);
}
