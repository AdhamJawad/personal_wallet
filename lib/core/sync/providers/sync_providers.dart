import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../features/auth/presentation/providers/auth_providers.dart';
import '../../../features/notifications/presentation/providers/notification_providers.dart';
import '../controllers/sync_controller.dart';
import '../controllers/sync_state.dart';
import '../data/repositories/mock_sync_queue_repository.dart';
import '../repositories/sync_queue_repository.dart';

final syncQueueRepositoryProvider = Provider<SyncQueueRepository>((Ref ref) {
  return MockSyncQueueRepository(ref.watch(localStoreProvider));
});

final syncControllerProvider = StateNotifierProvider<SyncController, SyncState>(
  (Ref ref) {
    final authState = ref.watch(authControllerProvider);

    return SyncController(
      syncQueueRepository: ref.watch(syncQueueRepositoryProvider),
      notificationPublisher: ref.watch(notificationPublisherProvider),
      ownerUserId: authState.session?.user.id,
    );
  },
);
