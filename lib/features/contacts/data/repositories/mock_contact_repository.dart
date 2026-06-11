import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../shared/domain/enums/contact_entity_type.dart';
import '../../../../shared/domain/enums/contact_kind.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../domain/models/contact.dart';
import '../../domain/models/future_link_candidate.dart';
import 'local_contact_repository.dart';
import '../models/mock_contact_record.dart';

class MockContactRepository implements LocalContactRepository {
  MockContactRepository(
    this._localStore,
    this._syncQueueRepository,
    this._auditLogger,
  );

  final LocalStore _localStore;
  final SyncQueueRepository _syncQueueRepository;
  final AuditLogger _auditLogger;

  Future<List<MockContactRecord>> _loadRecords(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.contactsBox,
      key: ownerUserId,
    );

    if (rawValue == null || rawValue.isEmpty) {
      final List<MockContactRecord> seededRecords = _seedRecords(ownerUserId);
      await _saveRecords(ownerUserId, seededRecords);
      return seededRecords;
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    final _ContactRecordMigrationResult migrationResult =
        _migrateStoredContactRecords(decoded);
    final List<MockContactRecord> records = migrationResult.records
        .map(
          (dynamic item) =>
              MockContactRecord.fromJson(item as Map<String, dynamic>),
        )
        .toList(growable: false);
    if (migrationResult.didChange) {
      await _saveRecords(ownerUserId, records);
    }
    return records;
  }

  Future<void> _saveRecords(
    String ownerUserId,
    List<MockContactRecord> records,
  ) async {
    await _localStore.write(
      boxName: AppConstants.contactsBox,
      key: ownerUserId,
      value: jsonEncode(
        records.map((MockContactRecord record) => record.toJson()).toList(),
      ),
    );
  }

  _ContactRecordMigrationResult _migrateStoredContactRecords(
    List<dynamic> decoded,
  ) {
    bool didChange = false;
    final List<Map<String, dynamic>> migratedRecords = decoded.map((
      dynamic item,
    ) {
      final Map<String, dynamic> record = Map<String, dynamic>.from(
        item as Map<String, dynamic>,
      );
      final Map<String, dynamic> contact = Map<String, dynamic>.from(
        record['contact'] as Map<String, dynamic>,
      );
      final String? migratedEntityType = _migratedEntityType(contact);
      if (migratedEntityType != null &&
          contact['entityType'] != migratedEntityType) {
        contact['entityType'] = migratedEntityType;
        didChange = true;
      }
      record['contact'] = contact;
      return record;
    }).toList(growable: false);

    return _ContactRecordMigrationResult(
      records: migratedRecords,
      didChange: didChange,
    );
  }

  String? _migratedEntityType(Map<String, dynamic> contact) {
    final String? id = contact['id'] as String?;
    final String? currentEntityType = contact['entityType'] as String?;

    if (id == 'contact_external_store') {
      return 'business';
    }
    if (currentEntityType == null) {
      return 'person';
    }
    return null;
  }

  List<MockContactRecord> _seedRecords(String ownerUserId) {
    final DateTime now = DateTime.now().toUtc();

    return <MockContactRecord>[
      MockContactRecord(
        contact: Contact(
          id: 'contact_registered_ahmad',
          ownerUserId: ownerUserId,
          kind: ContactKind.registered,
          entityType: ContactEntityType.person,
          name: 'Ahmad Kareem',
          phoneNumber: '+963900000002',
          emailAddress: 'ahmad@example.com',
          note: 'Trusted registered user',
          linkedUserId: 'user_demo_2',
          createdAt: now.subtract(const Duration(days: 50)),
          updatedAt: now.subtract(const Duration(days: 3)),
        ),
      ),
      MockContactRecord(
        contact: Contact(
          id: 'contact_external_ali',
          ownerUserId: ownerUserId,
          kind: ContactKind.external,
          entityType: ContactEntityType.person,
          name: 'Ali',
          phoneNumber: '+963944555111',
          emailAddress: 'ali@example.com',
          note: 'Long-term personal debt contact',
          futureLinkCandidate: FutureLinkCandidate(
            externalContactId: 'contact_external_ali',
            ownerApprovalRequired: true,
            contactApprovalRequired: true,
            detectedAt: now.subtract(const Duration(days: 2)),
          ),
          createdAt: now.subtract(const Duration(days: 20)),
          updatedAt: now.subtract(const Duration(days: 2)),
        ),
      ),
      MockContactRecord(
        contact: Contact(
          id: 'contact_external_store',
          ownerUserId: ownerUserId,
          kind: ContactKind.external,
          entityType: ContactEntityType.business,
          name: 'Local Store',
          phoneNumber: '+963933123456',
          emailAddress: 'store@example.com',
          note: 'Supplier and repayment counterparty',
          createdAt: now.subtract(const Duration(days: 14)),
          updatedAt: now.subtract(const Duration(days: 1)),
        ),
      ),
    ];
  }

