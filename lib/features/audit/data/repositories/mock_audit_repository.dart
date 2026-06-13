import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/enums/audit_event_type.dart';
import '../../domain/models/audit_event.dart';
import 'local_audit_repository.dart';

class MockAuditRepository implements LocalAuditRepository {
  MockAuditRepository(this._localStore);

  final LocalStore _localStore;

  static String _eventsKey(String ownerUserId) => 'audit.$ownerUserId';

  Future<List<AuditEvent>> _loadEvents(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.auditBox,
      key: _eventsKey(ownerUserId),
    );
    if (rawValue == null || rawValue.isEmpty) {
      return const <AuditEvent>[];
    }
    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) => AuditEvent.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
  }

  Future<void> _saveEvents(String ownerUserId, List<AuditEvent> events) async {
    await _localStore.write(
      boxName: AppConstants.auditBox,
      key: _eventsKey(ownerUserId),
      value: jsonEncode(
        events.map((AuditEvent item) => item.toJson()).toList(),
      ),
    );
  }

  @override
  Future<AuditEvent> createEvent({
    required String ownerUserId,
    required AuditEventType type,
    required String entityId,
    required String relatedEntityType,
    String? deviceIdentifier,
    Map<String, dynamic>? metadata,
  }) async {
    final AuditEvent event = AuditEvent(
      id: IdGenerator.next(),
      ownerUserId: ownerUserId,
      type: type,
      entityId: entityId,
      relatedEntityType: relatedEntityType,
      deviceIdentifier: deviceIdentifier,
      metadata: metadata ?? const <String, dynamic>{},
      createdAt: DateTime.now().toUtc(),
    );
    final List<AuditEvent> events = await _loadEvents(ownerUserId);
    await _saveEvents(ownerUserId, List<AuditEvent>.from(events)..add(event));
    return event;
  }

  @override
  Future<List<AuditEvent>> fetchEvents(String ownerUserId) async {
    final List<AuditEvent> events = await _loadEvents(ownerUserId);
    final List<AuditEvent> ordered = List<AuditEvent>.from(events)
      ..sort((AuditEvent left, AuditEvent right) {
        return right.createdAt.compareTo(left.createdAt);
      });
    return ordered;
  }
}
