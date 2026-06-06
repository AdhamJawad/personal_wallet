import '../models/attachment.dart';
import '../models/attachment_draft.dart';
import '../models/attachment_reference.dart';

abstract interface class AttachmentRepository {
  Future<List<Attachment>> createAttachments({
    required String ownerUserId,
    required AttachmentReference reference,
    required List<AttachmentDraft> drafts,
  });
  Future<List<Attachment>> fetchAttachments({
    required String ownerUserId,
    required AttachmentReference reference,
  });
}
