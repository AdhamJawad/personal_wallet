import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:personal_wallet/core/constants/app_constants.dart';
import 'package:personal_wallet/core/storage/local_store.dart';
import 'package:personal_wallet/core/sync/enums/conflict_resolution_strategy.dart';
import 'package:personal_wallet/core/sync/enums/sync_operation_status.dart';
import 'package:personal_wallet/core/sync/enums/sync_operation_type.dart';
import 'package:personal_wallet/core/sync/models/conflict_summary.dart';
import 'package:personal_wallet/core/sync/models/sync_operation.dart';
import 'package:personal_wallet/core/sync/repositories/sync_queue_repository.dart';
import 'package:personal_wallet/features/audit/domain/enums/audit_event_type.dart';
import 'package:personal_wallet/features/audit/domain/models/audit_event.dart';
import 'package:personal_wallet/features/audit/domain/repositories/audit_repository.dart';
import 'package:personal_wallet/features/audit/domain/services/audit_logger.dart';
import 'package:personal_wallet/features/contacts/data/repositories/mock_contact_repository.dart';
import 'package:personal_wallet/features/contacts/domain/models/contact.dart';
import 'package:personal_wallet/features/contacts/presentation/controllers/contact_state.dart';
import 'package:personal_wallet/shared/domain/enums/contact_entity_type.dart';
import 'package:personal_wallet/shared/domain/enums/contact_kind.dart';

