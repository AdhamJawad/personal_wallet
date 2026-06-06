// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stored_auth_credential.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_StoredAuthCredential _$StoredAuthCredentialFromJson(
  Map<String, dynamic> json,
) => _StoredAuthCredential(
  phoneNumber: json['phoneNumber'] as String,
  password: json['password'] as String,
);

Map<String, dynamic> _$StoredAuthCredentialToJson(
  _StoredAuthCredential instance,
) => <String, dynamic>{
  'phoneNumber': instance.phoneNumber,
  'password': instance.password,
};
