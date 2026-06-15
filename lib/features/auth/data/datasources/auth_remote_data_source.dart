import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';
import '../models/verified_phone_auth_user.dart';

abstract interface class AuthRemoteDataSource implements RemoteDataSource {
  Future<PendingOtpVerification> requestLoginOtp(LoginRequest request);
  Future<VerifiedPhoneAuthUser?> restoreSession();
  Future<void> logout(String sessionId);
  Future<PendingOtpVerification> register(RegisterRequest request);
  Future<VerifiedPhoneAuthUser> updateProfile({
    required String userId,
    required String displayName,
    required String? emailAddress,
    required String? profileImageUri,
  });
  Future<PendingOtpVerification> requestPinReset(String phoneNumber);
  Future<VerifiedPhoneAuthUser> verifyLoginOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
  Future<VerifiedPhoneAuthUser> verifyPinResetOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
  Future<VerifiedPhoneAuthUser> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
}
