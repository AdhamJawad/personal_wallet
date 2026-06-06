import '../../../../core/network/remote_data_source.dart';
import '../../domain/enums/audit_event_type.dart';
import '../../domain/models/audit_event.dart';

abstract interface class AuditRemoteDataSource implements RemoteDataSource {
  Future<AuditEvent> createEvent({
    required String ownerUserId,
    required AuditEventType type,
    required String entityId,
    required String relatedEntityType,
    String? deviceIdentifier,
    Map<String, dynamic>? metadata,
  });
  Future<List<AuditEvent>> fetchEvents(String ownerUserId);
}
