import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:personal_wallet/app/app.dart';
import 'package:personal_wallet/core/storage/secure_storage_service.dart';
import 'package:personal_wallet/features/auth/domain/models/biometric_capability.dart';
import 'package:personal_wallet/features/auth/domain/services/biometric_auth_service.dart';
import 'package:personal_wallet/features/auth/presentation/providers/auth_providers.dart';

class _InMemorySecureStorageService implements SecureStorageService {
  final Map<String, String> _values = <String, String>{};

  @override
  Future<void> delete({required String key}) async {
    _values.remove(key);
  }

  @override
  Future<void> deleteAll() async {
    _values.clear();
  }

  @override
  Future<String?> read({required String key}) async {
    return _values[key];
  }

  @override
  Future<void> write({required String key, required String value}) async {
    _values[key] = value;
  }
}

class _FakeBiometricAuthService implements BiometricAuthService {
  @override
  Future<bool> authenticate({required String reason}) async => false;

  @override
  Future<BiometricCapability> getCapability() async {
    return const BiometricCapability();
  }
}

void main() {
  testWidgets('app shell renders', (WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          secureStorageProvider.overrideWithValue(
            _InMemorySecureStorageService(),
          ),
          biometricAuthServiceProvider.overrideWithValue(
            _FakeBiometricAuthService(),
          ),
        ],
        child: const PersonalWalletApp(),
      ),
    );
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 100));

    expect(find.text('مرحبًا بعودتك'), findsOneWidget);
    expect(
      find.text('بيانات دخول تجريبية: +963999999999 / 123456'),
      findsOneWidget,
    );
  });
}
