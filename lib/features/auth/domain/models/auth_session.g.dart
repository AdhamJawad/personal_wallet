// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'auth_session.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_AuthSession _$AuthSessionFromJson(Map<String, dynamic> json) => _AuthSession(
  id: json['id'] as String,
  user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
  biometricUnlocked: json['biometricUnlocked'] as bool,
  issuedAt: const DateTimeConverter().fromJson(json['issuedAt'] as String),
  expiresAt: const DateTimeConverter().fromJson(json['expiresAt'] as String),
);

Map<String, dynamic> _$AuthSessionToJson(_AuthSession instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user': instance.user,
      'biometricUnlocked': instance.biometricUnlocked,
      'issuedAt': const DateTimeConverter().toJson(instance.issuedAt),
      'expiresAt': const DateTimeConverter().toJson(instance.expiresAt),
    };
