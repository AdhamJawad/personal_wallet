import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../auth/data/models/mock_auth_account.dart';
import '../../../auth/domain/models/app_user.dart';

class MockRegisteredUserDirectory {
  MockRegisteredUserDirectory(this._localStore);

  final LocalStore _localStore;

  Future<List<AppUser>> fetchUsers() async {
    final List<String> values = await _localStore.readAll(
      boxName: AppConstants.usersBox,
    );

    return values
        .map(
          (String item) => MockAuthAccount.fromJson(
            jsonDecode(item) as Map<String, dynamic>,
          ).user,
        )
        .toList(growable: false);
  }

  Future<AppUser?> getUserById(String userId) async {
    final List<AppUser> users = await fetchUsers();
    return users.cast<AppUser?>().firstWhere(
      (AppUser? item) => item?.id == userId,
      orElse: () => null,
    );
  }

  Future<AppUser?> getUserByPublicIdentifier(String publicIdentifier) async {
    final List<AppUser> users = await fetchUsers();
    return users.cast<AppUser?>().firstWhere(
      (AppUser? item) => item?.personalQrToken == publicIdentifier,
      orElse: () => null,
    );
  }
}