void main() {
  group('ContactState.filteredContacts', () {
    final DateTime now = DateTime.utc(2026, 1, 1);
    final List<Contact> contacts = <Contact>[
      Contact(
        id: 'person_1',
        ownerUserId: 'owner',
        kind: ContactKind.external,
        entityType: ContactEntityType.person,
        name: 'Ali Hassan',
        phoneNumber: '+963 944 555111',
        emailAddress: 'ali@example.com',
        note: 'Family debt',
        createdAt: now,
        updatedAt: now,
      ),
      Contact(
        id: 'business_1',
        ownerUserId: 'owner',
        kind: ContactKind.external,
        entityType: ContactEntityType.business,
        name: 'Local Store',
        phoneNumber: '+963933123456',
        emailAddress: 'store@example.com',
        note: 'Supplier and repayment counterparty',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    test('filters by entity type', () {
      final ContactState state = ContactState(contacts: contacts);

      final List<Contact> businessContacts = state.filteredContacts(
        entityType: ContactEntityType.business,
      );
      final List<Contact> peopleContacts = state.filteredContacts(
        entityType: ContactEntityType.person,
      );

      expect(businessContacts.map((Contact item) => item.id), <String>[
        'business_1',
      ]);
      expect(peopleContacts.map((Contact item) => item.id), <String>[
        'person_1',
      ]);
    });

    test('searches across normalized phone and note fields', () {
      final ContactState state = ContactState(
        contacts: contacts,
        searchQuery: '944555111',
      );
      final ContactState noteState = ContactState(
        contacts: contacts,
        searchQuery: 'supplier',
      );

      expect(state.visibleContacts.map((Contact item) => item.id), <String>[
        'person_1',
      ]);
      expect(noteState.visibleContacts.map((Contact item) => item.id), <String>[
        'business_1',
      ]);
    });

    test('combines search and entity filtering', () {
      final ContactState state = ContactState(
        contacts: contacts,
        searchQuery: 'store',
      );

      expect(
        state.filteredContacts(entityType: ContactEntityType.person),
        isEmpty,
      );
      expect(
        state
            .filteredContacts(entityType: ContactEntityType.business)
            .map((Contact item) => item.id),
        <String>['business_1'],
      );
    });
  });

  group('MockContactRepository migrations', () {
    test('migrates seeded Local Store to business when legacy entityType is missing', () async {
      final _InMemoryLocalStore localStore = _InMemoryLocalStore();
      final MockContactRepository repository = MockContactRepository(
        localStore,
        _FakeSyncQueueRepository(),
        AuditLogger(_FakeAuditRepository()),
      );
      const String ownerUserId = 'owner';

      await localStore.write(
        boxName: AppConstants.contactsBox,
        key: ownerUserId,
        value: jsonEncode(<Map<String, dynamic>>[
          <String, dynamic>{
            'contact': <String, dynamic>{
              'id': 'contact_external_store',
              'ownerUserId': ownerUserId,
              'kind': 'external',
              'name': 'Local Store',
              'phoneNumber': '+963933123456',
              'emailAddress': 'store@example.com',
              'note': 'Supplier and repayment counterparty',
              'createdAt': '2026-01-01T00:00:00.000Z',
              'updatedAt': '2026-01-01T00:00:00.000Z',
            },
          },
        ]),
      );

      final List<Contact> contacts = await repository.fetchContacts(ownerUserId);

      expect(contacts.single.entityType, ContactEntityType.business);

      final String? storedValue = await localStore.read(
        boxName: AppConstants.contactsBox,
        key: ownerUserId,
      );
      expect(storedValue, isNotNull);
      final List<dynamic> decoded = jsonDecode(storedValue!) as List<dynamic>;
      final Map<String, dynamic> storedContact =
          (decoded.single as Map<String, dynamic>)['contact']
              as Map<String, dynamic>;
      expect(storedContact['entityType'], 'business');
    });
  });
}

class _InMemoryLocalStore implements LocalStore {
  final Map<String, Map<String, String>> _boxes = <String, Map<String, String>>{};

  @override
  Future<void> clearBox({required String boxName}) async {
    _boxes.remove(boxName);
  }

  @override
  Future<void> delete({required String boxName, required String key}) async {
    _boxes[boxName]?.remove(key);
  }

  @override
  Future<void> initialize() async {}

  @override
  Future<String?> read({required String boxName, required String key}) async {
    return _boxes[boxName]?[key];
  }

  @override
  Future<List<String>> readAll({required String boxName}) async {
    return _boxes[boxName]?.values.toList(growable: false) ?? <String>[];
  }

  @override
  Future<void> write({
    required String boxName,
    required String key,
    required String value,
  }) async {
    _boxes.putIfAbsent(boxName, () => <String, String>{})[key] = value;
  }
}

class _FakeSyncQueueRepository implements SyncQueueRepository {
  @override
  Future<SyncOperation> addOperation({
    required String ownerUserId,
    required String entityId,
    required SyncOperationType type,
    required Map<String, dynamic> payload,
  }) async {
    final DateTime now = DateTime.utc(2026, 1, 1);
    return SyncOperation(
      id: 'sync_1',
      ownerUserId: ownerUserId,
      entityId: entityId,
      type: type,
      status: SyncOperationStatus.pending,
      payload: payload,
      createdAt: now,
      updatedAt: now,
    );
  }

  @override
  Future<void> clearCompleted(String ownerUserId) async {}

  @override
  Future<List<ConflictSummary>> fetchConflicts(String ownerUserId) async {
    return <ConflictSummary>[];
  }

  @override
  Future<List<SyncOperation>> fetchOperations(String ownerUserId) async {
    return <SyncOperation>[];
  }

  @override
  Future<SyncOperation?> getOperationById({
    required String ownerUserId,
    required String operationId,
  }) async {
    return null;
  }

  @override
  Future<SyncOperation> markConflict({
    required String ownerUserId,
    required String operationId,
    required String entityId,
    required ConflictResolutionStrategy recommendedStrategy,
    required Map<String, dynamic> localPayload,
    Map<String, dynamic>? remotePayload,
    String? summary,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SyncOperation> markFailed({
    required String ownerUserId,
    required String operationId,
    required String errorMessage,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SyncOperation> markSynced({
    required String ownerUserId,
    required String operationId,
  }) {
    throw UnimplementedError();
  }

  @override
  Future<SyncOperation> retryOperation({
    required String ownerUserId,
    required String operationId,
  }) {
    throw UnimplementedError();
  }
}

class _FakeAuditRepository implements AuditRepository {
  @override
  Future<AuditEvent> createEvent({
    required String ownerUserId,
    required AuditEventType type,
    required String entityId,
    required String relatedEntityType,
    String? deviceIdentifier,
    Map<String, dynamic>? metadata,
  }) async {
    return AuditEvent(
      id: 'audit_1',
      ownerUserId: ownerUserId,
      type: type,
      entityId: entityId,
      relatedEntityType: relatedEntityType,
      deviceIdentifier: deviceIdentifier,
      metadata: metadata ?? <String, dynamic>{},
      createdAt: DateTime.utc(2026, 1, 1),
    );
  }

  @override
  Future<List<AuditEvent>> fetchEvents(String ownerUserId) async {
    return <AuditEvent>[];
  }
}
