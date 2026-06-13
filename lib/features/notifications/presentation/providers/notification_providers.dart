import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../data/repositories/mock_notification_repository.dart';
import '../../domain/repositories/notification_repository.dart';
import '../../domain/services/notification_publisher.dart';
import '../controllers/notification_controller.dart';
import '../controllers/notification_state.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((
  Ref ref,
) {
  return MockNotificationRepository(ref.watch(localStoreProvider));
});

final notificationPublisherProvider = Provider<NotificationPublisher>((
  Ref ref,
) {
  return NotificationPublisher(ref.watch(notificationRepositoryProvider));
});

final notificationControllerProvider =
    StateNotifierProvider<NotificationController, NotificationState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);
      return NotificationController(
        notificationRepository: ref.watch(notificationRepositoryProvider),
        ownerUserId: authState.session?.user.id,
      );
    });
