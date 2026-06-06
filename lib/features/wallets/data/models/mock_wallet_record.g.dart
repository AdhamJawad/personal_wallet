// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_wallet_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MockWalletRecord _$MockWalletRecordFromJson(Map<String, dynamic> json) =>
    _MockWalletRecord(
      wallet: Wallet.fromJson(json['wallet'] as Map<String, dynamic>),
      usdBalance: json['usdBalance'] as String,
      sypBalance: json['sypBalance'] as String,
    );

Map<String, dynamic> _$MockWalletRecordToJson(_MockWalletRecord instance) =>
    <String, dynamic>{
      'wallet': instance.wallet,
      'usdBalance': instance.usdBalance,
      'sypBalance': instance.sypBalance,
    };
