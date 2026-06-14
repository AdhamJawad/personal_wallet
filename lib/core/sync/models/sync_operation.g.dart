// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_operation.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SyncOperation _$SyncOperationFromJson(
  Map<String, dynamic> json,
) => _SyncOperation(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  entityId: json['entityId'] as String,
  type: $enumDecode(_$SyncOperationTypeEnumMap, json['type']),
  status: $enumDecode(_$SyncOperationStatusEnumMap, json['status']),
  payload: json['payload'] as Map<String, dynamic>,
  retryCount: (json['retryCount'] as num?)?.toInt() ?? 0,
  errorMessage: json['errorMessage'] as String?,
  conflictRecord: json['conflictRecord'] == null
      ? null
      : ConflictRecord.fromJson(json['conflictRecord'] as Map<String, dynamic>),
  lastAttemptedAt: _$JsonConverterFromJson<String, DateTime>(
    json['lastAttemptedAt'],
    const DateTimeConverter().fromJson,
  ),
  syncedAt: _$JsonConverterFromJson<String, DateTime>(
    json['syncedAt'],
    const DateTimeConverter().fromJson,
  ),
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$SyncOperationToJson(_SyncOperation instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'entityId': instance.entityId,
      'type': _$SyncOperationTypeEnumMap[instance.type]!,
      'status': _$SyncOperationStatusEnumMap[instance.status]!,
      'payload': instance.payload,
      'retryCount': instance.retryCount,
      'errorMessage': instance.errorMessage,
      'conflictRecord': instance.conflictRecord,
      'lastAttemptedAt': _$JsonConverterToJson<String, DateTime>(
        instance.lastAttemptedAt,
        const DateTimeConverter().toJson,
      ),
      'syncedAt': _$JsonConverterToJson<String, DateTime>(
        instance.syncedAt,
        const DateTimeConverter().toJson,
      ),
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };

const _$SyncOperationTypeEnumMap = {
  SyncOperationType.walletCreate: 'walletCreate',
  SyncOperationType.walletRename: 'walletRename',
  SyncOperationType.walletArchive: 'walletArchive',
  SyncOperationType.depositCreate: 'depositCreate',
  SyncOperationType.withdrawCreate: 'withdrawCreate',
  SyncOperationType.internalTransferCreate: 'internalTransferCreate',
  SyncOperationType.exchangeCreate: 'exchangeCreate',
  SyncOperationType.debtCreate: 'debtCreate',
  SyncOperationType.debtUpdate: 'debtUpdate',
  SyncOperationType.debtClose: 'debtClose',
  SyncOperationType.debtReopen: 'debtReopen',
  SyncOperationType.debtRepaymentCreate: 'debtRepaymentCreate',
  SyncOperationType.debtSettlementCreate: 'debtSettlementCreate',
  SyncOperationType.externalContactCreate: 'externalContactCreate',
  SyncOperationType.registeredContactCreate: 'registeredContactCreate',
  SyncOperationType.userTransferCreate: 'userTransferCreate',
  SyncOperationType.attachmentCreate: 'attachmentCreate',
};

const _$SyncOperationStatusEnumMap = {
  SyncOperationStatus.pending: 'pending',
  SyncOperationStatus.synced: 'synced',
  SyncOperationStatus.failed: 'failed',
  SyncOperationStatus.conflict: 'conflict',
};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
