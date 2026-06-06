import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../../../transfers/presentation/providers/transfer_providers.dart';
import '../../data/repositories/mock_qr_repository.dart';
import '../../domain/repositories/qr_repository.dart';
import '../controllers/qr_controller.dart';
import '../controllers/qr_state.dart';

final qrRepositoryProvider = Provider<QrRepository>((Ref ref) {
  return MockQrRepository(
    localStore: ref.watch(localStoreProvider),
    contactRepository: ref.watch(contactRepositoryProvider),
    registeredUserDirectory: ref.watch(registeredUserDirectoryProvider),
  );
});

final qrControllerProvider = StateNotifierProvider<QrController, QrState>((
  Ref ref,
) {
  final authState = ref.watch(authControllerProvider);

  return QrController(
    qrRepository: ref.watch(qrRepositoryProvider),
    session: authState.session,
  );
});
