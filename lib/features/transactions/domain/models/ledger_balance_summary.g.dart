// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_balance_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerBalanceSummary _$LedgerBalanceSummaryFromJson(
  Map<String, dynamic> json,
) => _LedgerBalanceSummary(
  walletId: json['walletId'] as String,
  usdBalance: Money.fromJson(json['usdBalance'] as Map<String, dynamic>),
  sypBalance: Money.fromJson(json['sypBalance'] as Map<String, dynamic>),
);

Map<String, dynamic> _$LedgerBalanceSummaryToJson(
  _LedgerBalanceSummary instance,
) => <String, dynamic>{
  'walletId': instance.walletId,
  'usdBalance': instance.usdBalance,
  'sypBalance': instance.sypBalance,
};
