import '../models/biometric_capability.dart';

abstract interface class BiometricAuthService {
  Future<BiometricCapability> getCapability();
  Future<bool> authenticate({required String reason});
}
