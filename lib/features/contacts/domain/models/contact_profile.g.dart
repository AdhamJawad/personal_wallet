// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'contact_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ContactProfile _$ContactProfileFromJson(
  Map<String, dynamic> json,
) => _ContactProfile(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  kind: $enumDecode(_$ContactKindEnumMap, json['kind']),
  displayName: json['displayName'] as String,
  linkedUserId: json['linkedUserId'] as String?,
  phoneNumber: json['phoneNumber'] as String?,
  qrToken: json['qrToken'] as String?,
  dualApprovalRequired: json['dualApprovalRequired'] as bool,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$ContactProfileToJson(_ContactProfile instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'kind': _$ContactKindEnumMap[instance.kind]!,
      'displayName': instance.displayName,
      'linkedUserId': instance.linkedUserId,
      'phoneNumber': instance.phoneNumber,
      'qrToken': instance.qrToken,
      'dualApprovalRequired': instance.dualApprovalRequired,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };

const _$ContactKindEnumMap = {
  ContactKind.registered: 'registered',
  ContactKind.external: 'external',
};
