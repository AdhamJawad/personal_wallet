// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wallet_activity_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_WalletActivityItem _$WalletActivityItemFromJson(Map<String, dynamic> json) =>
    _WalletActivityItem(
      id: json['id'] as String,
      title: json['title'] as String,
      subtitle: json['subtitle'] as String,
      walletId: json['walletId'] as String,
      walletName: json['walletName'] as String,
      occurredAt: const DateTimeConverter().fromJson(
        json['occurredAt'] as String,
      ),
    );

Map<String, dynamic> _$WalletActivityItemToJson(_WalletActivityItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'subtitle': instance.subtitle,
      'walletId': instance.walletId,
      'walletName': instance.walletName,
      'occurredAt': const DateTimeConverter().toJson(instance.occurredAt),
    };
