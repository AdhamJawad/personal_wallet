import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/wallet_sort_option.dart';
import '../providers/wallet_providers.dart';
import '../widgets/wallet_overview_card.dart';

class WalletsPage extends ConsumerStatefulWidget {
  const WalletsPage({super.key});

  @override
  ConsumerState<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends ConsumerState<WalletsPage> {
  late final TextEditingController _searchController;
  late final VoidCallback _searchListener;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchListener = () {
      ref
          .read(walletControllerProvider.notifier)
          .setSearchQuery(_searchController.text);
    };
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final wallets = walletState.visibleWallets;

    return PwScaffold(
      title: 'Wallets',
      body: ListView(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: PwTextField(
                  controller: _searchController,
                  label: 'Search wallets',
                  hint: 'Main Wallet',
                  onFieldSubmitted: (_) {},
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: DropdownButtonFormField<WalletSortOption>(
                  initialValue: walletState.sortOption,
                  decoration: const InputDecoration(labelText: 'Sort'),
                  items: WalletSortOption.values
                      .map(
                        (WalletSortOption option) => DropdownMenuItem(
                          value: option,
                          child: Text(_sortLabel(option)),
                        ),
                      )
                      .toList(growable: false),
                  onChanged: (WalletSortOption? value) {
                    if (value == null) {
                      return;
                    }
                    ref
                        .read(walletControllerProvider.notifier)
                        .setSortOption(value);
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Align(
            alignment: Alignment.centerRight,
            child: PwButton.primary(
              label: 'Create wallet',
              onPressed: () => context.push(AppRoutes.walletCreatePath),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          if (walletState.isLoading)
            const Center(child: CircularProgressIndicator())
          else if (wallets.isEmpty)
            const Padding(
              padding: EdgeInsets.all(AppSpacing.xl),
              child: Text('No wallets matched your search.'),
            )
          else
            ...wallets.map(
              (walletOverview) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.md),
                child: WalletOverviewCard(
                  walletOverview: walletOverview,
                  onTap: () => context.push(
                    AppRoutes.walletDetailsLocation(walletOverview.wallet.id),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

String _sortLabel(WalletSortOption option) {
  switch (option) {
    case WalletSortOption.newest:
      return 'Newest';
    case WalletSortOption.oldest:
      return 'Oldest';
    case WalletSortOption.nameAscending:
      return 'Name A-Z';
    case WalletSortOption.nameDescending:
      return 'Name Z-A';
    case WalletSortOption.highestUsd:
      return 'Highest USD';
    case WalletSortOption.highestSyp:
      return 'Highest SYP';
  }
}
