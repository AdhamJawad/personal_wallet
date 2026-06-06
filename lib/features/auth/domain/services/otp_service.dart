abstract interface class OtpService {
  Future<void> sendOtp({required String phoneNumber});
  Future<bool> verify({required String code});
}
