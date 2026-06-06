import 'dart:convert';

import '../../../../core/constants/app_constants.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/utils/id_generator.dart';
import '../../domain/models/auth_session.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';
import '../../domain/services/otp_service.dart';
import '../models/mock_auth_account.dart';
import '../../domain/models/app_user.dart';
import 'local_auth_repository.dart';

class MockAuthRepository implements LocalAuthRepository {
  MockAuthRepository({
    required LocalStore localStore,
    required OtpService otpService,
  }) : _localStore = localStore,
       _otpService = otpService;

  static const String _demoPhoneNumber = '+963999999999';
  static const String _demoPassword = '123456';
  static const String _demoDisplayName = 'Demo User';

  final LocalStore _localStore;
  final OtpService _otpService;

  Future<void> _ensureSeeded() async {
    final String? existingValue = await _localStore.read(
      boxName: AppConstants.usersBox,
      key: _demoPhoneNumber,
    );

    if (existingValue != null) {
      return;
    }

    final DateTime now = DateTime.now().toUtc();
    final List<MockAuthAccount> accounts = <MockAuthAccount>[
      MockAuthAccount(
        user: AppUser(
          id: 'user_demo_1',
          phoneNumber: _demoPhoneNumber,
          displayName: _demoDisplayName,
          isVerified: true,
          biometricEnabled: false,
          personalQrToken: 'PW-DEMO-001',
          createdAt: now,
          updatedAt: now,
        ),
        password: _demoPassword,
      ),
      MockAuthAccount(
        user: AppUser(
          id: 'user_demo_2',
          phoneNumber: '+963900000002',
          displayName: 'Ahmad Kareem',
          isVerified: true,
          biometricEnabled: false,
          personalQrToken: 'PW-AHMAD-002',
          createdAt: now,
          updatedAt: now,
        ),
        password: _demoPassword,
      ),
      MockAuthAccount(
        user: AppUser(
          id: 'user_demo_3',
          phoneNumber: '+963900000003',
          displayName: 'Sara Nasser',
          isVerified: true,
          biometricEnabled: false,
          personalQrToken: 'PW-SARA-003',
          createdAt: now,
          updatedAt: now,
        ),
        password: _demoPassword,
      ),
    ];

    for (final MockAuthAccount account in accounts) {
      await _localStore.write(
        boxName: AppConstants.usersBox,
        key: account.user.phoneNumber,
        value: jsonEncode(account.toJson()),
      );
    }
  }

  Future<MockAuthAccount?> _findAccount(String phoneNumber) async {
    await _ensureSeeded();

    final String? rawValue = await _localStore.read(
      boxName: AppConstants.usersBox,
      key: phoneNumber,
    );

    if (rawValue == null || rawValue.isEmpty) {
      return null;
    }

    return MockAuthAccount.fromJson(
      jsonDecode(rawValue) as Map<String, dynamic>,
    );
  }

  Future<void> _saveAccount(MockAuthAccount account) async {
    await _localStore.write(
      boxName: AppConstants.usersBox,
      key: account.user.phoneNumber,
      value: jsonEncode(account.toJson()),
    );
  }

  AuthSession _buildSession({
    required AppUser user,
    required bool biometricUnlocked,
  }) {
    final DateTime now = DateTime.now().toUtc();

    return AuthSession(
      id: IdGenerator.next(),
      user: user.copyWith(updatedAt: now),
      biometricUnlocked: biometricUnlocked,
      issuedAt: now,
      expiresAt: now.add(const Duration(days: 7)),
    );
  }

  @override
  Future<AuthSession> login(LoginRequest request) async {
    final MockAuthAccount? account = await _findAccount(request.phoneNumber);

    if (account == null || account.password != request.password) {
      throw const AuthException('Invalid phone number or password.');
    }

    return _buildSession(user: account.user, biometricUnlocked: false);
  }

  @override
  Future<void> logout(String sessionId) async {}

  @override
  Future<PendingOtpVerification> register(RegisterRequest request) async {
    final MockAuthAccount? existingAccount = await _findAccount(
      request.phoneNumber,
    );

    if (existingAccount != null) {
      throw const AuthException('Phone number is already registered.');
    }

    await _otpService.sendOtp(phoneNumber: request.phoneNumber);

    return PendingOtpVerification(
      verificationId: IdGenerator.next(),
      fullName: request.fullName,
      phoneNumber: request.phoneNumber,
      password: request.password,
      createdAt: DateTime.now().toUtc(),
    );
  }

  @override
  Future<void> requestPasswordReset(String phoneNumber) async {
    await _ensureSeeded();
    await _otpService.sendOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<AuthSession> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) async {
    final bool isValidOtp = await _otpService.verify(code: otpCode);

    if (!isValidOtp) {
      throw const AuthException('The OTP code is invalid.');
    }

    final DateTime now = DateTime.now().toUtc();
    final AppUser user = AppUser(
      id: IdGenerator.next(),
      phoneNumber: pendingVerification.phoneNumber,
      displayName: pendingVerification.fullName,
      isVerified: true,
      biometricEnabled: false,
      personalQrToken: IdGenerator.next(),
      createdAt: now,
      updatedAt: now,
    );

    await _saveAccount(
      MockAuthAccount(user: user, password: pendingVerification.password),
    );

    return _buildSession(user: user, biometricUnlocked: false);
  }
}

class AuthException implements Exception {
  const AuthException(this.message);

  final String message;

  @override
  String toString() => message;
}
