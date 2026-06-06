// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'registered_contact.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_RegisteredContact _$RegisteredContactFromJson(
  Map<String, dynamic> json,
) => _RegisteredContact(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  linkedUserId: json['linkedUserId'] as String,
  name: json['name'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  note: json['note'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$RegisteredContactToJson(_RegisteredContact instance) =>
    <String, dynamic>{
      'id': instance.id,
      'ownerUserId': instance.ownerUserId,
      'linkedUserId': instance.linkedUserId,
      'name': instance.name,
      'phoneNumber': instance.phoneNumber,
      'note': instance.note,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };
