// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_balance_snapshot.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletBalanceSnapshot _$WalletBalanceSnapshotFromJson(
  Map<String, dynamic> json,
) => _WalletBalanceSnapshot(
  walletId: json['walletId'] as String,
  usdBalance: Money.fromJson(json['usdBalance'] as Map<String, dynamic>),
  sypBalance: Money.fromJson(json['sypBalance'] as Map<String, dynamic>),
  asOf: const DateTimeConverter().fromJson(json['asOf'] as String),
);

Map<String, dynamic> _$WalletBalanceSnapshotToJson(
  _WalletBalanceSnapshot instance,
) => <String, dynamic>{
  'walletId': instance.walletId,
  'usdBalance': instance.usdBalance,
  'sypBalance': instance.sypBalance,
  'asOf': const DateTimeConverter().toJson(instance.asOf),
};
