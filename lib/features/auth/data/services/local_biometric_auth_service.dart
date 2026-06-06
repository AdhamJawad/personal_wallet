import 'package:flutter/services.dart';
import 'package:local_auth/local_auth.dart';

import '../../domain/models/biometric_capability.dart';
import '../../domain/services/biometric_auth_service.dart';

class LocalBiometricAuthService implements BiometricAuthService {
  LocalBiometricAuthService() : _localAuthentication = LocalAuthentication();

  final LocalAuthentication _localAuthentication;

  @override
  Future<bool> authenticate({required String reason}) async {
    try {
      return await _localAuthentication.authenticate(
        localizedReason: reason,
        biometricOnly: true,
        persistAcrossBackgrounding: true,
      );
    } on LocalAuthException {
      return false;
    } on MissingPluginException {
      return false;
    }
  }

  @override
  Future<BiometricCapability> getCapability() async {
    try {
      final bool canCheckBiometrics =
          await _localAuthentication.canCheckBiometrics;
      final bool isDeviceSupported =
          canCheckBiometrics || await _localAuthentication.isDeviceSupported();
      final List<BiometricType> availableBiometrics = isDeviceSupported
          ? await _localAuthentication.getAvailableBiometrics()
          : const <BiometricType>[];

      return BiometricCapability(
        isDeviceSupported: isDeviceSupported,
        hasEnrolledBiometrics: availableBiometrics.isNotEmpty,
        hasFaceId:
            availableBiometrics.contains(BiometricType.face) ||
            availableBiometrics.contains(BiometricType.strong),
        hasFingerprint:
            availableBiometrics.contains(BiometricType.fingerprint) ||
            availableBiometrics.contains(BiometricType.strong) ||
            availableBiometrics.contains(BiometricType.weak),
      );
    } on LocalAuthException {
      return const BiometricCapability();
    } on MissingPluginException {
      return const BiometricCapability();
    }
  }
}
