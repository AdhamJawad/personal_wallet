// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'attachment_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AttachmentReference _$AttachmentReferenceFromJson(Map<String, dynamic> json) =>
    _AttachmentReference(
      type: $enumDecode(_$AttachmentReferenceTypeEnumMap, json['type']),
      entityId: json['entityId'] as String,
      label: json['label'] as String?,
    );

Map<String, dynamic> _$AttachmentReferenceToJson(
  _AttachmentReference instance,
) => <String, dynamic>{
  'type': _$AttachmentReferenceTypeEnumMap[instance.type]!,
  'entityId': instance.entityId,
  'label': instance.label,
};

const _$AttachmentReferenceTypeEnumMap = {
  AttachmentReferenceType.transaction: 'transaction',
  AttachmentReferenceType.debt: 'debt',
  AttachmentReferenceType.debtSettlement: 'debtSettlement',
  AttachmentReferenceType.contact: 'contact',
};
