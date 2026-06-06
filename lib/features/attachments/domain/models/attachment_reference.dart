import 'package:freezed_annotation/freezed_annotation.dart';

import '../enums/attachment_reference_type.dart';

part 'attachment_reference.freezed.dart';
part 'attachment_reference.g.dart';

@freezed
abstract class AttachmentReference with _$AttachmentReference {
  const factory AttachmentReference({
    required AttachmentReferenceType type,
    required String entityId,
    String? label,
  }) = _AttachmentReference;

  factory AttachmentReference.fromJson(Map<String, dynamic> json) =>
      _$AttachmentReferenceFromJson(json);
}
