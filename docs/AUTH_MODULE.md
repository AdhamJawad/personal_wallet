# Authentication Module

## Screen Flow

```text
Splash
  -> restore secure session
  -> authenticated: Dashboard
  -> unauthenticated: Login

Login
  -> password success: Dashboard
  -> biometric success: Dashboard
  -> register: Register
  -> forgot password: Forgot Password

Register
  -> submit details: OTP Verification

OTP Verification
  -> valid OTP: Dashboard

Forgot Password
  -> submit phone number: success message -> Login
```

## Repository Structure

```text
features/auth/
  data/
    models/mock_auth_account.dart
    repositories/mock_auth_repository.dart
    services/local_biometric_auth_service.dart
    services/mock_otp_service.dart
  domain/
    models/
    repositories/auth_repository.dart
    services/
      auth_session_manager.dart
      biometric_auth_service.dart
      otp_service.dart
  presentation/
    controllers/
    pages/
    providers/
    widgets/
```

## Authentication Flow

1. `SplashPage` loads first.
2. `AuthController` initializes through Riverpod.
3. `AuthSessionManager` attempts to restore a secure local session.
4. Router redirects to `Dashboard` or `Login` based on `AuthState.status`.
5. Password login calls `AuthRepository.login`.
6. Register calls `AuthRepository.register`, creates pending OTP state, and redirects to OTP.
7. OTP verification calls `AuthRepository.verifyRegistrationOtp` and creates a live session.

## Session Management Flow

1. Successful password login or OTP verification creates an `AuthSession`.
2. `AuthSessionManager` stores the serialized session in secure storage.
3. The last successful credentials are also stored securely for future biometric login in this mock phase.
4. On restart, `AuthSessionManager.restoreSession()` rebuilds the session from secure storage.
5. Logout clears only the active session so biometric login can still be used later if the user enabled it.

## Biometric Flow

1. Device capability is discovered through `BiometricAuthService`.
2. After the first successful password-based login, secure credentials are available locally.
3. The user enables biometric login from the temporary dashboard.
4. Enabling biometrics requires one biometric confirmation.
5. On the login screen, biometric login appears only when:
   - device authentication is supported
   - biometrics are enrolled
   - biometric login is enabled
   - a stored credential exists
6. Successful biometric authentication unlocks the stored credential and replays a repository login.
7. If biometric authentication fails, the user remains on the login screen and can fall back to password login.

## Future Backend Integration Points

- Replace `MockAuthRepository` with a remote-backed repository while keeping the same interface.
- Replace stored password credentials with refresh tokens or signed device-bound credentials.
- Replace `MockOtpService` with backend OTP delivery and verification endpoints.
- Add secure token rotation and remote session invalidation to `AuthSessionManager`.
- Add server-driven biometric enrollment policy and device binding.

## Notes

- Demo login: `+963999999999 / 123456`
- Demo OTP: `123456`
- `local_auth` is used for biometric support.
- `flutter_secure_storage` is used behind `SecureStorageService`.

