import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../../wallets/presentation/widgets/dashboard_metric_card.dart';
import '../../../wallets/presentation/widgets/dashboard_section_header.dart';
import '../../../wallets/presentation/widgets/disabled_quick_action_card.dart';
import '../../../wallets/presentation/widgets/wallet_overview_card.dart';

class DashboardPlaceholderPage extends ConsumerWidget {
  const DashboardPlaceholderPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final session = authState.session;
    final dashboardSnapshot = walletState.dashboardSnapshot;
    final recentWallets =
        dashboardSnapshot?.walletSummaries.take(3).toList(growable: false) ??
        const [];

    return PwScaffold(
      title: 'Dashboard',
      body: walletState.isLoading && dashboardSnapshot == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: <Color>[AppColors.brand, AppColors.brandDark],
                    ),
                    borderRadius: BorderRadius.circular(28),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Welcome back, ${session?.user.displayName ?? 'User'}',
                        style: context.titleLarge.copyWith(color: Colors.white),
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      Text(
                        'Here is your current wallet overview.',
                        style: context.bodyLarge.copyWith(
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      LayoutBuilder(
                        builder:
                            (BuildContext context, BoxConstraints constraints) {
                              final bool singleColumn =
                                  constraints.maxWidth < 620;

                              return Flex(
                                direction: singleColumn
                                    ? Axis.vertical
                                    : Axis.horizontal,
                                children: <Widget>[
                                  Expanded(
                                    child: DashboardMetricCard(
                                      label: 'Total USD',
                                      value: AmountFormatter.format(
                                        dashboardSnapshot?.totalUsd ?? '0',
                                      ),
                                      caption: 'Across all wallets',
                                      icon: Icons.attach_money_rounded,
                                    ),
                                  ),
                                  SizedBox(
                                    width: singleColumn ? 0 : AppSpacing.md,
                                    height: singleColumn ? AppSpacing.md : 0,
                                  ),
                                  Expanded(
                                    child: DashboardMetricCard(
                                      label: 'Total SYP',
                                      value: AmountFormatter.format(
                                        dashboardSnapshot?.totalSyp ?? '0',
                                      ),
                                      caption: 'Across all wallets',
                                      icon:
                                          Icons.account_balance_wallet_rounded,
                                    ),
                                  ),
                                ],
                              );
                            },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                DashboardSectionHeader(
                  title: 'Wallet Summary',
                  subtitle: 'Your active and archived wallets at a glance.',
                  trailing: TextButton(
                    onPressed: () => context.go(AppRoutes.walletsPath),
                    child: const Text('View all'),
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                if (recentWallets.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: AppSpacing.xl),
                    child: Text('No wallets available yet.'),
                  )
                else
                  ...recentWallets.map(
                    (walletOverview) => Padding(
                      padding: const EdgeInsets.only(bottom: AppSpacing.md),
                      child: WalletOverviewCard(
                        walletOverview: walletOverview,
                        onTap: () => context.push(
                          AppRoutes.walletDetailsLocation(
                            walletOverview.wallet.id,
                          ),
                        ),
                      ),
                    ),
                  ),
                const SizedBox(height: AppSpacing.xl),
                const DashboardSectionHeader(
                  title: 'Recent Activity',
                  subtitle:
                      'Mock wallet activity until the transaction module is ready.',
                ),
                const SizedBox(height: AppSpacing.md),
                PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Column(
                      children:
                          dashboardSnapshot?.recentActivities
                              .map((item) {
                                return ListTile(
                                  contentPadding: EdgeInsets.zero,
                                  leading: const CircleAvatar(
                                    backgroundColor: AppColors.canvasTop,
                                    child: Icon(
                                      Icons.history_rounded,
                                      color: AppColors.brand,
                                    ),
                                  ),
                                  title: Text(item.title),
                                  subtitle: Text(item.subtitle),
                                  trailing: Text(
                                    item.walletName,
                                    textAlign: TextAlign.right,
                                  ),
                                );
                              })
                              .toList(growable: false) ??
                          const <Widget>[
                            ListTile(
                              contentPadding: EdgeInsets.zero,
                              title: Text('No activity yet.'),
                            ),
                          ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                const DashboardSectionHeader(
                  title: 'Quick Actions',
                  subtitle:
                      'Visible now, activated in the next finance phases.',
                ),
                const SizedBox(height: AppSpacing.md),
                GridView.count(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: MediaQuery.sizeOf(context).width < 760
                      ? 2
                      : 4,
                  childAspectRatio: 1.12,
                  mainAxisSpacing: AppSpacing.md,
                  crossAxisSpacing: AppSpacing.md,
                  children: const <Widget>[
                    DisabledQuickActionCard(
                      label: 'Deposit',
                      icon: Icons.south_west_rounded,
                    ),
                    DisabledQuickActionCard(
                      label: 'Withdraw',
                      icon: Icons.north_east_rounded,
                    ),
                    DisabledQuickActionCard(
                      label: 'Transfer',
                      icon: Icons.sync_alt_rounded,
                    ),
                    DisabledQuickActionCard(
                      label: 'Exchange',
                      icon: Icons.currency_exchange_rounded,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.xl),
                PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.lg),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Session & access',
                                style: context.titleMedium,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Text(
                                authState.isBiometricLoginEnabled
                                    ? 'Biometric login enabled'
                                    : 'Biometric login disabled',
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        PwButton.secondary(
                          label: 'Logout',
                          onPressed: () async {
                            final result = await ref
                                .read(authControllerProvider.notifier)
                                .logout();

                            if (!context.mounted) {
                              return;
                            }

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(result.message)),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
