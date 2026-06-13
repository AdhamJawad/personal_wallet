import 'dart:convert';

import '../../../../core/security/pin_security.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../enums/lock_timeout_option.dart';
import '../models/auth_session.dart';

class AuthSessionManager {
  AuthSessionManager(this._secureStorageService);

  static const String _sessionKey = 'auth.session';
  static const String _biometricEnabledKey = 'auth.biometric.enabled';
  static const String _pinHashKey = 'auth.pin.hash';
  static const String _pinSaltKey = 'auth.pin.salt';
  static const String _lockTimeoutKey = 'auth.lock.timeout';
  static const String _backgroundedAtKey = 'auth.backgrounded_at';

  final SecureStorageService _secureStorageService;

  Future<void> clearAllAuthState() async {
    await Future.wait(<Future<void>>[
      _secureStorageService.delete(key: _sessionKey),
      _secureStorageService.delete(key: _biometricEnabledKey),
      _secureStorageService.delete(key: _pinHashKey),
      _secureStorageService.delete(key: _pinSaltKey),
      _secureStorageService.delete(key: _lockTimeoutKey),
      _secureStorageService.delete(key: _backgroundedAtKey),
    ]);
  }

  Future<void> clearBackgroundTimestamp() async {
    await _secureStorageService.delete(key: _backgroundedAtKey);
  }

  Future<void> clearPin() async {
    await Future.wait(<Future<void>>[
      _secureStorageService.delete(key: _pinHashKey),
      _secureStorageService.delete(key: _pinSaltKey),
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

  Future<LockTimeoutOption> getLockTimeout() async {
    final String? rawValue = await _secureStorageService.read(
      key: _lockTimeoutKey,
    );
    return LockTimeoutOption.fromStorageValue(rawValue);
  }

  Future<bool> hasPin() async {
    final String? pinHash = await _secureStorageService.read(key: _pinHashKey);
    final String? pinSalt = await _secureStorageService.read(key: _pinSaltKey);
    return (pinHash ?? '').isNotEmpty && (pinSalt ?? '').isNotEmpty;
  }

  Future<bool> isBiometricEnabled() async {
    final String? rawValue = await _secureStorageService.read(
      key: _biometricEnabledKey,
    );
    return rawValue == 'true';
  }

  Future<void> persistBackgroundTimestamp(DateTime value) async {
    await _secureStorageService.write(
      key: _backgroundedAtKey,
      value: value.toUtc().toIso8601String(),
    );
  }

  Future<void> persistLockTimeout(LockTimeoutOption value) async {
    await _secureStorageService.write(
      key: _lockTimeoutKey,
      value: value.storageValue,
    );
  }

  Future<void> persistPin(String pin) async {
    final String salt = PinSecurity.generateSalt();
    final String pinHash = PinSecurity.hashPin(pin: pin, salt: salt);
    await Future.wait(<Future<void>>[
      _secureStorageService.write(key: _pinSaltKey, value: salt),
      _secureStorageService.write(key: _pinHashKey, value: pinHash),
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

  Future<void> setBiometricEnabled(bool enabled) async {
    await _secureStorageService.write(
      key: _biometricEnabledKey,
      value: enabled.toString(),
    );
  }

  Future<bool> validatePin(String pin) async {
    final String? salt = await _secureStorageService.read(key: _pinSaltKey);
    final String? storedHash = await _secureStorageService.read(
      key: _pinHashKey,
    );
    if ((salt ?? '').isEmpty || (storedHash ?? '').isEmpty) {
      return false;
    }

    final String candidateHash = PinSecurity.hashPin(pin: pin, salt: salt!);
    return candidateHash == storedHash;
  }
}
