import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../dashboard/presentation/widgets/dashboard_breakpoints.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_skeleton_block.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transactions/domain/models/ledger_transaction.dart';
import '../../../transactions/presentation/pages/create_transfer_page.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../domain/models/wallet_overview.dart';
import '../providers/wallet_providers.dart';
import '../widgets/wallet_detail_action_sheets.dart';

class WalletDetailsPage extends ConsumerStatefulWidget {
  const WalletDetailsPage({required this.walletId, super.key});

  final String walletId;

  @override
  ConsumerState<WalletDetailsPage> createState() => _WalletDetailsPageState();
}

class _WalletDetailsPageState extends ConsumerState<WalletDetailsPage> {
  _WalletActivityFilter _filter = _WalletActivityFilter.all;

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
    final transactionState = ref.watch(transactionControllerProvider);
    final walletOverview = walletState.selectedWallet;

    final List<LedgerTransaction> walletTransactions = walletOverview == null
        ? const <LedgerTransaction>[]
        : _resolveWalletTransactions(
            transactionState.transactions,
            walletOverview.wallet.id,
          );
    final List<LedgerTransaction> filteredTransactions = _applyFilter(
      walletTransactions,
      _filter,
    );
    final bool hasActiveFilter = _filter != _WalletActivityFilter.all;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        titleSpacing: AppSpacing.sm,
        title: walletOverview == null
            ? Text(context.tr.walletDetails)
            : Text(
                walletOverview.wallet.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
        actions: walletOverview == null
            ? null
            : <Widget>[
                IconButton(
                  tooltip: context.tr.openActions,
                  onPressed: () => showEditWalletSheet(
                    context,
                    walletId: walletOverview.wallet.id,
                  ),
                  icon: const Icon(Icons.edit_outlined),
                ),
                const SizedBox(width: AppSpacing.xs),
              ],
      ),
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final DashboardBreakpoint breakpoint = resolveDashboardBreakpoint(
            constraints.biggest,
          );
          final double horizontalPadding = resolveDashboardHorizontalPadding(
            breakpoint,
          );

          if (walletState.isLoading && walletOverview == null) {
            return SafeArea(
              top: false,
              child: _WalletDetailsSkeleton(
                horizontalPadding: horizontalPadding,
              ),
            );
          }

          if (walletOverview == null) {
            return SafeArea(
              top: false,
              child: Padding(
                padding: EdgeInsets.fromLTRB(
                  horizontalPadding,
                  AppSpacing.md,
                  horizontalPadding,
                  AppSpacing.xxl,
                ),
                child: DashboardEmptyState.notFound(
                  title: context.tr.walletDetails,
                  message: context.tr.walletNotFound,
                ),
              ),
            );
          }

