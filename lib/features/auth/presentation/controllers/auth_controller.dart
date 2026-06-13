import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_auth_repository.dart';
import '../../domain/enums/app_lock_status.dart';
import '../../domain/enums/auth_status.dart';
import '../../domain/enums/lock_timeout_option.dart';
import '../../domain/enums/otp_flow_type.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_flow.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../domain/services/auth_session_manager.dart';
import '../../domain/services/biometric_auth_service.dart';
import 'auth_operation_result.dart';
import 'auth_state.dart';

class AuthController extends StateNotifier<AuthState> {
  AuthController({
    required AuthRepository authRepository,
    required AuthSessionManager authSessionManager,
    required BiometricAuthService biometricAuthService,
  }) : _authRepository = authRepository,
       _authSessionManager = authSessionManager,
       _biometricAuthService = biometricAuthService,
       super(const AuthState()) {
    initialize();
  }

  final AuthRepository _authRepository;
  final AuthSessionManager _authSessionManager;
  final BiometricAuthService _biometricAuthService;

  Future<void> _applyAuthenticatedSession(
    AuthSession session, {
    required bool shouldRequirePinSetup,
    required bool promptBiometricSetup,
  }) async {
    final bool isBiometricEnabled = await _authSessionManager
        .isBiometricEnabled();
    final LockTimeoutOption lockTimeout = await _authSessionManager
        .getLockTimeout();

    state = state.copyWith(
      status: AuthStatus.authenticated,
      session: session.copyWith(
        user: session.user.copyWith(biometricEnabled: isBiometricEnabled),
      ),
      pendingOtpFlow: null,
      isBusy: false,
      isBiometricEnabled: isBiometricEnabled,
      isPinConfigured: !shouldRequirePinSetup,
      lockTimeout: lockTimeout,
      appLockStatus: shouldRequirePinSetup
          ? AppLockStatus.setupRequired
          : promptBiometricSetup
          ? AppLockStatus.biometricSetupRequired
          : AppLockStatus.unlocked,
    );
  }

  Future<void> initialize() async {
    final biometricCapability = await _biometricAuthService.getCapability();
    final AuthSession? restoredSession = await _authSessionManager
        .restoreSession();
    final bool isBiometricEnabled = await _authSessionManager
        .isBiometricEnabled();
    final bool isPinConfigured = await _authSessionManager.hasPin();
    final LockTimeoutOption lockTimeout = await _authSessionManager
        .getLockTimeout();

    state = state.copyWith(
      status: restoredSession == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated,
      session: restoredSession,
      biometricCapability: biometricCapability,
      isBiometricEnabled: isBiometricEnabled,
      isPinConfigured: isPinConfigured,
      lockTimeout: lockTimeout,
      appLockStatus: restoredSession == null
          ? AppLockStatus.unlocked
          : isPinConfigured
          ? AppLockStatus.locked
          : AppLockStatus.setupRequired,
    );
  }

  Future<AuthOperationResult> changePin({
    required String currentPin,
    required String newPin,
  }) async {
    final AuthSession? session = state.session;
    if (session == null || !state.isPinConfigured) {
      return AuthOperationResult.failure('pin_setup_required');
    }

    state = state.copyWith(isBusy: true);

    final bool isCurrentPinValid = await _authSessionManager.validatePin(
      currentPin,
    );
    if (!isCurrentPinValid) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure('current_pin_invalid');
    }

