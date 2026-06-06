import 'package:freezed_annotation/freezed_annotation.dart';

part 'stored_auth_credential.freezed.dart';
part 'stored_auth_credential.g.dart';

@freezed
abstract class StoredAuthCredential with _$StoredAuthCredential {
  const factory StoredAuthCredential({
    required String phoneNumber,
    required String password,
  }) = _StoredAuthCredential;

  factory StoredAuthCredential.fromJson(Map<String, dynamic> json) =>
      _$StoredAuthCredentialFromJson(json);
}
