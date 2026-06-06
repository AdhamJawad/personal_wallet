import '../enums/audit_event_type.dart';
import '../models/audit_event.dart';

abstract interface class AuditRepository {
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
