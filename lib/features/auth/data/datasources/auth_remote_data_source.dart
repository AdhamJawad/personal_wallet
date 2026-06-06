import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';

abstract interface class AuthRemoteDataSource implements RemoteDataSource {
  Future<AuthSession> login(LoginRequest request);
  Future<void> logout(String sessionId);
  Future<PendingOtpVerification> register(RegisterRequest request);
  Future<void> requestPasswordReset(String phoneNumber);
  Future<AuthSession> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  });
}
