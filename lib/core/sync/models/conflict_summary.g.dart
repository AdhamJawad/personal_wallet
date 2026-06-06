// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'conflict_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ConflictSummary _$ConflictSummaryFromJson(Map<String, dynamic> json) =>
    _ConflictSummary(
      operation: SyncOperation.fromJson(
        json['operation'] as Map<String, dynamic>,
      ),
      record: ConflictRecord.fromJson(json['record'] as Map<String, dynamic>),
      recommendedStrategy: $enumDecode(
        _$ConflictResolutionStrategyEnumMap,
        json['recommendedStrategy'],
      ),
    );

Map<String, dynamic> _$ConflictSummaryToJson(_ConflictSummary instance) =>
    <String, dynamic>{
      'operation': instance.operation,
      'record': instance.record,
      'recommendedStrategy':
          _$ConflictResolutionStrategyEnumMap[instance.recommendedStrategy]!,
    };

const _$ConflictResolutionStrategyEnumMap = {
  ConflictResolutionStrategy.clientWins: 'clientWins',
  ConflictResolutionStrategy.serverWins: 'serverWins',
  ConflictResolutionStrategy.manualReview: 'manualReview',
  ConflictResolutionStrategy.mergeLater: 'mergeLater',
};
