// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Contact _$ContactFromJson(Map<String, dynamic> json) => _Contact(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  kind: $enumDecode(_$ContactKindEnumMap, json['kind']),
  entityType:
      $enumDecodeNullable(_$ContactEntityTypeEnumMap, json['entityType']) ??
      ContactEntityType.person,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  emailAddress: json['emailAddress'] as String?,
  note: json['note'] as String?,
  imageUri: json['imageUri'] as String?,
  linkedUserId: json['linkedUserId'] as String?,
  futureLinkCandidate: json['futureLinkCandidate'] == null
      ? null
      : FutureLinkCandidate.fromJson(
          json['futureLinkCandidate'] as Map<String, dynamic>,
        ),
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$ContactToJson(_Contact instance) => <String, dynamic>{
  'id': instance.id,
  'ownerUserId': instance.ownerUserId,
  'kind': _$ContactKindEnumMap[instance.kind]!,
  'entityType': _$ContactEntityTypeEnumMap[instance.entityType]!,
  'name': instance.name,
  'phoneNumber': instance.phoneNumber,
  'emailAddress': instance.emailAddress,
  'note': instance.note,
  'imageUri': instance.imageUri,
  'linkedUserId': instance.linkedUserId,
  'futureLinkCandidate': instance.futureLinkCandidate,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
};

const _$ContactKindEnumMap = {
  ContactKind.registered: 'registered',
  ContactKind.external: 'external',
};

const _$ContactEntityTypeEnumMap = {
  ContactEntityType.person: 'person',
  ContactEntityType.business: 'business',
};
