import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../audit/presentation/providers/audit_providers.dart';
import '../../../notifications/presentation/providers/notification_providers.dart';
import '../../../../core/sync/providers/sync_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../data/repositories/mock_wallet_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../controllers/wallet_controller.dart';
import '../controllers/wallet_state.dart';

final walletRepositoryProvider = Provider<WalletRepository>((Ref ref) {
  return MockWalletRepository(
    localStore: ref.watch(localStoreProvider),
    ledgerStore: ref.watch(mockLedgerStoreProvider),
    balanceCalculatorService: ref.watch(balanceCalculatorServiceProvider),
    syncQueueRepository: ref.watch(syncQueueRepositoryProvider),
    notificationPublisher: ref.watch(notificationPublisherProvider),
    auditLogger: ref.watch(auditLoggerProvider),
  );
});

final walletControllerProvider =
    StateNotifierProvider<WalletController, WalletState>((Ref ref) {
      final authState = ref.watch(authControllerProvider);

      return WalletController(
        walletRepository: ref.watch(walletRepositoryProvider),
        ownerUserId: authState.session?.user.id,
      );
    });

final selectedWalletProvider = Provider((Ref ref) {
  return ref.watch(walletControllerProvider).selectedWallet;
});
