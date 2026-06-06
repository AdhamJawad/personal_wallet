// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Attachment _$AttachmentFromJson(Map<String, dynamic> json) => _Attachment(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  reference: AttachmentReference.fromJson(
    json['reference'] as Map<String, dynamic>,
  ),
  kind: $enumDecode(_$AttachmentKindEnumMap, json['kind']),
  fileName: json['fileName'] as String,
  localUri: json['localUri'] as String,
  mimeType: json['mimeType'] as String?,
  byteSize: (json['byteSize'] as num?)?.toInt(),
  checksum: json['checksum'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$AttachmentToJson(_Attachment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'reference': instance.reference,
      'kind': _$AttachmentKindEnumMap[instance.kind]!,
      'fileName': instance.fileName,
      'localUri': instance.localUri,
      'mimeType': instance.mimeType,
      'byteSize': instance.byteSize,
      'checksum': instance.checksum,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };

const _$AttachmentKindEnumMap = {
  AttachmentKind.image: 'image',
  AttachmentKind.receipt: 'receipt',
  AttachmentKind.proofOfPayment: 'proofOfPayment',
  AttachmentKind.supportingDocument: 'supportingDocument',
};
