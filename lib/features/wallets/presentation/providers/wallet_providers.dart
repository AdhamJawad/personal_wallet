import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_wallet_repository.dart';
import '../../domain/repositories/wallet_repository.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../controllers/wallet_controller.dart';
import '../controllers/wallet_state.dart';

final walletRepositoryProvider = Provider<WalletRepository>((Ref ref) {
  return MockWalletRepository(ref.watch(localStoreProvider));
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
