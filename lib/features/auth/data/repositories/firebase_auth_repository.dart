import 'package:firebase_auth/firebase_auth.dart';

import '../../../../core/utils/id_generator.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/auth_exception.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';
import '../datasources/auth_remote_data_source.dart';
import '../models/verified_phone_auth_user.dart';
import 'remote_auth_repository.dart';

class FirebaseAuthRepository implements RemoteAuthRepository {
  FirebaseAuthRepository({required AuthRemoteDataSource remoteDataSource})
    : _remoteDataSource = remoteDataSource;

  final AuthRemoteDataSource _remoteDataSource;

  @override
  Future<void> logout(String sessionId) {
    return _remoteDataSource.logout(sessionId);
  }

  @override
  Future<PendingOtpVerification> register(RegisterRequest request) {
    return _remoteDataSource.register(request);
  }

  @override
  Future<PendingOtpVerification> requestLoginOtp(LoginRequest request) {
    return _remoteDataSource.requestLoginOtp(request);
  }

  @override
  Future<PendingOtpVerification> requestPinReset(String phoneNumber) {
    return _remoteDataSource.requestPinReset(phoneNumber);
  }

  @override
  Future<AuthSession?> restoreSession() async {
    final VerifiedPhoneAuthUser? verifiedUser = await _remoteDataSource
        .restoreSession();
    if (verifiedUser == null) {
      return null;
    }
    return _buildSession(verifiedUser);
  }

  @override
  Future<AppUser> updateProfile({
    required String userId,
    required String displayName,
    required String? emailAddress,
    required String? profileImageUri,
  }) async {
    final VerifiedPhoneAuthUser updatedUser = await _remoteDataSource
        .updateProfile(
          userId: userId,
          displayName: displayName,
          emailAddress: emailAddress,
          profileImageUri: profileImageUri,
        );
    return _buildAppUser(updatedUser);
  }

  @override
  Future<AuthSession> verifyLoginOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) async {
    final VerifiedPhoneAuthUser verifiedUser = await _remoteDataSource
        .verifyLoginOtp(
          pendingVerification: pendingVerification,
          otpCode: otpCode,
        );

    if (verifiedUser.isNewUser) {
      await _rollbackNewUser();
      throw const AuthException('phone_not_registered');
    }

    return _buildSession(verifiedUser);
  }

  @override
  Future<AuthSession> verifyPinResetOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) async {
    final VerifiedPhoneAuthUser verifiedUser = await _remoteDataSource
        .verifyPinResetOtp(
          pendingVerification: pendingVerification,
          otpCode: otpCode,
        );

    if (verifiedUser.isNewUser) {
      await _rollbackNewUser();
      throw const AuthException('phone_not_registered');
    }

    return _buildSession(verifiedUser);
  }

  @override
  Future<AuthSession> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) async {
    final VerifiedPhoneAuthUser verifiedUser = await _remoteDataSource
        .verifyRegistrationOtp(
          pendingVerification: pendingVerification,
          otpCode: otpCode,
        );

    if (!verifiedUser.isNewUser) {
      await _remoteDataSource.logout('');
      throw const AuthException('phone_already_registered');
    }

    return _buildSession(
      verifiedUser,
      pendingVerification: pendingVerification,
    );
  }

  AppUser _buildAppUser(
    VerifiedPhoneAuthUser verifiedUser, {
    PendingOtpVerification? pendingVerification,
  }) {
    final DateTime now = DateTime.now().toUtc();
    final String displayName =
        verifiedUser.displayName ??
        pendingVerification?.fullName?.trim() ??
        verifiedUser.phoneNumber;

    return AppUser(
      userId: verifiedUser.uid,
      phoneNumber: verifiedUser.phoneNumber,
      displayName: displayName,
      emailAddress:
          verifiedUser.emailAddress ??
          pendingVerification?.emailAddress?.trim(),
      profileImageUri: verifiedUser.profileImageUri,
      isVerified: true,
      personalQrToken: verifiedUser.uid,
      createdAt: now,
      updatedAt: now,
    );
  }

  AuthSession _buildSession(
    VerifiedPhoneAuthUser verifiedUser, {
    PendingOtpVerification? pendingVerification,
  }) {
    final DateTime now = DateTime.now().toUtc();

    return AuthSession(
      sessionId: IdGenerator.next(),
      user: _buildAppUser(
        verifiedUser,
        pendingVerification: pendingVerification,
      ),
      biometricUnlocked: false,
      issuedAt: now,
      expiresAt: now.add(const Duration(days: 7)),
    );
  }

  Future<void> _rollbackNewUser() async {
    try {
      final User? currentUser = FirebaseAuth.instance.currentUser;
      if (currentUser != null) {
        await currentUser.delete();
      }
    } catch (_) {}

    try {
      await _remoteDataSource.logout('');
    } catch (_) {}
  }
}
