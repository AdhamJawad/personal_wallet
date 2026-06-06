// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'notification_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_NotificationItem _$NotificationItemFromJson(Map<String, dynamic> json) =>
    _NotificationItem(
      id: json['id'] as String,
      ownerUserId: json['ownerUserId'] as String,
      type: $enumDecode(_$NotificationTypeEnumMap, json['type']),
      title: json['title'] as String,
      message: json['message'] as String,
      relatedEntityId: json['relatedEntityId'] as String?,
      relatedEntityType: json['relatedEntityType'] as String?,
      isRead: json['isRead'] as bool? ?? false,
      readAt: _$JsonConverterFromJson<String, DateTime>(
        json['readAt'],
        const DateTimeConverter().fromJson,
      ),
      createdAt: const DateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
    );

Map<String, dynamic> _$NotificationItemToJson(_NotificationItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'type': _$NotificationTypeEnumMap[instance.type]!,
      'title': instance.title,
      'message': instance.message,
      'relatedEntityId': instance.relatedEntityId,
      'relatedEntityType': instance.relatedEntityType,
      'isRead': instance.isRead,
      'readAt': _$JsonConverterToJson<String, DateTime>(
        instance.readAt,
        const DateTimeConverter().toJson,
      ),
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };

const _$NotificationTypeEnumMap = {
  NotificationType.transferReceived: 'transferReceived',
  NotificationType.transferSent: 'transferSent',
  NotificationType.debtCreated: 'debtCreated',
  NotificationType.debtRepaid: 'debtRepaid',
  NotificationType.debtSettled: 'debtSettled',
  NotificationType.walletCreated: 'walletCreated',
  NotificationType.syncFailure: 'syncFailure',
  NotificationType.syncSuccess: 'syncSuccess',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
