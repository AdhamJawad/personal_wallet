import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/date_time_converter.dart';
import '../enums/conflict_resolution_strategy.dart';

part 'conflict_record.freezed.dart';
part 'conflict_record.g.dart';

@freezed
abstract class ConflictRecord with _$ConflictRecord {
  const factory ConflictRecord({
    required String id,
    required String operationId,
    required String entityId,
    required ConflictResolutionStrategy recommendedStrategy,
    required Map<String, dynamic> localPayload,
    Map<String, dynamic>? remotePayload,
    String? summary,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _ConflictRecord;

  factory ConflictRecord.fromJson(Map<String, dynamic> json) =>
      _$ConflictRecordFromJson(json);
}
