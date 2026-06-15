import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../services/attachment_metadata_builder.dart';
import '../../domain/models/attachment.dart';
import '../../domain/models/attachment_draft.dart';
import '../../domain/models/attachment_reference.dart';
import 'local_attachment_repository.dart';

class MockAttachmentRepository implements LocalAttachmentRepository {
  MockAttachmentRepository({
    required LocalStore localStore,
    required SyncQueueRepository syncQueueRepository,
    required AuditLogger auditLogger,
    AttachmentMetadataBuilder metadataBuilder =
        const AttachmentMetadataBuilder(),
  }) : _localStore = localStore,
       _syncQueueRepository = syncQueueRepository,
       _auditLogger = auditLogger,
       _metadataBuilder = metadataBuilder;

  final LocalStore _localStore;
  final SyncQueueRepository _syncQueueRepository;
  final AuditLogger _auditLogger;
  final AttachmentMetadataBuilder _metadataBuilder;

  static String _attachmentsKey(String ownerUserId) =>
      'attachments.$ownerUserId';

  Future<List<Attachment>> _loadAttachments(String ownerUserId) async {
    final String? rawValue = await _localStore.read(
      boxName: AppConstants.attachmentsBox,
      key: _attachmentsKey(ownerUserId),
    );

    if (rawValue == null || rawValue.isEmpty) {
      return const <Attachment>[];
    }

    final List<dynamic> decoded = jsonDecode(rawValue) as List<dynamic>;
    return decoded
        .map(
          (dynamic item) => Attachment.fromJson(
            _migrateAttachmentJson(item as Map<String, dynamic>),
          ),
        )
        .toList(growable: false);
  }

  Future<void> _saveAttachments(
    String ownerUserId,
    List<Attachment> attachments,
  ) async {
    await _localStore.write(
      boxName: AppConstants.attachmentsBox,
      key: _attachmentsKey(ownerUserId),
      value: jsonEncode(
        attachments.map((Attachment item) => item.toJson()).toList(),
      ),
    );
  }

  @override
  Future<List<Attachment>> createAttachments({
    required String ownerUserId,
    required AttachmentReference reference,
    required List<AttachmentDraft> drafts,
  }) async {
    final DateTime now = DateTime.now().toUtc();
    final List<Attachment> existing = await _loadAttachments(ownerUserId);
    final List<Attachment> created = <Attachment>[];

    for (final AttachmentDraft draft in drafts) {
      final String attachmentId = IdGenerator.next();
      created.add(
        Attachment(
          id: attachmentId,
          ownerUserId: ownerUserId,
          reference: reference,
          kind: draft.kind,
          fileName: draft.fileName,
          storagePath: _metadataBuilder.resolveStoragePath(
            ownerUserId: ownerUserId,
            reference: reference,
            attachmentId: attachmentId,
            fileName: draft.fileName,
          ),
          mimeType: draft.mimeType,
          byteSize: draft.byteSize,
          checksum: await _metadataBuilder.resolveChecksum(draft),
          cacheLocalUri: draft.localUri,
          createdAt: now,
          updatedAt: now,
        ),
      );
    }

    await _saveAttachments(
      ownerUserId,
      List<Attachment>.from(existing)..addAll(created),
    );

    for (final Attachment attachment in created) {
      await _syncQueueRepository.addOperation(
        ownerUserId: ownerUserId,
        entityId: attachment.id,
        type: SyncOperationType.attachmentCreate,
        payload: <String, dynamic>{
          'attachmentId': attachment.id,
          'entityId': reference.entityId,
          'entityType': reference.entityType.name,
          'fileName': attachment.fileName,
          'storagePath': attachment.storagePath,
          'cacheLocalUri': attachment.cacheLocalUri,
          'checksum': attachment.checksum,
        },
      );
      await _auditLogger.log(
        ownerUserId: ownerUserId,
        type: AuditEventType.attachmentCreated,
        entityId: attachment.id,
        relatedEntityType: reference.entityType.name,
        metadata: <String, dynamic>{
          'entityId': reference.entityId,
          'fileName': attachment.fileName,
          'kind': attachment.kind.name,
          'storagePath': attachment.storagePath,
        },
      );
    }

    return created;
  }

  @override
  Future<List<Attachment>> fetchAttachments({
    required String ownerUserId,
    required AttachmentReference reference,
  }) async {
    final List<Attachment> attachments = await _loadAttachments(ownerUserId);
    return attachments
        .where(
          (Attachment item) =>
              item.reference.entityType == reference.entityType &&
              item.reference.entityId == reference.entityId,
        )
        .toList(growable: false);
  }

  Map<String, dynamic> _migrateAttachmentJson(Map<String, dynamic> json) {
    final Map<String, dynamic> migrated = Map<String, dynamic>.from(json);

    final Map<String, dynamic> reference = Map<String, dynamic>.from(
      migrated['reference'] as Map<String, dynamic>,
    );
    reference['entityType'] ??= reference.remove('type');
    migrated['reference'] = reference;

    if (!migrated.containsKey('storagePath')) {
      final String? legacyLocalUri = migrated['localUri'] as String?;
      migrated['storagePath'] = _metadataBuilder.resolveLegacyStoragePath(
        ownerUserId: migrated['ownerUserId'] as String,
        reference: AttachmentReference.fromJson(reference),
        attachmentId: migrated['id'] as String,
        fileName: migrated['fileName'] as String,
      );
      migrated['cacheLocalUri'] ??= legacyLocalUri;
    }

    migrated['cacheLocalUri'] ??= migrated.remove('localUri');
    return migrated;
  }
}
