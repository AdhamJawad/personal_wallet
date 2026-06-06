import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/wallet_providers.dart';
import '../widgets/dashboard_section_header.dart';
import '../widgets/wallet_balance_panel.dart';

class WalletDetailsPage extends ConsumerStatefulWidget {
  const WalletDetailsPage({required this.walletId, super.key});

  final String walletId;

  @override
  ConsumerState<WalletDetailsPage> createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends ConsumerState<WalletDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(walletControllerProvider.notifier).loadWallet(widget.walletId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final walletOverview = walletState.selectedWallet;

    return PwScaffold(
      title: 'Wallet Details',
      body: walletState.isLoading && walletOverview == null
          ? const Center(child: CircularProgressIndicator())
          : walletOverview == null
          ? const Center(child: Text('Wallet not found.'))
          : ListView(
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Expanded(
                      child: DashboardSectionHeader(
                        title: walletOverview.wallet.name,
                        subtitle: walletOverview.wallet.isArchived
                            ? 'Archived wallet'
                            : 'Active wallet',
                      ),
                    ),
                    PwButton.secondary(
                      label: 'Edit wallet',
                      onPressed: () => context.push(
                        AppRoutes.walletEditLocation(walletOverview.wallet.id),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Balances', style: context.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        WalletBalancePanel(
                          usdAmount: walletOverview.balance.usdBalance.amount,
                          sypAmount: walletOverview.balance.sypBalance.amount,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        Text(
                          'Created ${DateFormatter.short(walletOverview.wallet.createdAt)}',
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        Text(
                          'Status: ${walletOverview.wallet.isArchived ? 'Archived' : 'Active'}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _PlaceholderSection(
                  title: 'Transactions',
                  description:
                      'This wallet now contributes to the immutable ledger. Open the transaction module to view and create entries.',
                  trailing: PwButton.secondary(
                    label: 'Open Ledger',
                    onPressed: () => context.go(AppRoutes.transactionsPath),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                const _PlaceholderSection(
                  title: 'Debt Activity',
                  description:
                      'Debt-related wallet context will appear here when the debt module is connected.',
                ),
              ],
            ),
    );
  }
}

class _PlaceholderSection extends StatelessWidget {
  const _PlaceholderSection({
    required this.title,
    required this.description,
    this.trailing,
  });

  final String title;
  final String description;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return PwSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(child: Text(title, style: context.titleMedium)),
                trailing ?? const SizedBox.shrink(),
              ],
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(description),
          ],
        ),
      ),
    );
  }
}
