import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../contacts/domain/repositories/contact_repository.dart';
import '../../../transfers/data/services/mock_registered_user_directory.dart';
import '../../domain/models/qr_identity.dart';
import '../../domain/models/qr_scan_result.dart';
import 'local_qr_repository.dart';

class MockQrRepository implements LocalQrRepository {
  MockQrRepository({
    required LocalStore localStore,
    required ContactRepository contactRepository,
    required MockRegisteredUserDirectory registeredUserDirectory,
  }) : _localStore = localStore,
       _contactRepository = contactRepository,
       _registeredUserDirectory = registeredUserDirectory;

  final LocalStore _localStore;
  final ContactRepository _contactRepository;
  final MockRegisteredUserDirectory _registeredUserDirectory;

  static String _profileKey(String userId) => 'qr.identity.$userId';

  @override
  Future<QrIdentity> fetchIdentity({
    required String userId,
    required String displayName,
    required String publicReferenceIdentifier,
  }) async {
    final String payload = jsonEncode(<String, dynamic>{
      'userId': userId,
      'displayName': displayName,
      'publicReferenceIdentifier': publicReferenceIdentifier,
    });

    final QrIdentity identity = QrIdentity(
      userId: userId,
      displayName: displayName,
      publicReferenceIdentifier: publicReferenceIdentifier,
      payload: payload,
    );

    await _localStore.write(
      boxName: AppConstants.qrProfilesBox,
      key: _profileKey(userId),
      value: jsonEncode(identity.toJson()),
    );

    return identity;
  }

  @override
  Future<List<QrIdentity>> fetchKnownIdentities(String ownerUserId) async {
    final users = await _registeredUserDirectory.fetchUsers();
    return Future.wait(
      users
          .where((user) => user.id != ownerUserId)
          .map(
            (user) => fetchIdentity(
              userId: user.id,
              displayName: user.displayName,
              publicReferenceIdentifier: user.personalQrToken,
            ),
          ),
    );
  }

  @override
  Future<QrScanResult?> scanPayload({
    required String ownerUserId,
    required String payload,
  }) async {
    Map<String, dynamic> decoded;
    try {
      decoded = jsonDecode(payload) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }

    final String? userId = decoded['userId'] as String?;
    final String? displayName = decoded['displayName'] as String?;
    final String? publicReferenceIdentifier =
        decoded['publicReferenceIdentifier'] as String?;

    if (userId == null ||
        displayName == null ||
        publicReferenceIdentifier == null) {
      return null;
    }

    final user = await _registeredUserDirectory.getUserById(userId);
    if (user == null || user.personalQrToken != publicReferenceIdentifier) {
      return null;
    }

    final contact = await _contactRepository.getContactByLinkedUserId(
      ownerUserId: ownerUserId,
      linkedUserId: userId,
    );

    return QrScanResult(
      identity: await fetchIdentity(
        userId: user.id,
        displayName: user.displayName,
        publicReferenceIdentifier: user.personalQrToken,
      ),
      isSelf: user.id == ownerUserId,
      isKnownContact: contact != null,
      existingContactId: contact?.id,
    );
  }
}
