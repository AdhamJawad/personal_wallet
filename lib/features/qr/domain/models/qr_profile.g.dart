// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QrProfile _$QrProfileFromJson(Map<String, dynamic> json) => _QrProfile(
  userId: json['userId'] as String,
  transferToken: json['transferToken'] as String,
  contactToken: json['contactToken'] as String,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$QrProfileToJson(_QrProfile instance) =>
    <String, dynamic>{
      'userId': instance.userId,
      'transferToken': instance.transferToken,
      'contactToken': instance.contactToken,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };
