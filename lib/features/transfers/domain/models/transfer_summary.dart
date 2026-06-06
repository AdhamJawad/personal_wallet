import 'package:freezed_annotation/freezed_annotation.dart';

import 'user_transfer.dart';

part 'transfer_summary.freezed.dart';
part 'transfer_summary.g.dart';

@freezed
abstract class TransferSummary with _$TransferSummary {
  const TransferSummary._();

  const factory TransferSummary({
    required UserTransfer transfer,
    required bool isIncoming,
    required bool isDebtSettlement,
    required String counterpartyDisplayName,
  }) = _TransferSummary;

  factory TransferSummary.fromJson(Map<String, dynamic> json) =>
      _$TransferSummaryFromJson(json);
}
