import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';

import '../../domain/models/auth_exception.dart';
import '../../domain/models/login_request.dart';
import '../../domain/models/pending_otp_verification.dart';
import '../../domain/models/register_request.dart';
import '../models/verified_phone_auth_user.dart';
import 'auth_remote_data_source.dart';

class FirebasePhoneAuthRemoteDataSource implements AuthRemoteDataSource {
  FirebasePhoneAuthRemoteDataSource({FirebaseAuth? firebaseAuth})
    : _firebaseAuth = firebaseAuth ?? FirebaseAuth.instance;

  final FirebaseAuth _firebaseAuth;
  final Map<String, PhoneAuthCredential> _autoRetrievedCredentials =
      <String, PhoneAuthCredential>{};

  @override
  Future<void> logout(String sessionId) async {
    if (!_isFirebaseReady) {
      return;
    }
    await _firebaseAuth.signOut();
  }

  @override
  Future<PendingOtpVerification> register(RegisterRequest request) {
    return _requestOtp(
      phoneNumber: request.phoneNumber,
      fullName: request.fullName,
      emailAddress: request.emailAddress,
    );
  }

  @override
  Future<PendingOtpVerification> requestLoginOtp(LoginRequest request) {
    return _requestOtp(phoneNumber: request.phoneNumber);
  }

  @override
  Future<PendingOtpVerification> requestPinReset(String phoneNumber) {
    return _requestOtp(phoneNumber: phoneNumber);
  }

  @override
  Future<VerifiedPhoneAuthUser?> restoreSession() async {
    if (!_isFirebaseReady) {
      return null;
    }

    final User? currentUser = _firebaseAuth.currentUser;
    if (currentUser == null) {
      return null;
    }

    await currentUser.reload();
    final User? reloadedUser = _firebaseAuth.currentUser;
    if (reloadedUser == null) {
      return null;
    }

    return _mapUser(reloadedUser, isNewUser: false);
  }

  @override
  Future<VerifiedPhoneAuthUser> updateProfile({
    required String userId,
    required String displayName,
    required String? emailAddress,
    required String? profileImageUri,
  }) async {
    final User? currentUser = _firebaseAuth.currentUser;
    if (!_isFirebaseReady || currentUser == null || currentUser.uid != userId) {
      throw const AuthException('session_required');
    }

    await currentUser.updateDisplayName(displayName.trim());
    await currentUser.reload();

    final User? reloadedUser = _firebaseAuth.currentUser;
    if (reloadedUser == null) {
      throw const AuthException('profile_update_failed');
    }

    return VerifiedPhoneAuthUser(
      uid: reloadedUser.uid,
      phoneNumber: reloadedUser.phoneNumber ?? currentUser.phoneNumber ?? '',
      displayName: displayName.trim(),
      emailAddress: _normalizeOptionalValue(emailAddress),
      profileImageUri: _normalizeOptionalValue(profileImageUri),
      isNewUser: false,
    );
  }

