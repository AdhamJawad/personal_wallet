import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/enums/wallet_sort_option.dart';
import '../../domain/models/wallet_dashboard_snapshot.dart';
import '../../domain/models/wallet_overview.dart';

part 'wallet_state.freezed.dart';

@freezed
abstract class WalletState with _$WalletState {
  const WalletState._();

  const factory WalletState({
    @Default(false) bool isLoading,
    @Default(<WalletOverview>[]) List<WalletOverview> wallets,
    WalletDashboardSnapshot? dashboardSnapshot,
    WalletOverview? selectedWallet,
    @Default('') String searchQuery,
    @Default(WalletSortOption.newest) WalletSortOption sortOption,
    String? errorMessage,
  }) = _WalletState;

  List<WalletOverview> get visibleWallets {
    final String normalizedQuery = searchQuery.trim().toLowerCase();
    final Iterable<WalletOverview> filteredWallets = normalizedQuery.isEmpty
        ? wallets
        : wallets.where(
            (WalletOverview item) =>
                item.wallet.name.toLowerCase().contains(normalizedQuery),
          );

    final List<WalletOverview> sortedWallets = filteredWallets.toList();

    sortedWallets.sort((WalletOverview left, WalletOverview right) {
      switch (sortOption) {
        case WalletSortOption.newest:
          return right.wallet.createdAt.compareTo(left.wallet.createdAt);
        case WalletSortOption.oldest:
          return left.wallet.createdAt.compareTo(right.wallet.createdAt);
        case WalletSortOption.nameAscending:
          return left.wallet.name.toLowerCase().compareTo(
            right.wallet.name.toLowerCase(),
          );
        case WalletSortOption.nameDescending:
          return right.wallet.name.toLowerCase().compareTo(
            left.wallet.name.toLowerCase(),
          );
        case WalletSortOption.highestUsd:
          return right.balance.usdBalance.amountMinor.compareTo(
            left.balance.usdBalance.amountMinor,
          );
        case WalletSortOption.highestSyp:
          return right.balance.sypBalance.amountMinor.compareTo(
            left.balance.sypBalance.amountMinor,
          );
      }
    });

    return sortedWallets;
  }
}
