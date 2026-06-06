import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/auth_status.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/biometric_capability.dart';
import '../../domain/models/pending_otp_verification.dart';

part 'auth_state.freezed.dart';

@freezed
abstract class AuthState with _$AuthState {
  const AuthState._();

  const factory AuthState({
    @Default(AuthStatus.initializing) AuthStatus status,
    @Default(false) bool isBusy,
    AuthSession? session,
    PendingOtpVerification? pendingVerification,
    @Default(BiometricCapability()) BiometricCapability biometricCapability,
    @Default(false) bool isBiometricLoginEnabled,
    @Default(false) bool hasStoredCredential,
  }) = _AuthState;

  bool get canUseBiometricLogin =>
      isBiometricLoginEnabled &&
      hasStoredCredential &&
      biometricCapability.canAuthenticate;
}
