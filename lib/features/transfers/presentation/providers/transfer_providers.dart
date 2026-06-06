import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../../core/sync/providers/sync_providers.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../data/repositories/mock_transfer_repository.dart';
import '../../data/services/mock_registered_user_directory.dart';
import '../../domain/repositories/transfer_repository.dart';
import '../controllers/transfer_controller.dart';
import '../controllers/transfer_state.dart';

final registeredUserDirectoryProvider = Provider<MockRegisteredUserDirectory>((
  Ref ref,
) {
  return MockRegisteredUserDirectory(ref.watch(localStoreProvider));
});

final transferRepositoryProvider = Provider<TransferRepository>((Ref ref) {
  return MockTransferRepository(
    localStore: ref.watch(localStoreProvider),
    ledgerStore: ref.watch(mockLedgerStoreProvider),
    debtRepository: ref.watch(debtRepositoryProvider),
    syncQueueRepository: ref.watch(syncQueueRepositoryProvider),
    notificationPublisher: ref.watch(notificationPublisherProvider),
    auditLogger: ref.watch(auditLoggerProvider),
  );
});

final transferControllerProvider =
    StateNotifierProvider<TransferController, TransferState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);

      return TransferController(
        transferRepository: ref.watch(transferRepositoryProvider),
        session: authState.session,
      );
    });
