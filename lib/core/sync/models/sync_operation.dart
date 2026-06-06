import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../core/utils/date_time_converter.dart';
import '../enums/sync_operation_status.dart';
import '../enums/sync_operation_type.dart';
import 'conflict_record.dart';

part 'sync_operation.freezed.dart';
part 'sync_operation.g.dart';

@freezed
abstract class SyncOperation with _$SyncOperation {
  const factory SyncOperation({
    required String id,
    required String ownerUserId,
    required String entityId,
    required SyncOperationType type,
    required SyncOperationStatus status,
    required Map<String, dynamic> payload,
    @Default(0) int retryCount,
    String? errorMessage,
    ConflictRecord? conflictRecord,
    @DateTimeConverter() DateTime? lastAttemptedAt,
    @DateTimeConverter() DateTime? syncedAt,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _SyncOperation;

  factory SyncOperation.fromJson(Map<String, dynamic> json) =>
      _$SyncOperationFromJson(json);
}
