import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/flutter_secure_storage_service.dart';
import '../../../../core/storage/hive/hive_local_store.dart';
import '../../../../core/storage/local_store.dart';
import '../../../../core/storage/secure_storage_service.dart';
import '../../data/datasources/auth_remote_data_source.dart';
import '../../data/datasources/firebase_phone_auth_remote_data_source.dart';
import '../../data/repositories/firebase_auth_repository.dart';
import '../../data/services/local_biometric_auth_service.dart';
import '../../domain/services/auth_session_manager.dart';
import '../../domain/services/biometric_auth_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../controllers/auth_controller.dart';
import '../controllers/auth_state.dart';

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((Ref ref) {
  return FirebasePhoneAuthRemoteDataSource();
});

final authRepositoryProvider = Provider<AuthRepository>((Ref ref) {
  return FirebaseAuthRepository(
    remoteDataSource: ref.watch(authRemoteDataSourceProvider),
  );
});

final localStoreProvider = Provider<LocalStore>((Ref ref) {
  return const HiveLocalStore();
});

final secureStorageProvider = Provider<SecureStorageService>((Ref ref) {
  return FlutterSecureStorageService();
});

final biometricAuthServiceProvider = Provider<BiometricAuthService>((Ref ref) {
  return LocalBiometricAuthService();
});

final authSessionManagerProvider = Provider<AuthSessionManager>((Ref ref) {
  return AuthSessionManager(ref.watch(secureStorageProvider));
});

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>(
  (Ref ref) {
    return AuthController(
      authRepository: ref.watch(authRepositoryProvider),
      authSessionManager: ref.watch(authSessionManagerProvider),
      biometricAuthService: ref.watch(biometricAuthServiceProvider),
    );
  },
);
