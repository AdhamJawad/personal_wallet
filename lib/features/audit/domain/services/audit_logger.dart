import '../enums/audit_event_type.dart';
import '../repositories/audit_repository.dart';

class AuditLogger {
  const AuditLogger(this._auditRepository);

  final AuditRepository _auditRepository;

  Future<void> log({
    required String ownerUserId,
    required AuditEventType type,
    required String entityId,
    required String relatedEntityType,
    Map<String, dynamic>? metadata,
    String? deviceIdentifier,
  }) {
    return _auditRepository.createEvent(
      ownerUserId: ownerUserId,
      type: type,
      entityId: entityId,
      relatedEntityType: relatedEntityType,
      metadata: metadata,
      deviceIdentifier: deviceIdentifier,
    );
  }
}
