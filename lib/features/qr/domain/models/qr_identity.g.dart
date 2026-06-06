// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_identity.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QrIdentity _$QrIdentityFromJson(Map<String, dynamic> json) => _QrIdentity(
  userId: json['userId'] as String,
  displayName: json['displayName'] as String,
  publicReferenceIdentifier: json['publicReferenceIdentifier'] as String,
  payload: json['payload'] as String,
);

Map<String, dynamic> _$QrIdentityToJson(_QrIdentity instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'displayName': instance.displayName,
      'publicReferenceIdentifier': instance.publicReferenceIdentifier,
      'payload': instance.payload,
    };
