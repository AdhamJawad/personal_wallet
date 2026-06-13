// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AppUser _$AppUserFromJson(Map<String, dynamic> json) => _AppUser(
  id: json['id'] as String,
  phoneNumber: json['phoneNumber'] as String,
  displayName: json['displayName'] as String,
  emailAddress: json['emailAddress'] as String?,
  profileImageUri: json['profileImageUri'] as String?,
  isVerified: json['isVerified'] as bool,
  biometricEnabled: json['biometricEnabled'] as bool,
  personalQrToken: json['personalQrToken'] as String,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$AppUserToJson(_AppUser instance) => <String, dynamic>{
  'id': instance.id,
  'phoneNumber': instance.phoneNumber,
  'displayName': instance.displayName,
  'emailAddress': instance.emailAddress,
  'profileImageUri': instance.profileImageUri,
  'isVerified': instance.isVerified,
  'biometricEnabled': instance.biometricEnabled,
  'personalQrToken': instance.personalQrToken,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
};
