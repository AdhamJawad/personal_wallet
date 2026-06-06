import 'dart:convert';

import '../../../../core/storage/secure_storage_service.dart';
import '../models/auth_session.dart';
import '../models/stored_auth_credential.dart';

class AuthSessionManager {
  AuthSessionManager(this._secureStorageService);

  static const String _sessionKey = 'auth.session';
  static const String _biometricEnabledKey = 'auth.biometric.enabled';
  static const String _storedCredentialKey = 'auth.biometric.credential';

  final SecureStorageService _secureStorageService;

  Future<void> clearSession() async {
    await _secureStorageService.delete(key: _sessionKey);
  }

  Future<StoredAuthCredential?> getStoredCredential() async {
    final String? rawValue = await _secureStorageService.read(
      key: _storedCredentialKey,
    );

    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    return StoredAuthCredential.fromJson(
      jsonDecode(rawValue) as Map<String, dynamic>,
    );
  }

  Future<bool> hasStoredCredential() async {
    return await getStoredCredential() != null;
  }

  Future<bool> isBiometricEnabled() async {
    final String? rawValue = await _secureStorageService.read(
      key: _biometricEnabledKey,
    );

    return rawValue == 'true';
  }

  Future<void> persistSession(AuthSession session) async {
    await _secureStorageService.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
    );
  }

  Future<void> persistStoredCredential(StoredAuthCredential credential) async {
    await _secureStorageService.write(
      key: _storedCredentialKey,
      value: jsonEncode(credential.toJson()),
    );
  }

  Future<AuthSession?> restoreSession() async {
    final String? rawValue = await _secureStorageService.read(key: _sessionKey);

    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    final AuthSession session = AuthSession.fromJson(
      jsonDecode(rawValue) as Map<String, dynamic>,
    );

    if (session.expiresAt.isBefore(DateTime.now().toUtc())) {
      await clearSession();
      return null;
    }

    return session;
  }

  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorageService.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }
}
