import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/app_user.dart';

part 'mock_auth_account.freezed.dart';
part 'mock_auth_account.g.dart';

@freezed
abstract class MockAuthAccount with _$MockAuthAccount {
  const factory MockAuthAccount({
    required AppUser user,
    required String password,
  }) = _MockAuthAccount;

  factory MockAuthAccount.fromJson(Map<String, dynamic> json) =>
      _$MockAuthAccountFromJson(json);
}
