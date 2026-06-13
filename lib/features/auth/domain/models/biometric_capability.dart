import 'package:freezed_annotation/freezed_annotation.dart';

part 'biometric_capability.freezed.dart';

@freezed
abstract class BiometricCapability with _$BiometricCapability {
  const BiometricCapability._();

  const factory BiometricCapability({
    @Default(false) bool isDeviceSupported,
    @Default(false) bool hasEnrolledBiometrics,
    @Default(false) bool hasFaceId,
    @Default(false) bool hasFingerprint,
  }) = _BiometricCapability;

  bool get canAuthenticate => isDeviceSupported && hasEnrolledBiometrics;

  bool get hasSingleFaceOnly => hasFaceId && !hasFingerprint;

  bool get hasSingleFingerprintOnly => hasFingerprint && !hasFaceId;
}
