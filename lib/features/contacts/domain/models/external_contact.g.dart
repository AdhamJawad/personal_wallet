// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'external_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ExternalContact _$ExternalContactFromJson(
  Map<String, dynamic> json,
) => _ExternalContact(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  note: json['note'] as String?,
  futureLinkCandidate: json['futureLinkCandidate'] == null
      ? null
      : FutureLinkCandidate.fromJson(
          json['futureLinkCandidate'] as Map<String, dynamic>,
        ),
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$ExternalContactToJson(_ExternalContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'note': instance.note,
      'futureLinkCandidate': instance.futureLinkCandidate,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };
