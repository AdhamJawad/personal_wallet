import 'dart:convert';

import '../../../../core/security/pin_security.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../enums/lock_timeout_option.dart';
import '../models/auth_session.dart';

class AuthSessionManager {
  AuthSessionManager(this._secureStorageService);

  static const String _sessionKey = 'auth.session';
  static const String _backgroundedAtKey = 'auth.backgrounded_at';

  final SecureStorageService _secureStorageService;

  String _biometricEnabledKey(String accountKey) =>
      'auth.biometric.enabled.$accountKey';

  String _lockTimeoutKey(String accountKey) => 'auth.lock.timeout.$accountKey';

  String _normalizeAccountKey(String identifier) {
    return identifier.trim().replaceAll(RegExp(r'[^a-zA-Z0-9]'), '_');
  }

  String _pinHashKey(String accountKey) => 'auth.pin.hash.$accountKey';

  String _pinSaltKey(String accountKey) => 'auth.pin.salt.$accountKey';

  Future<void> clearAllAuthState() async {
    await Future.wait(<Future<void>>[
      _secureStorageService.delete(key: _sessionKey),
      _secureStorageService.delete(key: _backgroundedAtKey),
    ]);
  }

  Future<void> clearBackgroundTimestamp() async {
    await _secureStorageService.delete(key: _backgroundedAtKey);
  }

  Future<void> clearPin(String identifier) async {
    final String accountKey = _normalizeAccountKey(identifier);
    await Future.wait(<Future<void>>[
      _secureStorageService.delete(key: _pinHashKey(accountKey)),
      _secureStorageService.delete(key: _pinSaltKey(accountKey)),
    ]);
  }

  Future<void> clearSecurityPreferences(String identifier) async {
    final String accountKey = _normalizeAccountKey(identifier);
    await Future.wait(<Future<void>>[
      _secureStorageService.delete(key: _biometricEnabledKey(accountKey)),
      _secureStorageService.delete(key: _pinHashKey(accountKey)),
      _secureStorageService.delete(key: _pinSaltKey(accountKey)),
      _secureStorageService.delete(key: _lockTimeoutKey(accountKey)),
    ]);
  }

  Future<void> clearSession() async {
    await _secureStorageService.delete(key: _sessionKey);
  }

  Future<DateTime?> getBackgroundTimestamp() async {
    final String? rawValue = await _secureStorageService.read(
      key: _backgroundedAtKey,
    );
    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }
    return DateTime.tryParse(rawValue)?.toUtc();
  }

  Future<LockTimeoutOption> getLockTimeout(String identifier) async {
    final String accountKey = _normalizeAccountKey(identifier);
    final String? rawValue = await _secureStorageService.read(
      key: _lockTimeoutKey(accountKey),
    );
    return LockTimeoutOption.fromStorageValue(rawValue);
  }

  Future<bool> hasPin(String identifier) async {
    final String accountKey = _normalizeAccountKey(identifier);
    final String? pinHash = await _secureStorageService.read(
      key: _pinHashKey(accountKey),
    );
    final String? pinSalt = await _secureStorageService.read(
      key: _pinSaltKey(accountKey),
    );
    return (pinHash ?? '').isNotEmpty && (pinSalt ?? '').isNotEmpty;
  }

  Future<bool> isBiometricEnabled(String identifier) async {
    final String accountKey = _normalizeAccountKey(identifier);
    final String? rawValue = await _secureStorageService.read(
      key: _biometricEnabledKey(accountKey),
    );
    return rawValue == 'true';
  }

  Future<void> persistBackgroundTimestamp(DateTime value) async {
    await _secureStorageService.write(
      key: _backgroundedAtKey,
      value: value.toUtc().toIso8601String(),
    );
  }

  Future<void> persistLockTimeout(
    String identifier,
    LockTimeoutOption value,
  ) async {
    final String accountKey = _normalizeAccountKey(identifier);
    await _secureStorageService.write(
      key: _lockTimeoutKey(accountKey),
      value: value.storageValue,
    );
  }

  Future<void> persistPin(String identifier, String pin) async {
    final String accountKey = _normalizeAccountKey(identifier);
    final String salt = PinSecurity.generateSalt();
    final String pinHash = PinSecurity.hashPin(pin: pin, salt: salt);
    await Future.wait(<Future<void>>[
      _secureStorageService.write(key: _pinSaltKey(accountKey), value: salt),
      _secureStorageService.write(key: _pinHashKey(accountKey), value: pinHash),
    ]);
  }

  Future<void> persistSession(AuthSession session) async {
    await _secureStorageService.write(
      key: _sessionKey,
      value: jsonEncode(session.toJson()),
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

  Future<void> setBiometricEnabled(String identifier, bool enabled) async {
    final String accountKey = _normalizeAccountKey(identifier);
    await _secureStorageService.write(
      key: _biometricEnabledKey(accountKey),
      value: enabled.toString(),
    );
  }

  Future<bool> validatePin(String identifier, String pin) async {
    final String accountKey = _normalizeAccountKey(identifier);
    final String? salt = await _secureStorageService.read(
      key: _pinSaltKey(accountKey),
    );
    final String? storedHash = await _secureStorageService.read(
      key: _pinHashKey(accountKey),
    );
    if ((salt ?? '').isEmpty || (storedHash ?? '').isEmpty) {
      return false;
    }

    final String candidateHash = PinSecurity.hashPin(pin: pin, salt: salt!);
    return candidateHash == storedHash;
  }
}
