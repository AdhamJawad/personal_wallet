import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../../core/sync/providers/sync_providers.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../data/repositories/mock_debt_repository.dart';
import '../../domain/repositories/debt_repository.dart';
import '../controllers/debt_controller.dart';
import '../controllers/debt_state.dart';

final debtRepositoryProvider = Provider<DebtRepository>((Ref ref) {
  return MockDebtRepository(
    localStore: ref.watch(localStoreProvider),
    contactRepository: ref.watch(contactRepositoryProvider),
    syncQueueRepository: ref.watch(syncQueueRepositoryProvider),
    notificationPublisher: ref.watch(notificationPublisherProvider),
    auditLogger: ref.watch(auditLoggerProvider),
  );
});

final debtControllerProvider = StateNotifierProvider<DebtController, DebtState>(
  (Ref ref) {
    final authState = ref.watch(authControllerProvider);

    return DebtController(
      debtRepository: ref.watch(debtRepositoryProvider),
      ownerUserId: authState.session?.user.id,
    );
  },
);