    await _authSessionManager.persistPin(newPin);
    state = state.copyWith(
      isBusy: false,
      appLockStatus: AppLockStatus.unlocked,
    );
    return AuthOperationResult.success('pin_changed_successfully');
  }

  Future<AuthOperationResult> disablePin({required String currentPin}) async {
    if (!state.isPinConfigured) {
      return AuthOperationResult.failure('pin_setup_required');
    }

    state = state.copyWith(isBusy: true);
    final bool isCurrentPinValid = await _authSessionManager.validatePin(
      currentPin,
    );

    if (!isCurrentPinValid) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure('current_pin_invalid');
    }

    await _authSessionManager.clearPin();
    await _authSessionManager.setBiometricEnabled(false);

    state = state.copyWith(
      isBusy: false,
      isPinConfigured: false,
      isBiometricEnabled: false,
      appLockStatus: AppLockStatus.setupRequired,
    );

    return AuthOperationResult.success('pin_disabled_successfully');
  }

  Future<void> handleAppBackgrounded() async {
    if (state.status != AuthStatus.authenticated || !state.isPinConfigured) {
      return;
    }

    await _authSessionManager.persistBackgroundTimestamp(
      DateTime.now().toUtc(),
    );
  }

  Future<void> handleAppResumed() async {
    if (state.status != AuthStatus.authenticated ||
        !state.isPinConfigured ||
        state.appLockStatus != AppLockStatus.unlocked) {
      await _authSessionManager.clearBackgroundTimestamp();
      return;
    }

    final DateTime? backgroundedAt = await _authSessionManager
        .getBackgroundTimestamp();
    await _authSessionManager.clearBackgroundTimestamp();

    if (backgroundedAt == null) {
      return;
    }

    if (state.lockTimeout == LockTimeoutOption.immediate) {
      lockApp();
      return;
    }

    final Duration elapsed = DateTime.now().toUtc().difference(
      backgroundedAt.toUtc(),
    );
    if (elapsed >= state.lockTimeout.duration) {
      lockApp();
    }
  }

  Future<AuthOperationResult> login({required String phoneNumber}) async {
    state = state.copyWith(isBusy: true);

    try {
      await _authRepository.requestLoginOtp(
        LoginRequest(phoneNumber: phoneNumber.trim()),
      );

      state = state.copyWith(
        status: AuthStatus.awaitingOtp,
        pendingOtpFlow: PendingOtpFlow(
          type: OtpFlowType.signIn,
          challenge: PendingOtpVerification(
            verificationId: phoneNumber.trim(),
            phoneNumber: phoneNumber.trim(),
            createdAt: DateTime.now().toUtc(),
          ),
        ),
        isBusy: false,
      );

      return AuthOperationResult.success('otp_sent_successfully');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false, status: AuthStatus.unauthenticated);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> logout() async {
    final String? sessionId = state.session?.id;

    if (sessionId != null) {
      await _authRepository.logout(sessionId);
    }

    await _authSessionManager.clearAllAuthState();

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      session: null,
      pendingOtpFlow: null,
      isBusy: false,
      isBiometricEnabled: false,
      isPinConfigured: false,
      appLockStatus: AppLockStatus.unlocked,
    );

    return AuthOperationResult.success('logged_out_successfully');
  }

  void lockApp() {
    if (state.status != AuthStatus.authenticated || !state.isPinConfigured) {
      return;
    }
    state = state.copyWith(appLockStatus: AppLockStatus.locked);
  }

  Future<AuthOperationResult> register({
    required String fullName,
    required String phoneNumber,
    String? emailAddress,
  }) async {
    state = state.copyWith(isBusy: true);

    try {
      final PendingOtpVerification pendingVerification = await _authRepository
          .register(
            RegisterRequest(
              fullName: fullName.trim(),
              phoneNumber: phoneNumber.trim(),
              emailAddress: emailAddress?.trim().isEmpty == true
                  ? null
                  : emailAddress?.trim(),
            ),
          );

      state = state.copyWith(
        status: AuthStatus.awaitingOtp,
        pendingOtpFlow: PendingOtpFlow(
          type: OtpFlowType.signUp,
          challenge: pendingVerification,
        ),
        isBusy: false,
      );

      return AuthOperationResult.success('otp_sent_successfully');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false, status: AuthStatus.unauthenticated);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> requestPinReset({
    required String phoneNumber,
  }) async {
    state = state.copyWith(isBusy: true);

    try {
      await _authRepository.requestPinReset(phoneNumber.trim());
      state = state.copyWith(
        status: AuthStatus.awaitingOtp,
        pendingOtpFlow: PendingOtpFlow(
          type: OtpFlowType.pinReset,
          challenge: PendingOtpVerification(
            verificationId: phoneNumber.trim(),
            phoneNumber: phoneNumber.trim(),
            createdAt: DateTime.now().toUtc(),
          ),
        ),
        isBusy: false,
      );
      return AuthOperationResult.success('otp_sent_successfully');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false, status: AuthStatus.unauthenticated);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> setLockTimeout(
    LockTimeoutOption lockTimeout,
  ) async {
    await _authSessionManager.persistLockTimeout(lockTimeout);
    state = state.copyWith(lockTimeout: lockTimeout);
    return AuthOperationResult.success('lock_timeout_updated');
  }

  Future<AuthOperationResult> setPin(
    String pin, {
    bool promptForBiometricSetup = false,
  }) async {
    final AuthSession? session = state.session;
    if (session == null) {
      return AuthOperationResult.failure('session_required');
    }

    state = state.copyWith(isBusy: true);
    await _authSessionManager.persistPin(pin);

    final bool shouldShowBiometricSetup =
        promptForBiometricSetup &&
        state.biometricCapability.canAuthenticate &&
        !state.isBiometricEnabled;

    state = state.copyWith(
      isBusy: false,
      isPinConfigured: true,
      appLockStatus: shouldShowBiometricSetup
          ? AppLockStatus.biometricSetupRequired
          : AppLockStatus.unlocked,
    );

    return AuthOperationResult.success('pin_saved_successfully');
  }

  Future<AuthOperationResult> skipBiometricSetup() async {
    if (state.appLockStatus != AppLockStatus.biometricSetupRequired) {
      return AuthOperationResult.failure('biometric_setup_not_pending');
    }

    state = state.copyWith(appLockStatus: AppLockStatus.unlocked);
    return AuthOperationResult.success('biometric_setup_skipped');
  }

  Future<AuthOperationResult> toggleBiometricLogin(bool enabled) async {
    if (state.session == null || !state.isPinConfigured) {
      return AuthOperationResult.failure('pin_setup_required');
    }

    if (enabled && !state.biometricCapability.canAuthenticate) {
      return AuthOperationResult.failure('biometric_not_available');
    }

    if (enabled) {
      final bool confirmed = await _biometricAuthService.authenticate(
        reason: 'Confirm biometric access for Personal Wallet.',
      );

      if (!confirmed) {
        return AuthOperationResult.failure('biometric_auth_failed');
      }
    }

    await _authSessionManager.setBiometricEnabled(enabled);

    final AuthSession updatedSession = state.session!.copyWith(
      user: state.session!.user.copyWith(biometricEnabled: enabled),
    );

    await _authSessionManager.persistSession(updatedSession);
    state = state.copyWith(
      session: updatedSession,
      isBiometricEnabled: enabled,
      appLockStatus: state.appLockStatus == AppLockStatus.biometricSetupRequired
          ? AppLockStatus.unlocked
          : state.appLockStatus,
    );

    return AuthOperationResult.success(
      enabled
          ? 'biometric_enabled_successfully'
          : 'biometric_disabled_successfully',
    );
  }

  Future<AuthOperationResult> unlockWithBiometrics() async {
    if (!state.canUseBiometricUnlock) {
      return AuthOperationResult.failure('biometric_not_available');
    }

    final bool didAuthenticate = await _biometricAuthService.authenticate(
      reason: 'Authenticate to unlock Personal Wallet.',
    );

    if (!didAuthenticate) {
      return AuthOperationResult.failure('biometric_auth_failed');
    }

    state = state.copyWith(appLockStatus: AppLockStatus.unlocked);
    return AuthOperationResult.success('app_unlocked');
  }

  Future<AuthOperationResult> unlockWithPin(String pin) async {
    final bool isPinValid = await _authSessionManager.validatePin(pin);
    if (!isPinValid) {
      return AuthOperationResult.failure('pin_invalid');
    }

    state = state.copyWith(appLockStatus: AppLockStatus.unlocked);
    return AuthOperationResult.success('app_unlocked');
  }

  Future<AuthOperationResult> updateProfile({
    required String displayName,
    required String? emailAddress,
    required String? profileImageUri,
  }) async {
    final AuthSession? session = state.session;
    if (session == null) {
      return AuthOperationResult.failure('session_required');
    }

    state = state.copyWith(isBusy: true);

    try {
      final updatedUser = await _authRepository.updateProfile(
        userId: session.user.id,
        displayName: displayName.trim(),
        emailAddress: emailAddress?.trim(),
        profileImageUri: profileImageUri?.trim(),
      );

      final AuthSession updatedSession = session.copyWith(user: updatedUser);
      await _authSessionManager.persistSession(updatedSession);

      state = state.copyWith(session: updatedSession, isBusy: false);
      return AuthOperationResult.success('profile_updated_successfully');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> verifyOtp({required String otpCode}) async {
    final PendingOtpFlow? pendingOtpFlow = state.pendingOtpFlow;

    if (pendingOtpFlow == null) {
      return AuthOperationResult.failure('otp_context_missing');
    }

    state = state.copyWith(isBusy: true);

    try {
      late final AuthSession session;
      late final bool shouldRequirePinSetup;
      late final bool promptBiometricSetup;
      late final String successMessageKey;

      switch (pendingOtpFlow.type) {
        case OtpFlowType.signIn:
          session = await _authRepository.verifyLoginOtp(
            phoneNumber: pendingOtpFlow.phoneNumber,
            otpCode: otpCode,
          );
          await _authSessionManager.persistSession(session);
          shouldRequirePinSetup = !await _authSessionManager.hasPin();
          promptBiometricSetup = false;
          successMessageKey = 'login_successful';
        case OtpFlowType.signUp:
          session = await _authRepository.verifyRegistrationOtp(
            pendingVerification: pendingOtpFlow.challenge,
            otpCode: otpCode,
          );
          await _authSessionManager.persistSession(session);
          shouldRequirePinSetup = true;
          promptBiometricSetup = false;
          successMessageKey = 'registration_completed';
        case OtpFlowType.pinReset:
          session = await _authRepository.verifyPinResetOtp(
            phoneNumber: pendingOtpFlow.phoneNumber,
            otpCode: otpCode,
          );
          await _authSessionManager.clearPin();
          await _authSessionManager.setBiometricEnabled(false);
          await _authSessionManager.persistSession(session);
          shouldRequirePinSetup = true;
          promptBiometricSetup = false;
          successMessageKey = 'pin_reset_verified';
      }

      await _applyAuthenticatedSession(
        session,
        shouldRequirePinSetup: shouldRequirePinSetup,
        promptBiometricSetup: promptBiometricSetup,
      );

      return AuthOperationResult.success(successMessageKey);
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(error.message);
    }
  }
}
