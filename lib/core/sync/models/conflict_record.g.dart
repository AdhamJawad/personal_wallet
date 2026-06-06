// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conflict_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConflictRecord _$ConflictRecordFromJson(
  Map<String, dynamic> json,
) => _ConflictRecord(
  id: json['id'] as String,
  operationId: json['operationId'] as String,
  entityId: json['entityId'] as String,
  recommendedStrategy: $enumDecode(
    _$ConflictResolutionStrategyEnumMap,
    json['recommendedStrategy'],
  ),
  localPayload: json['localPayload'] as Map<String, dynamic>,
  remotePayload: json['remotePayload'] as Map<String, dynamic>?,
  summary: json['summary'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$ConflictRecordToJson(_ConflictRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'operationId': instance.operationId,
      'entityId': instance.entityId,
      'recommendedStrategy':
          _$ConflictResolutionStrategyEnumMap[instance.recommendedStrategy]!,
      'localPayload': instance.localPayload,
      'remotePayload': instance.remotePayload,
      'summary': instance.summary,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };

const _$ConflictResolutionStrategyEnumMap = {
  ConflictResolutionStrategy.clientWins: 'clientWins',
  ConflictResolutionStrategy.serverWins: 'serverWins',
  ConflictResolutionStrategy.manualReview: 'manualReview',
  ConflictResolutionStrategy.mergeLater: 'mergeLater',
};
