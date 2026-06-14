import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_providers.dart';
import '../../../debts/domain/models/debt_summary.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../../transfers/domain/models/transfer_summary.dart';
import '../../../transfers/presentation/providers/transfer_providers.dart';
import '../../../transactions/domain/models/ledger_transaction.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../../wallets/presentation/widgets/create_wallet_sheet.dart';
import '../widgets/dashboard_activity_list.dart';
import '../widgets/dashboard_breakpoints.dart';
import '../widgets/dashboard_empty_state.dart';
import '../widgets/dashboard_header.dart';
import '../widgets/dashboard_section_title.dart';
import '../widgets/dashboard_skeleton_block.dart';
import '../widgets/dashboard_total_assets_card.dart';
import '../widgets/dashboard_wallet_preview_card.dart';

class DashboardPlaceholderPage extends ConsumerStatefulWidget {
  const DashboardPlaceholderPage({super.key});

  @override
  ConsumerState<DashboardPlaceholderPage> createState() =>
      _DashboardPlaceholderPageState();
}

class _DashboardPlaceholderPageState
    extends ConsumerState<DashboardPlaceholderPage> {
  Future<void> _retryWalletsSection() async {
    await ref.read(walletControllerProvider.notifier).initialize();
  }

  Future<void> _retryActivitySection() async {
    await Future.wait(<Future<void>>[
      ref.read(transactionControllerProvider.notifier).initialize(),
      ref.read(transferControllerProvider.notifier).initialize(),
      ref.read(debtControllerProvider.notifier).initialize(),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);
    final transferState = ref.watch(transferControllerProvider);
    final debtState = ref.watch(debtControllerProvider);
    final session = authState.session;
    final dashboardSnapshot = walletState.dashboardSnapshot;
    final List<WalletOverview> recentWallets =
        dashboardSnapshot?.walletSummaries.take(3).toList(growable: false) ??
        const <WalletOverview>[];
    final Map<String, String> walletNames = <String, String>{
      for (final WalletOverview wallet in walletState.wallets)
        wallet.wallet.id: wallet.wallet.name,
    };
    final Set<String> hiddenLedgerIds = transferState.transfers
        .map((TransferSummary item) => item.transfer.ledgerTransactionId)
        .toSet();
    final List<DashboardActivityData> recentActivities =
        <DashboardActivityData>[
          ...transactionState.transactions
              .where(
                (LedgerTransaction transaction) =>
                    !hiddenLedgerIds.contains(transaction.id) &&
                    transaction.recipientUserId == null &&
                    transaction.transferRecordId == null &&
                    transaction.debtSettlementId == null,
              )
              .map(
                (LedgerTransaction transaction) =>
                    DashboardActivityData.fromTransaction(
                      transaction,
                      walletNames[transaction.sourceWalletId ??
                              transaction.destinationWalletId ??
                              ''] ??
                          context.tr.walletFallback,
                      context,
                    ),
              ),
          ...transferState.transfers.map(
            (TransferSummary transfer) => DashboardActivityData.fromTransfer(
              transfer,
              context,
              senderWalletName:
                  walletNames[transfer.transfer.senderWalletId] ??
                  context.tr.walletFallback,
              recipientWalletName:
                  walletNames[transfer.transfer.recipientWalletId] ??
                  context.tr.walletFallback,
            ),
          ),
          ...debtState.debts.expand(
            (DebtSummary summary) => <DashboardActivityData>[
              DashboardActivityData.fromDebt(summary, context),
              ...summary.repayments.map(
                (repayment) => DashboardActivityData.fromRepayment(
                  summary,
                  repayment,
                  context,
                ),
              ),
            ],
          ),
        ]..sort(
          (DashboardActivityData left, DashboardActivityData right) =>
              right.timestamp.compareTo(left.timestamp),
        );
    final List<DashboardActivityData> visibleRecentActivities = recentActivities
        .take(10)
        .toList(growable: false);
    final bool isInitialDashboardLoading =
        walletState.isLoading && dashboardSnapshot == null;
    final bool isWalletsLoading =
        walletState.isLoading && recentWallets.isEmpty;
    final bool isActivitiesLoading =
        ((transactionState.isLoading &&
                transactionState.transactions.isEmpty) ||
            (transferState.isLoading && transferState.transfers.isEmpty) ||
            (debtState.isLoading && debtState.debts.isEmpty)) &&
        visibleRecentActivities.isEmpty;
    final String? walletSectionError = walletState.errorMessage;
    final String? activitySectionError = _firstNonEmpty(<String?>[
      transactionState.errorMessage,
      transferState.errorMessage,
      debtState.errorMessage,
    ]);
    final String userName =
        session?.user.displayName ?? context.tr.userFallback;
    final String? profileImageUri = session?.user.profileImageUri;

    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final DashboardBreakpoint breakpoint = resolveDashboardBreakpoint(
              constraints.biggest,
            );
            final double horizontalPadding = resolveDashboardHorizontalPadding(
              breakpoint,
            );
            final int walletColumns = switch (breakpoint) {
              DashboardBreakpoint.largeTablet => 3,
              DashboardBreakpoint.tablet => 2,
              DashboardBreakpoint.phone => 1,
              DashboardBreakpoint.smallPhone => 1,
            };

            return Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: dashboardPageMaxWidth,
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.xl,
                    horizontalPadding,
                    AppSpacing.xxl,
                  ),
                  children: <Widget>[
                    if (isInitialDashboardLoading)
                      const _DashboardHeaderSkeleton()
                    else
                      DashboardHeader(
                        greeting: _resolveGreeting(context),
                        userName: userName,
                        profileImageUri: profileImageUri,
                      ),
                    const SizedBox(height: AppSpacing.xl),
                    DashboardTotalAssetsCard(
                      totalUsd: dashboardSnapshot?.totalUsd ?? '0',
                      totalSyp: dashboardSnapshot?.totalSyp ?? '0',
                      updatedLabel: context.tr.updatedNow,
                      isLoading: isInitialDashboardLoading,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    DashboardSectionTitle(
                      title: context.tr.myWallets,
                      actionLabel: context.tr.seeAll,
                      onActionPressed: () => context.go(AppRoutes.walletsPath),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    _WalletsPreviewSection(
                      wallets: recentWallets,
                      columns: walletColumns,
                      showBalances: true,
                      isLoading: isWalletsLoading,
                      errorMessage: walletSectionError,
                      onRetry: _retryWalletsSection,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    DashboardSectionTitle(
                      title: context.tr.recentActivity,
                      actionLabel: context.tr.seeAll,
                      onActionPressed: () =>
                          context.push(AppRoutes.transactionsPath),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (activitySectionError != null &&
                        !isActivitiesLoading &&
                        visibleRecentActivities.isEmpty)
                      DashboardEmptyState.error(
                        title: context.tr.somethingWentWrong,
                        message: context.tr.dashboardActivityLoadFailedMessage,
                        actionLabel: context.tr.tryAgain,
                        onActionPressed: _retryActivitySection,
                      )
                    else
                      DashboardActivityList(
                        items: visibleRecentActivities,
                        isLoading: isActivitiesLoading,
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  String _resolveGreeting(BuildContext context) {
    final int hour = DateTime.now().hour;
    if (hour < 12) {
      return context.tr.goodMorning;
    }
    if (hour < 18) {
      return context.tr.goodAfternoon;
    }
    return context.tr.goodEvening;
  }
}

class _WalletsPreviewSection extends StatelessWidget {
  const _WalletsPreviewSection({
    required this.wallets,
    required this.columns,
    required this.showBalances,
    required this.isLoading,
    required this.onRetry,
    this.errorMessage,
  });

  final List<WalletOverview> wallets;
  final int columns;
  final bool showBalances;
  final bool isLoading;
  final String? errorMessage;
  final Future<void> Function() onRetry;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          if (columns == 1) {
            return const Column(
              children: <Widget>[
                DashboardWalletPreviewCard(
                  showBalances: false,
                  isLoading: true,
                ),
                SizedBox(height: AppSpacing.md),
                DashboardWalletPreviewCard(
                  showBalances: false,
                  isLoading: true,
                ),
                SizedBox(height: AppSpacing.md),
                DashboardWalletPreviewCard(
                  showBalances: false,
                  isLoading: true,
                ),
              ],
            );
          }

          final double itemWidth =
              (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
          return Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.md,
            children: List<Widget>.generate(
              3,
              (_) => SizedBox(
                width: itemWidth,
                child: const DashboardWalletPreviewCard(
                  showBalances: false,
                  isLoading: true,
                ),
              ),
            ),
          );
        },
      );
    }

    if (wallets.isEmpty) {
      if (errorMessage != null) {
        return DashboardEmptyState.error(
          title: context.tr.somethingWentWrong,
          message: context.tr.dashboardWalletsLoadFailedMessage,
          actionLabel: context.tr.tryAgain,
          onActionPressed: onRetry,
        );
      }
      return DashboardEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: context.tr.noWalletsTitle,
        message: context.tr.noWalletsMessage,
        actionLabel: context.tr.createWallet,
        onActionPressed: () => showCreateWalletSheet(context),
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (columns == 1) {
          return Column(
            children: wallets
                .map((WalletOverview wallet) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: DashboardWalletPreviewCard(
                      walletOverview: wallet,
                      showBalances: showBalances,
                      onTap: () => context.push(
                        AppRoutes.walletDetailsLocation(wallet.wallet.id),
                      ),
                    ),
                  );
                })
                .toList(growable: false),
          );
        }

        final double itemWidth =
            (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: wallets
              .map(
                (WalletOverview wallet) => SizedBox(
                  width: itemWidth,
                  child: DashboardWalletPreviewCard(
                    walletOverview: wallet,
                    showBalances: showBalances,
                    onTap: () => context.push(
                      AppRoutes.walletDetailsLocation(wallet.wallet.id),
                    ),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

String? _firstNonEmpty(List<String?> values) {
  for (final String? value in values) {
    if (value != null && value.trim().isNotEmpty) {
      return value;
    }
  }
  return null;
}

class _DashboardHeaderSkeleton extends StatelessWidget {
  const _DashboardHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        DashboardSkeletonBlock(height: 58, width: 58, radius: 22),
        SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              DashboardSkeletonBlock(height: 24, width: 88, radius: 999),
              SizedBox(height: AppSpacing.md),
              DashboardSkeletonBlock(height: 14, width: 110),
              SizedBox(height: AppSpacing.sm),
              DashboardSkeletonBlock(height: 30, width: 170),
            ],
          ),
        ),
      ],
    );
  }
}