          return SafeArea(
            top: false,
            child: Align(
              alignment: Alignment.topCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: dashboardPageMaxWidth,
                ),
                child: ListView(
                  padding: EdgeInsets.fromLTRB(
                    horizontalPadding,
                    AppSpacing.md,
                    horizontalPadding,
                    AppSpacing.xxl,
                  ),
                  children: <Widget>[
                    _WalletHeroCard(walletOverview: walletOverview),
                    const SizedBox(height: AppSpacing.lg),
                    _WalletQuickActions(
                      onDeposit: () => showWalletDepositSheet(
                        context,
                        walletId: walletOverview.wallet.id,
                        walletName: walletOverview.wallet.name,
                      ),
                      onWithdraw: () => showWalletWithdrawSheet(
                        context,
                        walletId: walletOverview.wallet.id,
                        walletName: walletOverview.wallet.name,
                      ),
                      onTransfer: () => showCreateTransferSheet(
                        context,
                        initialSourceWalletId: walletOverview.wallet.id,
                      ),
                      onExchange: () => showWalletExchangeSheet(
                        context,
                        walletId: walletOverview.wallet.id,
                        walletName: walletOverview.wallet.name,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    _WalletActivityFilters(
                      selectedFilter: _filter,
                      onFilterSelected: (_WalletActivityFilter filter) {
                        setState(() => _filter = filter);
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    if (transactionState.isLoading &&
                        walletTransactions.isEmpty)
                      const _WalletActivitySkeletonList()
                    else if (filteredTransactions.isEmpty &&
                        walletTransactions.isEmpty)
                      DashboardEmptyState(
                        icon: Icons.receipt_long_outlined,
                        title: context.tr.noWalletActivityTitle,
                        message: context.tr.noWalletActivityMessage,
                      )
                    else if (filteredTransactions.isEmpty && hasActiveFilter)
                      DashboardEmptyState.filter(
                        title: context.tr.noWalletActivityFilterResultsTitle,
                        message:
                            context.tr.noWalletActivityFilterResultsMessage,
                        actionLabel: context.tr.clearFilters,
                        onActionPressed: () {
                          setState(() => _filter = _WalletActivityFilter.all);
                        },
                      )
                    else
                      Column(
                        children: filteredTransactions
                            .map(
                              (LedgerTransaction transaction) => Padding(
                                padding: const EdgeInsets.only(
                                  bottom: AppSpacing.md,
                                ),
                                child: _WalletActivityCard(
                                  transaction: transaction,
                                  onTap: () => context.push(
                                    AppRoutes.transactionDetailsLocation(
                                      transaction.id,
                                    ),
                                  ),
                                ),
                              ),
                            )
                            .toList(growable: false),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _WalletHeroCard extends StatelessWidget {
  const _WalletHeroCard({required this.walletOverview});

  final WalletOverview walletOverview;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final wallet = walletOverview.wallet;

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: _walletIndicatorColor(
                    wallet.name,
                    wallet.id,
                    colorScheme,
                  ),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: Text(
                  wallet.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: AppSpacing.xs,
                ),
                decoration: BoxDecoration(
                  color: wallet.isArchived
                      ? colorScheme.surfaceContainerHighest.withValues(
                          alpha: 0.50,
                        )
                      : colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  wallet.isArchived ? context.tr.archived : context.tr.active,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: wallet.isArchived
                        ? colorScheme.onSurfaceVariant
                        : colorScheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.tr.balanceUsd,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${AmountFormatter.format(walletOverview.balance.usdBalance.amount)} ${context.tr.usdShort}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            context.tr.balanceSyp,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.xs),
          Text(
            '${AmountFormatter.format(walletOverview.balance.sypBalance.amount)} ${context.tr.sypShort}',
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Wrap(
            spacing: AppSpacing.md,
            runSpacing: AppSpacing.xs,
            children: <Widget>[
              Text(
                '${context.tr.lastUpdated}: ${_relativeUpdatedLabel(context, wallet.updatedAt)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
              Text(
                '${context.tr.createdLabel}: ${DateFormatter.short(wallet.createdAt)}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.labelMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _WalletQuickActions extends StatelessWidget {
  const _WalletQuickActions({
    required this.onDeposit,
    required this.onWithdraw,
    required this.onTransfer,
    required this.onExchange,
  });

  final VoidCallback onDeposit;
  final VoidCallback onWithdraw;
  final VoidCallback onTransfer;
  final VoidCallback onExchange;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          _WalletActionChip(
            icon: Icons.south_west_rounded,
            label: context.tr.deposit,
            onTap: onDeposit,
          ),
          const SizedBox(width: AppSpacing.sm),
          _WalletActionChip(
            icon: Icons.north_east_rounded,
            label: context.tr.withdraw,
            onTap: onWithdraw,
          ),
          const SizedBox(width: AppSpacing.sm),
          _WalletActionChip(
            icon: Icons.swap_horiz_rounded,
            label: context.tr.transfer,
            onTap: onTransfer,
          ),
          const SizedBox(width: AppSpacing.sm),
          _WalletActionChip(
            icon: Icons.currency_exchange_rounded,
            label: context.tr.exchange,
            onTap: onExchange,
          ),
        ],
      ),
    );
  }
}

class _WalletActionChip extends StatelessWidget {
  const _WalletActionChip({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(icon, size: 18, color: colorScheme.primary),
              const SizedBox(width: AppSpacing.xs),
              Text(
                label,
                style: theme.textTheme.labelLarge?.copyWith(
                  color: colorScheme.primary,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _WalletActivityFilters extends StatelessWidget {
  const _WalletActivityFilters({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final _WalletActivityFilter selectedFilter;
  final ValueChanged<_WalletActivityFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          context.tr.recentActivity,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
        ),
        const SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _WalletActivityFilter.values
                .map((filter) {
                  return Padding(
                    padding: const EdgeInsetsDirectional.only(
                      end: AppSpacing.sm,
                    ),
                    child: ChoiceChip(
                      label: Text(_filterLabel(context, filter)),
                      selected: selectedFilter == filter,
                      onSelected: (_) => onFilterSelected(filter),
                    ),
                  );
                })
                .toList(growable: false),
          ),
        ),
      ],
    );
  }
}

class _WalletActivityCard extends StatelessWidget {
  const _WalletActivityCard({required this.transaction, required this.onTap});

  final LedgerTransaction transaction;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DashboardSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      _transactionAmount(transaction),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: _transactionAccentColor(
                          transaction.type,
                          colorScheme,
                        ),
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            _transactionTypeLabel(context, transaction),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            _transactionDescription(transaction),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            DateFormatter.full(transaction.createdAt),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    Container(
                      width: 38,
                      height: 38,
                      decoration: BoxDecoration(
                        color: _transactionAccentColor(
                          transaction.type,
                          colorScheme,
                        ).withValues(alpha: 0.10),
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      child: Icon(
                        _transactionIcon(transaction.type),
                        size: 18,
                        color: _transactionAccentColor(
                          transaction.type,
                          colorScheme,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.sm),
                Text(
                  '${context.tr.reference}: ${transaction.reference.value}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.labelMedium?.copyWith(
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _WalletDetailsSkeleton extends StatelessWidget {
  const _WalletDetailsSkeleton({required this.horizontalPadding});

  final double horizontalPadding;

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        horizontalPadding,
        AppSpacing.md,
        horizontalPadding,
        AppSpacing.xxl,
      ),
      children: const <Widget>[
        _WalletHeroSkeleton(),
        SizedBox(height: AppSpacing.lg),
        _WalletActionsSkeleton(),
        SizedBox(height: AppSpacing.lg),
        _WalletActivityHeaderSkeleton(),
        SizedBox(height: AppSpacing.md),
        _WalletActivitySkeletonList(),
      ],
    );
  }
}

class _WalletHeroSkeleton extends StatelessWidget {
  const _WalletHeroSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              DashboardSkeletonBlock(height: 10, width: 10, radius: 999),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: DashboardSkeletonBlock(height: 20, width: 148)),
              SizedBox(width: AppSpacing.sm),
              DashboardSkeletonBlock(
                height: 28,
                width: 72,
                radius: AppRadius.pill,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          DashboardSkeletonBlock(height: 14, width: 88),
          SizedBox(height: AppSpacing.xs),
          DashboardSkeletonBlock(height: 30, width: 190),
          SizedBox(height: AppSpacing.sm),
          DashboardSkeletonBlock(height: 14, width: 88),
          SizedBox(height: AppSpacing.xs),
          DashboardSkeletonBlock(height: 24, width: 164),
          SizedBox(height: AppSpacing.md),
          DashboardSkeletonBlock(height: 14, width: 132),
        ],
      ),
    );
  }
}

class _WalletActionsSkeleton extends StatelessWidget {
  const _WalletActionsSkeleton();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: <Widget>[
          DashboardSkeletonBlock(height: 38, width: 88, radius: AppRadius.pill),
          SizedBox(width: AppSpacing.sm),
          DashboardSkeletonBlock(height: 38, width: 96, radius: AppRadius.pill),
          SizedBox(width: AppSpacing.sm),
          DashboardSkeletonBlock(height: 38, width: 92, radius: AppRadius.pill),
          SizedBox(width: AppSpacing.sm),
          DashboardSkeletonBlock(height: 38, width: 96, radius: AppRadius.pill),
        ],
      ),
    );
  }
}

class _WalletActivityHeaderSkeleton extends StatelessWidget {
  const _WalletActivityHeaderSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DashboardSkeletonBlock(height: 22, width: 132),
        SizedBox(height: AppSpacing.sm),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: <Widget>[
              DashboardSkeletonBlock(
                height: 34,
                width: 58,
                radius: AppRadius.pill,
              ),
              SizedBox(width: AppSpacing.sm),
              DashboardSkeletonBlock(
                height: 34,
                width: 82,
                radius: AppRadius.pill,
              ),
              SizedBox(width: AppSpacing.sm),
              DashboardSkeletonBlock(
                height: 34,
                width: 98,
                radius: AppRadius.pill,
              ),
              SizedBox(width: AppSpacing.sm),
              DashboardSkeletonBlock(
                height: 34,
                width: 92,
                radius: AppRadius.pill,
              ),
              SizedBox(width: AppSpacing.sm),
              DashboardSkeletonBlock(
                height: 34,
                width: 86,
                radius: AppRadius.pill,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WalletActivitySkeletonList extends StatelessWidget {
  const _WalletActivitySkeletonList();

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: <Widget>[
        _WalletActivitySkeletonCard(),
        SizedBox(height: AppSpacing.md),
        _WalletActivitySkeletonCard(),
        SizedBox(height: AppSpacing.md),
        _WalletActivitySkeletonCard(),
      ],
    );
  }
}

class _WalletActivitySkeletonCard extends StatelessWidget {
  const _WalletActivitySkeletonCard();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              SizedBox(width: AppSpacing.sm),
              DashboardSkeletonBlock(height: 20, width: 92),
              SizedBox(width: AppSpacing.sm),
              Expanded(child: DashboardSkeletonBlock(height: 18, width: 148)),
              SizedBox(width: AppSpacing.md),
              DashboardSkeletonBlock(
                height: 38,
                width: 38,
                radius: AppRadius.md,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.sm),
          DashboardSkeletonBlock(height: 14, width: 200),
          SizedBox(height: AppSpacing.sm),
          DashboardSkeletonBlock(height: 14, width: 136),
        ],
      ),
    );
  }
}

enum _WalletActivityFilter { all, deposit, withdraw, transfer, exchange }

List<LedgerTransaction> _resolveWalletTransactions(
  List<LedgerTransaction> transactions,
  String walletId,
) {
  final List<LedgerTransaction> filtered = transactions.where((transaction) {
    return transaction.sourceWalletId == walletId ||
        transaction.destinationWalletId == walletId;
  }).toList();

  filtered.sort((left, right) => right.createdAt.compareTo(left.createdAt));
  return filtered;
}

List<LedgerTransaction> _applyFilter(
  List<LedgerTransaction> transactions,
  _WalletActivityFilter filter,
) {
  return switch (filter) {
    _WalletActivityFilter.all => transactions,
    _WalletActivityFilter.deposit =>
      transactions.where((tx) => tx.type == TransactionType.deposit).toList(),
    _WalletActivityFilter.withdraw =>
      transactions.where((tx) => tx.type == TransactionType.withdraw).toList(),
    _WalletActivityFilter.transfer =>
      transactions.where((tx) => tx.type == TransactionType.transfer).toList(),
    _WalletActivityFilter.exchange =>
      transactions.where((tx) => tx.type == TransactionType.exchange).toList(),
  };
}

String _filterLabel(BuildContext context, _WalletActivityFilter filter) {
  return switch (filter) {
    _WalletActivityFilter.all => context.tr.all,
    _WalletActivityFilter.deposit => context.tr.deposits,
    _WalletActivityFilter.withdraw => context.tr.withdrawals,
    _WalletActivityFilter.transfer => context.tr.transfers,
    _WalletActivityFilter.exchange => context.tr.exchanges,
  };
}

String _transactionTypeLabel(
  BuildContext context,
  LedgerTransaction transaction,
) {
  return switch (transaction.type) {
    TransactionType.deposit => context.tr.deposit,
    TransactionType.withdraw => context.tr.withdraw,
    TransactionType.transfer => context.tr.transfer,
    TransactionType.exchange => context.tr.exchange,
    TransactionType.reversal => context.tr.reversalActivity,
    TransactionType.correction => context.tr.correctionActivity,
  };
}

String _transactionAmount(LedgerTransaction transaction) {
  return '${AmountFormatter.format(transaction.sourceAmount)} ${transaction.sourceCurrency.name.toUpperCase()}';
}

String _transactionDescription(LedgerTransaction transaction) {
  if ((transaction.note ?? '').trim().isNotEmpty) {
    return transaction.note!.trim();
  }
  return transaction.reference.value;
}

Color _transactionAccentColor(TransactionType type, ColorScheme colorScheme) {
  return switch (type) {
    TransactionType.deposit => const Color(0xFF1E8E5A),
    TransactionType.withdraw => colorScheme.error,
    TransactionType.transfer => colorScheme.primary,
    TransactionType.exchange => const Color(0xFFCC7A00),
    TransactionType.reversal => colorScheme.onSurfaceVariant,
    TransactionType.correction => colorScheme.onSurfaceVariant,
  };
}

IconData _transactionIcon(TransactionType type) {
  return switch (type) {
    TransactionType.deposit => Icons.south_west_rounded,
    TransactionType.withdraw => Icons.north_east_rounded,
    TransactionType.transfer => Icons.swap_horiz_rounded,
    TransactionType.exchange => Icons.currency_exchange_rounded,
    TransactionType.reversal => Icons.undo_rounded,
    TransactionType.correction => Icons.tune_rounded,
  };
}

Color _walletIndicatorColor(
  String walletName,
  String walletId,
  ColorScheme colorScheme,
) {
  final String normalized = walletName.toLowerCase();

  if (normalized.contains('home') || normalized.contains('main')) {
    return colorScheme.primary;
  }
  if (normalized.contains('saving')) {
    return const Color(0xFF1E8E5A);
  }
  if (normalized.contains('business')) {
    return const Color(0xFFCC7A00);
  }
  if (normalized.contains('travel')) {
    return const Color(0xFF7A52C7);
  }

  const List<Color> palette = <Color>[
    Color(0xFF0E5A8A),
    Color(0xFF1E8E5A),
    Color(0xFFCC7A00),
    Color(0xFF7A52C7),
    Color(0xFF0097A7),
  ];

  return palette[walletId.hashCode.abs() % palette.length];
}

String _relativeUpdatedLabel(BuildContext context, DateTime updatedAt) {
  final DateTime now = DateTime.now();
  final DateTime localUpdatedAt = updatedAt.toLocal();
  final Duration difference = now.difference(localUpdatedAt);

  if (difference.inMinutes < 1) {
    return context.tr.updatedJustNow;
  }
  if (difference.inMinutes < 60) {
    return context.tr.updatedMinutesAgo(difference.inMinutes);
  }
  if (difference.inHours < 6) {
    return context.tr.updatedHoursAgo(difference.inHours);
  }
  if (_isSameDate(now, localUpdatedAt)) {
    return context.tr.updatedToday;
  }
  if (_isSameDate(now.subtract(const Duration(days: 1)), localUpdatedAt)) {
    return context.tr.updatedYesterday;
  }
  return context.tr.updatedDaysAgo(difference.inDays);
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
