import '../../domain/services/otp_service.dart';

class MockOtpService implements OtpService {
  const MockOtpService();

  static const String mockOtp = '123456';

  @override
  Future<void> sendOtp({required String phoneNumber}) async {}

  @override
  Future<bool> verify({required String code}) async => code == mockOtp;
}