  @override
  Future<VerifiedPhoneAuthUser> verifyLoginOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) {
    return _verifyOtp(
      pendingVerification: pendingVerification,
      otpCode: otpCode,
    );
  }

  @override
  Future<VerifiedPhoneAuthUser> verifyPinResetOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) {
    return _verifyOtp(
      pendingVerification: pendingVerification,
      otpCode: otpCode,
    );
  }

  @override
  Future<VerifiedPhoneAuthUser> verifyRegistrationOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) async {
    final VerifiedPhoneAuthUser verifiedUser = await _verifyOtp(
      pendingVerification: pendingVerification,
      otpCode: otpCode,
    );

    final String? displayName = pendingVerification.fullName?.trim();
    if (displayName != null && displayName.isNotEmpty) {
      await _firebaseAuth.currentUser?.updateDisplayName(displayName);
      await _firebaseAuth.currentUser?.reload();
    }

    final User? reloadedUser = _firebaseAuth.currentUser;
    if (reloadedUser == null) {
      return verifiedUser;
    }

    return VerifiedPhoneAuthUser(
      uid: reloadedUser.uid,
      phoneNumber: reloadedUser.phoneNumber ?? pendingVerification.phoneNumber,
      displayName: displayName ?? verifiedUser.displayName,
      emailAddress: _normalizeOptionalValue(pendingVerification.emailAddress),
      profileImageUri: verifiedUser.profileImageUri,
      isNewUser: verifiedUser.isNewUser,
    );
  }

  bool get _isFirebaseReady => Firebase.apps.isNotEmpty;

  VerifiedPhoneAuthUser _mapUser(User user, {required bool isNewUser}) {
    return VerifiedPhoneAuthUser(
      uid: user.uid,
      phoneNumber: user.phoneNumber ?? '',
      displayName: _normalizeOptionalValue(user.displayName),
      emailAddress: _normalizeOptionalValue(user.email),
      profileImageUri: _normalizeOptionalValue(user.photoURL),
      isNewUser: isNewUser,
    );
  }

  Future<PendingOtpVerification> _requestOtp({
    required String phoneNumber,
    String? fullName,
    String? emailAddress,
  }) async {
    if (!_isFirebaseReady) {
      throw const AuthException('firebase_not_initialized');
    }

    final Completer<PendingOtpVerification> completer =
        Completer<PendingOtpVerification>();
    bool didEmitChallenge = false;

    Future<void> emitChallenge({
      required String verificationId,
      int? resendToken,
    }) async {
      if (didEmitChallenge || completer.isCompleted) {
        return;
      }
      didEmitChallenge = true;
      completer.complete(
        PendingOtpVerification(
          verificationId: verificationId,
          phoneNumber: phoneNumber,
          fullName: _normalizeOptionalValue(fullName),
          emailAddress: _normalizeOptionalValue(emailAddress),
          resendToken: resendToken,
          createdAt: DateTime.now().toUtc(),
        ),
      );
    }

    try {
      await _firebaseAuth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) {
          final String? verificationId = credential.verificationId;
          if (verificationId != null && verificationId.isNotEmpty) {
            _autoRetrievedCredentials[verificationId] = credential;
            unawaited(emitChallenge(verificationId: verificationId));
          }
        },
        verificationFailed: (FirebaseAuthException error) {
          if (!completer.isCompleted) {
            completer.completeError(AuthException(_mapFirebaseError(error)));
          }
        },
        codeSent: (String verificationId, int? resendToken) {
          unawaited(
            emitChallenge(
              verificationId: verificationId,
              resendToken: resendToken,
            ),
          );
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          unawaited(emitChallenge(verificationId: verificationId));
        },
      );
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseError(error));
    }

    return completer.future.timeout(
      const Duration(seconds: 60),
      onTimeout: () => throw const AuthException('otp_send_failed'),
    );
  }

  Future<VerifiedPhoneAuthUser> _verifyOtp({
    required PendingOtpVerification pendingVerification,
    required String otpCode,
  }) async {
    if (!_isFirebaseReady) {
      throw const AuthException('firebase_not_initialized');
    }

    try {
      final PhoneAuthCredential credential =
          _autoRetrievedCredentials.remove(
            pendingVerification.verificationId,
          ) ??
          PhoneAuthProvider.credential(
            verificationId: pendingVerification.verificationId,
            smsCode: otpCode.trim(),
          );

      final UserCredential userCredential = await _firebaseAuth
          .signInWithCredential(credential);
      final User? user = userCredential.user;

      if (user == null) {
        throw const AuthException('auth_user_missing');
      }

      return _mapUser(
        user,
        isNewUser: userCredential.additionalUserInfo?.isNewUser ?? false,
      );
    } on FirebaseAuthException catch (error) {
      throw AuthException(_mapFirebaseError(error));
    }
  }

  String _mapFirebaseError(FirebaseAuthException error) {
    return switch (error.code) {
      'invalid-phone-number' => 'phone_number_invalid',
      'invalid-verification-code' => 'otp_invalid',
      'session-expired' => 'otp_expired',
      'too-many-requests' => 'too_many_requests',
      'quota-exceeded' => 'too_many_requests',
      'network-request-failed' => 'network_error',
      'captcha-check-failed' => 'otp_send_failed',
      'app-not-authorized' => 'app_not_authorized',
      _ => 'something_went_wrong',
    };
  }
}

String? _normalizeOptionalValue(String? value) {
  final String? trimmed = value?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}
