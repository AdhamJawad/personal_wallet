// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audit_event.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuditEvent _$AuditEventFromJson(Map<String, dynamic> json) => _AuditEvent(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  type: $enumDecode(_$AuditEventTypeEnumMap, json['type']),
  entityId: json['entityId'] as String,
  relatedEntityType: json['relatedEntityType'] as String,
  deviceIdentifier: json['deviceIdentifier'] as String?,
  syncStatus:
      $enumDecodeNullable(_$SyncOperationStatusEnumMap, json['syncStatus']) ??
      SyncOperationStatus.pending,
  metadata:
      json['metadata'] as Map<String, dynamic>? ?? const <String, dynamic>{},
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$AuditEventToJson(_AuditEvent instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'type': _$AuditEventTypeEnumMap[instance.type]!,
      'entityId': instance.entityId,
      'relatedEntityType': instance.relatedEntityType,
      'deviceIdentifier': instance.deviceIdentifier,
      'syncStatus': _$SyncOperationStatusEnumMap[instance.syncStatus]!,
      'metadata': instance.metadata,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };

const _$AuditEventTypeEnumMap = {
  AuditEventType.transactionCreated: 'transactionCreated',
  AuditEventType.debtCreated: 'debtCreated',
  AuditEventType.debtUpdated: 'debtUpdated',
  AuditEventType.debtRepaid: 'debtRepaid',
  AuditEventType.debtSettled: 'debtSettled',
  AuditEventType.debtClosed: 'debtClosed',
  AuditEventType.debtReopened: 'debtReopened',
  AuditEventType.transferExecuted: 'transferExecuted',
  AuditEventType.walletCreated: 'walletCreated',
  AuditEventType.walletRenamed: 'walletRenamed',
  AuditEventType.walletArchived: 'walletArchived',
  AuditEventType.contactCreated: 'contactCreated',
  AuditEventType.attachmentCreated: 'attachmentCreated',
};

const _$SyncOperationStatusEnumMap = {
  SyncOperationStatus.pending: 'pending',
  SyncOperationStatus.synced: 'synced',
  SyncOperationStatus.failed: 'failed',
  SyncOperationStatus.conflict: 'conflict',
};
