import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/mock_wallet_repository.dart';
import '../../domain/enums/wallet_sort_option.dart';
import '../../domain/models/wallet_dashboard_snapshot.dart';
import '../../domain/models/wallet_overview.dart';
import '../../domain/repositories/wallet_repository.dart';
import 'wallet_state.dart';

class WalletController extends StateNotifier<WalletState> {
  WalletController({
    required WalletRepository walletRepository,
    required String? ownerUserId,
  }) : _walletRepository = walletRepository,
       _ownerUserId = ownerUserId,
       super(const WalletState()) {
    if (ownerUserId != null) {
      initialize();
    }
  }

  final WalletRepository _walletRepository;
  final String? _ownerUserId;

  String get _resolvedOwnerUserId {
    final String? ownerUserId = _ownerUserId;

    if (ownerUserId == null) {
      throw const WalletControllerException('No authenticated user found.');
    }

    return ownerUserId;
  }

  Future<void> _reload({
    String? selectedWalletId,
    bool preserveSelection = false,
  }) async {
    final String ownerUserId = _resolvedOwnerUserId;
    final List<WalletOverview> wallets = await _walletRepository.fetchWallets(
      ownerUserId,
    );
    final WalletDashboardSnapshot dashboardSnapshot = await _walletRepository
        .fetchDashboardSnapshot(ownerUserId);

    String? activeSelectionId = selectedWalletId;

    if (preserveSelection && activeSelectionId == null) {
      activeSelectionId = state.selectedWallet?.wallet.id;
    }

    final WalletOverview? selectedWallet = activeSelectionId == null
        ? null
        : wallets.cast<WalletOverview?>().firstWhere(
            (WalletOverview? item) => item?.wallet.id == activeSelectionId,
            orElse: () => null,
          );

    state = state.copyWith(
      wallets: wallets,
      dashboardSnapshot: dashboardSnapshot,
      selectedWallet: selectedWallet,
      errorMessage: null,
      isLoading: false,
    );
  }

  Future<bool> archiveSelectedWallet() async {
    final WalletOverview? selectedWallet = state.selectedWallet;

    if (selectedWallet == null) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      await _walletRepository.archiveWallet(
        ownerUserId: _resolvedOwnerUserId,
        walletId: selectedWallet.wallet.id,
      );
      await _reload(selectedWalletId: selectedWallet.wallet.id);
      return true;
    } on WalletRepositoryException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
      return false;
    }
  }

  Future<bool> createWallet(String name) async {
    state = state.copyWith(isLoading: true);

    try {
      final WalletOverview createdWallet = await _walletRepository.createWallet(
        ownerUserId: _resolvedOwnerUserId,
        name: name.trim(),
      );
      await _reload(selectedWalletId: createdWallet.wallet.id);
      return true;
    } on WalletRepositoryException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
      return false;
    }
  }

  Future<void> initialize() async {
    state = state.copyWith(isLoading: true);

    try {
      await _reload();
    } on WalletRepositoryException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    }
  }

  Future<void> loadWallet(String walletId) async {
    state = state.copyWith(isLoading: true);

    try {
      final WalletOverview? wallet = await _walletRepository.getWalletById(
        ownerUserId: _resolvedOwnerUserId,
        walletId: walletId,
      );
      await _reload(selectedWalletId: wallet?.wallet.id);
    } on WalletRepositoryException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
    }
  }

  Future<bool> renameSelectedWallet(String name) async {
    final WalletOverview? selectedWallet = state.selectedWallet;

    if (selectedWallet == null) {
      return false;
    }

    state = state.copyWith(isLoading: true);

    try {
      await _walletRepository.renameWallet(
        ownerUserId: _resolvedOwnerUserId,
        walletId: selectedWallet.wallet.id,
        name: name.trim(),
      );
      await _reload(selectedWalletId: selectedWallet.wallet.id);
      return true;
    } on WalletRepositoryException catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.message);
      return false;
    }
  }

  void setSearchQuery(String value) {
    state = state.copyWith(searchQuery: value);
  }

  void setSortOption(WalletSortOption value) {
    state = state.copyWith(sortOption: value);
  }
}

class WalletControllerException implements Exception {
  const WalletControllerException(this.message);

  final String message;

  @override
  String toString() => message;
}
