import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/sync/enums/sync_operation_status.dart';
import '../../../../core/utils/date_time_converter.dart';
import '../enums/audit_event_type.dart';

part 'audit_event.freezed.dart';
part 'audit_event.g.dart';

@freezed
abstract class AuditEvent with _$AuditEvent {
  const factory AuditEvent({
    required String id,
    required String ownerUserId,
    required AuditEventType type,
    required String entityId,
    required String relatedEntityType,
    String? deviceIdentifier,
    @Default(SyncOperationStatus.pending) SyncOperationStatus syncStatus,
    @Default(<String, dynamic>{}) Map<String, dynamic> metadata,
    @DateTimeConverter() required DateTime createdAt,
  }) = _AuditEvent;

  factory AuditEvent.fromJson(Map<String, dynamic> json) =>
      _$AuditEventFromJson(json);
}
