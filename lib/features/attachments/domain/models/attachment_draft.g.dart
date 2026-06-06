// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentDraft _$AttachmentDraftFromJson(Map<String, dynamic> json) =>
    _AttachmentDraft(
      kind: $enumDecode(_$AttachmentKindEnumMap, json['kind']),
      fileName: json['fileName'] as String,
      localUri: json['localUri'] as String,
      mimeType: json['mimeType'] as String?,
      byteSize: (json['byteSize'] as num?)?.toInt(),
    );

Map<String, dynamic> _$AttachmentDraftToJson(_AttachmentDraft instance) =>
    <String, dynamic>{
      'kind': _$AttachmentKindEnumMap[instance.kind]!,
      'fileName': instance.fileName,
      'localUri': instance.localUri,
      'mimeType': instance.mimeType,
      'byteSize': instance.byteSize,
    };

const _$AttachmentKindEnumMap = {
  AttachmentKind.image: 'image',
  AttachmentKind.receipt: 'receipt',
  AttachmentKind.proofOfPayment: 'proofOfPayment',
  AttachmentKind.supportingDocument: 'supportingDocument',
};
