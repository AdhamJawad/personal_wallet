// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_overview.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletOverview _$WalletOverviewFromJson(Map<String, dynamic> json) =>
    _WalletOverview(
      wallet: Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      balance: WalletBalanceSnapshot.fromJson(
        json['balance'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$WalletOverviewToJson(_WalletOverview instance) =>
    <String, dynamic>{'wallet': instance.wallet, 'balance': instance.balance};
