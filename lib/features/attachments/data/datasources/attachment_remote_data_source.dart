import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/attachment.dart';
import '../../domain/models/attachment_draft.dart';
import '../../domain/models/attachment_reference.dart';

abstract interface class AttachmentRemoteDataSource
    implements RemoteDataSource {
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
