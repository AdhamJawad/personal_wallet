import '../models/app_user.dart';
import '../models/auth_session.dart';
import '../models/login_request.dart';
import '../models/pending_otp_verification.dart';
import '../models/register_request.dart';

abstract interface class AuthRepository {
  Future<void> changePassword({
    required String userId,
    required String currentPassword,
    required String newPassword,
  });
  Future<AuthSession> login(LoginRequest request);
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
  Future<void> requestPasswordReset(String phoneNumber);
  Future<void> logout(String sessionId);
}
