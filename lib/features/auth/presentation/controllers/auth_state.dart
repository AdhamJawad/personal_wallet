import '../../domain/enums/app_lock_status.dart';
import '../../domain/enums/auth_status.dart';
import '../../domain/enums/lock_timeout_option.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/biometric_capability.dart';
import '../../domain/models/pending_otp_flow.dart';

class AuthState {
  const AuthState({
    this.status = AuthStatus.initializing,
    this.isBusy = false,
    this.session,
    this.pendingOtpFlow,
    this.biometricCapability = const BiometricCapability(),
    this.isBiometricEnabled = false,
    this.isPinConfigured = false,
    this.lockTimeout = LockTimeoutOption.immediate,
    this.appLockStatus = AppLockStatus.unlocked,
  });

  final AuthStatus status;
  final bool isBusy;
  final AuthSession? session;
  final PendingOtpFlow? pendingOtpFlow;
  final BiometricCapability biometricCapability;
  final bool isBiometricEnabled;
  final bool isPinConfigured;
  final LockTimeoutOption lockTimeout;
  final AppLockStatus appLockStatus;

  AuthState copyWith({
    AuthStatus? status,
    bool? isBusy,
    AuthSession? session,
    Object? pendingOtpFlow = _sentinel,
    BiometricCapability? biometricCapability,
    bool? isBiometricEnabled,
    bool? isPinConfigured,
    LockTimeoutOption? lockTimeout,
    AppLockStatus? appLockStatus,
  }) {
    return AuthState(
      status: status ?? this.status,
      isBusy: isBusy ?? this.isBusy,
      session: session ?? this.session,
      pendingOtpFlow: identical(pendingOtpFlow, _sentinel)
          ? this.pendingOtpFlow
          : pendingOtpFlow as PendingOtpFlow?,
      biometricCapability: biometricCapability ?? this.biometricCapability,
      isBiometricEnabled: isBiometricEnabled ?? this.isBiometricEnabled,
      isPinConfigured: isPinConfigured ?? this.isPinConfigured,
      lockTimeout: lockTimeout ?? this.lockTimeout,
      appLockStatus: appLockStatus ?? this.appLockStatus,
    );
  }

  bool get canUseBiometricUnlock =>
      session != null &&
      isPinConfigured &&
      isBiometricEnabled &&
      biometricCapability.canAuthenticate;

  bool get isLocked => appLockStatus == AppLockStatus.locked;
}

const Object _sentinel = Object();
