import '../models/app_user.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';
import '../models/pending_otp_verification.dart';
import '../models/register_request.dart';

abstract interface class AuthRepository {
  Future<PendingOtpVerification> requestLoginOtp(LoginRequest request);
  Future<AuthSession?> restoreSession();
  Future<AuthSession> verifyLoginOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
  Future<PendingOtpVerification> register(RegisterRequest request);
  Future<AppUser> updateProfile({
    required String userId,
    required String displayName,
    required String? emailAddress,
    required String? profileImageUri,
  });
  Future<AuthSession> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
  Future<PendingOtpVerification> requestPinReset(String phoneNumber);
  Future<AuthSession> verifyPinResetOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
  Future<void> logout(String sessionId);
}
