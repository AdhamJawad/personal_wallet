import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../../core/sync/providers/sync_providers.dart';
import '../../data/repositories/mock_contact_repository.dart';
import '../../domain/repositories/contact_repository.dart';
import '../controllers/contact_controller.dart';
import '../controllers/contact_state.dart';

final contactRepositoryProvider = Provider<ContactRepository>((Ref ref) {
  return MockContactRepository(
    ref.watch(localStoreProvider),
    ref.watch(syncQueueRepositoryProvider),
    ref.watch(auditLoggerProvider),
  );
});

final contactControllerProvider =
    StateNotifierProvider<ContactController, ContactState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);

      return ContactController(
        contactRepository: ref.watch(contactRepositoryProvider),
        ownerUserId: authState.session?.user.id,
      );
    });
