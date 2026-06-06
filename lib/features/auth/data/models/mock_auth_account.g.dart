// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_auth_account.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MockAuthAccount _$MockAuthAccountFromJson(Map<String, dynamic> json) =>
    _MockAuthAccount(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      password: json['password'] as String,
    );

Map<String, dynamic> _$MockAuthAccountToJson(_MockAuthAccount instance) =>
    <String, dynamic>{'user': instance.user, 'password': instance.password};
