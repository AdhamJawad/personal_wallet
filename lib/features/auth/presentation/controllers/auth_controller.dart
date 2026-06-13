import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_auth_repository.dart';
import '../../domain/enums/auth_status.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';
import '../../domain/models/stored_auth_credential.dart';
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

  Future<bool> _refreshBiometricState({AuthSession? session}) async {
    final bool isBiometricEnabled = await _authSessionManager
        .isBiometricEnabled();
    final bool hasStoredCredential = await _authSessionManager
        .hasStoredCredential();

    state = state.copyWith(
      session: session ?? state.session,
      isBiometricLoginEnabled: isBiometricEnabled,
      hasStoredCredential: hasStoredCredential,
    );

    return isBiometricEnabled;
  }

  Future<AuthSession> _persistAuthenticatedSession({
    required AuthSession session,
    required StoredAuthCredential credential,
    required bool biometricUnlocked,
  }) async {
    final bool isBiometricEnabled = await _refreshBiometricState();
    final AuthSession resolvedSession = session.copyWith(
      biometricUnlocked: biometricUnlocked,
      user: session.user.copyWith(biometricEnabled: isBiometricEnabled),
    );

    await _authSessionManager.persistSession(resolvedSession);
    await _authSessionManager.persistStoredCredential(credential);

    return resolvedSession;
  }

  Future<void> initialize() async {
    final biometricCapability = await _biometricAuthService.getCapability();
    final AuthSession? restoredSession = await _authSessionManager
        .restoreSession();
    final bool isBiometricEnabled = await _authSessionManager
        .isBiometricEnabled();
    final bool hasStoredCredential = await _authSessionManager
        .hasStoredCredential();

    state = state.copyWith(
      status: restoredSession == null
          ? AuthStatus.unauthenticated
          : AuthStatus.authenticated,
      session: restoredSession,
      biometricCapability: biometricCapability,
      isBiometricLoginEnabled: isBiometricEnabled,
      hasStoredCredential: hasStoredCredential,
    );
  }

  Future<AuthOperationResult> login({
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(isBusy: true);

    try {
      final AuthSession session = await _authRepository.login(
        LoginRequest(phoneNumber: phoneNumber, password: password),
      );

      final AuthSession resolvedSession = await _persistAuthenticatedSession(
        session: session,
        credential: StoredAuthCredential(
          phoneNumber: phoneNumber,
          password: password,
        ),
        biometricUnlocked: false,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        session: resolvedSession,
        pendingVerification: null,
        isBusy: false,
      );

      return AuthOperationResult.success('Login successful.');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false, status: AuthStatus.unauthenticated);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> loginWithBiometrics() async {
    if (!state.canUseBiometricLogin) {
      return AuthOperationResult.failure(
        'Biometric login is not enabled on this device.',
      );
    }

    state = state.copyWith(isBusy: true);

    final bool didAuthenticate = await _biometricAuthService.authenticate(
      reason: 'Authenticate to access Personal Wallet.',
    );

    if (!didAuthenticate) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(
        'Biometric authentication failed. Use your password instead.',
      );
    }

    final StoredAuthCredential? credential = await _authSessionManager
        .getStoredCredential();

    if (credential == null) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(
        'No saved credentials were found for biometric login.',
      );
    }

    try {
      final AuthSession session = await _authRepository.login(
        LoginRequest(
          phoneNumber: credential.phoneNumber,
          password: credential.password,
        ),
      );

      final AuthSession resolvedSession = await _persistAuthenticatedSession(
        session: session,
        credential: credential,
        biometricUnlocked: true,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        session: resolvedSession,
        pendingVerification: null,
        isBusy: false,
      );

      return AuthOperationResult.success('Biometric login successful.');
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

    await _authSessionManager.clearSession();

    state = state.copyWith(
      status: AuthStatus.unauthenticated,
      session: null,
      pendingVerification: null,
      isBusy: false,
    );

    return AuthOperationResult.success('You have been logged out.');
  }

  Future<AuthOperationResult> register({
    required String fullName,
    required String phoneNumber,
    required String password,
  }) async {
    state = state.copyWith(isBusy: true);

    try {
      final PendingOtpVerification pendingVerification = await _authRepository
          .register(
            RegisterRequest(
              fullName: fullName,
              phoneNumber: phoneNumber,
              password: password,
            ),
          );

      state = state.copyWith(
        status: AuthStatus.awaitingOtp,
        pendingVerification: pendingVerification,
        isBusy: false,
      );

      return AuthOperationResult.success('OTP has been sent to $phoneNumber.');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false, status: AuthStatus.unauthenticated);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> requestPasswordReset({
    required String phoneNumber,
  }) async {
    state = state.copyWith(isBusy: true);

    await _authRepository.requestPasswordReset(phoneNumber);

    state = state.copyWith(isBusy: false);

    return AuthOperationResult.success(
      'If an account exists for $phoneNumber, reset instructions have been sent.',
    );
  }

  Future<AuthOperationResult> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final AuthSession? session = state.session;
    if (session == null) {
      return AuthOperationResult.failure(
        'You must be logged in to change your password.',
      );
    }

    state = state.copyWith(isBusy: true);

    try {
      await _authRepository.changePassword(
        userId: session.user.id,
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      await _authSessionManager.persistStoredCredential(
        StoredAuthCredential(
          phoneNumber: session.user.phoneNumber,
          password: newPassword,
        ),
      );

      state = state.copyWith(isBusy: false);
      return AuthOperationResult.success('Password changed successfully.');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> updateProfile({
    required String displayName,
    required String? emailAddress,
    required String? profileImageUri,
  }) async {
    final AuthSession? session = state.session;
    if (session == null) {
      return AuthOperationResult.failure(
        'You must be logged in to update your profile.',
      );
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
      return AuthOperationResult.success('Profile updated successfully.');
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(error.message);
    }
  }

  Future<AuthOperationResult> toggleBiometricLogin(bool enabled) async {
    if (state.session == null) {
      return AuthOperationResult.failure(
        'You must be logged in to update biometric settings.',
      );
    }

    if (enabled && !state.biometricCapability.canAuthenticate) {
      return AuthOperationResult.failure(
        'Biometric authentication is not available on this device.',
      );
    }

    if (enabled) {
      final bool confirmed = await _biometricAuthService.authenticate(
        reason: 'Confirm biometric login setup for Personal Wallet.',
      );

      if (!confirmed) {
        return AuthOperationResult.failure(
          'Biometric verification failed. Biometric login was not enabled.',
        );
      }
    }

    await _authSessionManager.setBiometricEnabled(enabled);

    final AuthSession updatedSession = state.session!.copyWith(
      user: state.session!.user.copyWith(biometricEnabled: enabled),
    );

    await _authSessionManager.persistSession(updatedSession);
    await _refreshBiometricState(session: updatedSession);

    return AuthOperationResult.success(
      enabled ? 'Biometric login is enabled.' : 'Biometric login is disabled.',
    );
  }

  Future<AuthOperationResult> verifyOtp({required String otpCode}) async {
    final PendingOtpVerification? pendingVerification =
        state.pendingVerification;

    if (pendingVerification == null) {
      return AuthOperationResult.failure(
        'OTP verification context was not found.',
      );
    }

    state = state.copyWith(isBusy: true);

    try {
      final AuthSession session = await _authRepository.verifyRegistrationOtp(
        pendingVerification: pendingVerification,
        otpCode: otpCode,
      );

      final AuthSession resolvedSession = await _persistAuthenticatedSession(
        session: session,
        credential: StoredAuthCredential(
          phoneNumber: pendingVerification.phoneNumber,
          password: pendingVerification.password,
        ),
        biometricUnlocked: false,
      );

      state = state.copyWith(
        status: AuthStatus.authenticated,
        session: resolvedSession,
        pendingVerification: null,
        isBusy: false,
      );

      return AuthOperationResult.success(
        'Registration completed successfully.',
      );
    } on AuthException catch (error) {
      state = state.copyWith(isBusy: false);
      return AuthOperationResult.failure(error.message);
    }
  }
}
