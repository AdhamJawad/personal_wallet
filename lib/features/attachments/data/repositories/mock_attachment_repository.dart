import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/sync/enums/sync_operation_type.dart';
import '../../../../core/sync/repositories/sync_queue_repository.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../audit/domain/enums/audit_event_type.dart';
import '../../../audit/domain/services/audit_logger.dart';
import '../../domain/models/attachment.dart';
import '../../domain/models/attachment_draft.dart';
import '../../domain/models/attachment_reference.dart';
import 'local_attachment_repository.dart';

class MockAttachmentRepository implements LocalAttachmentRepository {
  MockAttachmentRepository({
    required LocalStore localStore,
    required SyncQueueRepository syncQueueRepository,
    required AuditLogger auditLogger,
  }) : _localStore = localStore,
       _syncQueueRepository = syncQueueRepository,
       _auditLogger = auditLogger;

  final LocalStore _localStore;
  final SyncQueueRepository _syncQueueRepository;
  final AuditLogger _auditLogger;

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
          (dynamic item) => Attachment.fromJson(item as Map<String, dynamic>),
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
    final List<Attachment> created = drafts
        .map((AttachmentDraft draft) {
          return Attachment(
            id: IdGenerator.next(),
            ownerUserId: ownerUserId,
            reference: reference,
            kind: draft.kind,
            fileName: draft.fileName,
            localUri: draft.localUri,
            mimeType: draft.mimeType,
            byteSize: draft.byteSize,
            createdAt: now,
            updatedAt: now,
          );
        })
        .toList(growable: false);

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
          'entityType': reference.type.name,
          'fileName': attachment.fileName,
          'localUri': attachment.localUri,
        },
      );
      await _auditLogger.log(
        ownerUserId: ownerUserId,
        type: AuditEventType.attachmentCreated,
        entityId: attachment.id,
        relatedEntityType: reference.type.name,
        metadata: <String, dynamic>{
          'entityId': reference.entityId,
          'fileName': attachment.fileName,
          'kind': attachment.kind.name,
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
              item.reference.type == reference.type &&
              item.reference.entityId == reference.entityId,
        )
        .toList(growable: false);
  }
}
