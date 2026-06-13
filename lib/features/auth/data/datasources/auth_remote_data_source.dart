import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';

abstract interface class AuthRemoteDataSource implements RemoteDataSource {
  Future<void> requestLoginOtp(LoginRequest request);
  Future<void> logout(String sessionId);
  Future<PendingOtpVerification> register(RegisterRequest request);
  Future<void> requestPinReset(String phoneNumber);
  Future<AuthSession> verifyLoginOtp({
    required String phoneNumber,
    required String otpCode,
  });
  Future<AuthSession> verifyPinResetOtp({
    required String phoneNumber,
    required String otpCode,
  });
  Future<AuthSession> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
}
