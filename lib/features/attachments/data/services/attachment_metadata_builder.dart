import 'dart:convert';
import 'dart:io';

import 'package:crypto/crypto.dart';

import '../../domain/models/attachment_draft.dart';
import '../../domain/models/attachment_reference.dart';

class AttachmentMetadataBuilder {
  const AttachmentMetadataBuilder();

  Future<String?> resolveChecksum(AttachmentDraft draft) async {
    final File file = File(draft.localUri);
    if (!await file.exists()) {
      return null;
    }
    final List<int> bytes = await file.readAsBytes();
    return sha256.convert(bytes).toString();
  }

  String resolveStoragePath({
    required String ownerUserId,
    required AttachmentReference reference,
    required String attachmentId,
    required String fileName,
  }) {
    final String normalizedFileName = _normalizeSegment(fileName);
    return 'attachments/'
        '${_normalizeSegment(ownerUserId)}/'
        '${reference.entityType.name}/'
        '${_normalizeSegment(reference.entityId)}/'
        '$attachmentId/'
        '$normalizedFileName';
  }

  String resolveLegacyStoragePath({
    required String ownerUserId,
    required AttachmentReference reference,
    required String attachmentId,
    required String fileName,
  }) {
    return resolveStoragePath(
      ownerUserId: ownerUserId,
      reference: reference,
      attachmentId: attachmentId,
      fileName: fileName,
    );
  }

  String _normalizeSegment(String value) {
    final String sanitized = value
        .trim()
        .replaceAll(RegExp(r'[\\/:*?"<>|]'), '_')
        .replaceAll(RegExp(r'\s+'), '_');
    return sanitized.isEmpty ? base64Url.encode(utf8.encode(value)) : sanitized;
  }
}