  @override
  Future<Contact> createExternalContact({
    required String ownerUserId,
    required ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<MockContactRecord> records = await _loadRecords(ownerUserId);
    final Contact contact = Contact(
      id: IdGenerator.next(),
      ownerUserId: ownerUserId,
      kind: ContactKind.external,
      entityType: entityType,
      name: name,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      note: note,
      imageUri: imageUri,
      futureLinkCandidate: phoneNumber == null || phoneNumber.isEmpty
          ? null
          : FutureLinkCandidate(
              externalContactId: '',
              ownerApprovalRequired: true,
              contactApprovalRequired: true,
              detectedAt: now,
            ),
      createdAt: now,
      updatedAt: now,
    );
    final Contact resolvedContact = contact.copyWith(
      futureLinkCandidate: contact.futureLinkCandidate?.copyWith(
        externalContactId: contact.id,
      ),
    );

    final List<MockContactRecord> updatedRecords = List<MockContactRecord>.from(
      records,
    )..add(MockContactRecord(contact: resolvedContact));
    await _saveRecords(ownerUserId, updatedRecords);
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: resolvedContact.id,
      type: SyncOperationType.externalContactCreate,
      payload: <String, dynamic>{
        'contactId': resolvedContact.id,
        'name': resolvedContact.name,
        'phoneNumber': resolvedContact.phoneNumber,
      },
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.contactCreated,
      entityId: resolvedContact.id,
      relatedEntityType: 'contact',
    );
    return resolvedContact;
  }

  @override
  Future<Contact> createRegisteredContact({
    required String ownerUserId,
    required String linkedUserId,
    required ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
  }) async {
    final Contact? existing = await getContactByLinkedUserId(
      ownerUserId: ownerUserId,
      linkedUserId: linkedUserId,
    );
    if (existing != null) {
      return existing;
    }

    final DateTime now = DateTime.now().toUtc();
    final List<MockContactRecord> records = await _loadRecords(ownerUserId);
    final Contact contact = Contact(
      id: IdGenerator.next(),
      ownerUserId: ownerUserId,
      kind: ContactKind.registered,
      entityType: entityType,
      name: name,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      note: note,
      imageUri: imageUri,
      linkedUserId: linkedUserId,
      createdAt: now,
      updatedAt: now,
    );
    await _saveRecords(
      ownerUserId,
      List<MockContactRecord>.from(records)
        ..add(MockContactRecord(contact: contact)),
    );
    await _syncQueueRepository.addOperation(
      ownerUserId: ownerUserId,
      entityId: contact.id,
      type: SyncOperationType.registeredContactCreate,
      payload: <String, dynamic>{
        'contactId': contact.id,
        'linkedUserId': linkedUserId,
        'name': name,
      },
    );
    await _auditLogger.log(
      ownerUserId: ownerUserId,
      type: AuditEventType.contactCreated,
      entityId: contact.id,
      relatedEntityType: 'contact',
    );
    return contact;
  }

  @override
  Future<List<Contact>> fetchContacts(String ownerUserId) async {
    return (await _loadRecords(ownerUserId))
        .map((MockContactRecord record) => record.contact)
        .toList(growable: false);
  }

  @override
  Future<Contact?> getContactById({
    required String ownerUserId,
    required String contactId,
  }) async {
    final List<Contact> contacts = await fetchContacts(ownerUserId);

    return contacts.cast<Contact?>().firstWhere(
      (Contact? item) => item?.id == contactId,
      orElse: () => null,
    );
  }

  @override
  Future<Contact?> getContactByLinkedUserId({
    required String ownerUserId,
    required String linkedUserId,
  }) async {
    final List<Contact> contacts = await fetchContacts(ownerUserId);

    return contacts.cast<Contact?>().firstWhere(
      (Contact? item) => item?.linkedUserId == linkedUserId,
      orElse: () => null,
    );
  }

  @override
  Future<Contact> updateContact({
    required String ownerUserId,
    required String contactId,
    required ContactEntityType entityType,
    required String name,
    String? phoneNumber,
    String? emailAddress,
    String? note,
    String? imageUri,
  }) async {
    final List<MockContactRecord> records = await _loadRecords(ownerUserId);
    final int index = records.indexWhere(
      (MockContactRecord item) => item.contact.id == contactId,
    );
    if (index == -1) {
      throw StateError('Contact not found.');
    }

    final Contact updatedContact = records[index].contact.copyWith(
      entityType: entityType,
      name: name,
      phoneNumber: phoneNumber,
      emailAddress: emailAddress,
      note: note,
      imageUri: imageUri,
      updatedAt: DateTime.now().toUtc(),
    );

    final List<MockContactRecord> updatedRecords = List<MockContactRecord>.from(
      records,
    );
    updatedRecords[index] = MockContactRecord(contact: updatedContact);
    await _saveRecords(ownerUserId, updatedRecords);
    return updatedContact;
  }

  @override
  Future<void> deleteContact({
    required String ownerUserId,
    required String contactId,
  }) async {
    final List<MockContactRecord> records = await _loadRecords(ownerUserId);
    final List<MockContactRecord> updatedRecords = records
        .where((MockContactRecord item) => item.contact.id != contactId)
        .toList(growable: false);
    await _saveRecords(ownerUserId, updatedRecords);
  }
}

class _ContactRecordMigrationResult {
  const _ContactRecordMigrationResult({
    required this.records,
    required this.didChange,
  });

  final List<Map<String, dynamic>> records;
  final bool didChange;
}
