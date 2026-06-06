import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../enums/attachment_kind.dart';
import 'attachment_reference.dart';

part 'attachment.freezed.dart';
part 'attachment.g.dart';

@freezed
abstract class Attachment with _$Attachment {
  const factory Attachment({
    required String id,
    required String ownerUserId,
    required AttachmentReference reference,
    required AttachmentKind kind,
    required String fileName,
    required String localUri,
    String? mimeType,
    int? byteSize,
    String? checksum,
    @DateTimeConverter() required DateTime createdAt,
    @DateTimeConverter() required DateTime updatedAt,
  }) = _Attachment;

  factory Attachment.fromJson(Map<String, dynamic> json) =>
      _$AttachmentFromJson(json);
}
