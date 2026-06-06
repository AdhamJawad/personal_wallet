import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/attachment_kind.dart';

part 'attachment_draft.freezed.dart';
part 'attachment_draft.g.dart';

@freezed
abstract class AttachmentDraft with _$AttachmentDraft {
  const factory AttachmentDraft({
    required AttachmentKind kind,
    required String fileName,
    required String localUri,
    String? mimeType,
    int? byteSize,
  }) = _AttachmentDraft;

  factory AttachmentDraft.fromJson(Map<String, dynamic> json) =>
      _$AttachmentDraftFromJson(json);
}
