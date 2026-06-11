import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart' hide TextDirection;

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../features/attachments/domain/enums/attachment_reference_type.dart';
import '../../../../features/attachments/domain/models/attachment.dart';
import '../../../../features/attachments/domain/models/attachment_reference.dart';
import '../../../../features/attachments/presentation/controllers/attachment_state.dart';
import '../../../../features/attachments/presentation/providers/attachment_providers.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../debts/domain/models/debt_repayment.dart';
import '../../../debts/domain/models/debt_summary.dart';
import '../../../debts/presentation/pages/create_debt_page.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../../transfers/domain/models/transfer_summary.dart';
import '../../../transfers/presentation/providers/transfer_providers.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/enums/transaction_sort_option.dart';
import '../../domain/models/ledger_transaction.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_bottom_sheet.dart';
import '../widgets/transaction_flow_support.dart';
import '../widgets/transaction_operation_flow.dart';

class TransactionsPage extends ConsumerStatefulWidget {
  const TransactionsPage({super.key});

  @override
  ConsumerState<TransactionsPage> createState() => _TransactionsPageState();
}

enum _ActivityCategory {
  all,
  deposit,
  withdraw,
  transfer,
  debt,
  debtRepayment,
  exchange,
}

enum _DateRangeFilter { all, today, thisWeek, thisMonth, last30Days }

enum _ActivityStatus { completed, pending, failed, cancelled }

class _TransactionsPageState extends ConsumerState<TransactionsPage> {
  late final TextEditingController _searchController;
  _ActivityCategory _selectedCategory = _ActivityCategory.all;
  _DateRangeFilter _dateRange = _DateRangeFilter.all;
  TransactionSortOption _sortOption = TransactionSortOption.newest;
  String? _selectedCurrencyCode;
  String? _selectedWalletName;
  String? _selectedContactName;
  _ActivityStatus? _selectedStatus;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionControllerProvider);
    final transferState = ref.watch(transferControllerProvider);
    final debtState = ref.watch(debtControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final bool isLoading =
        (transactionState.isLoading && transactionState.transactions.isEmpty) ||
        (transferState.isLoading && transferState.transfers.isEmpty) ||
        (debtState.isLoading && debtState.debts.isEmpty);

    final Map<String, WalletOverview> walletLookup = <String, WalletOverview>{
      for (final WalletOverview wallet in walletState.wallets)
        wallet.wallet.id: wallet,
    };
    final Iterable<String> hiddenLedgerIds = transferState.transfers.map(
      (TransferSummary item) => item.transfer.ledgerTransactionId,
    );
    final List<_ActivityItem> allItems = _buildActivityFeed(
      context,
      transactions: transactionState.transactions,
      transfers: transferState.transfers,
      debts: debtState.debts,
      walletLookup: walletLookup,
      hiddenLedgerIds: hiddenLedgerIds.toSet(),
    );
    final _ActivitySummary summary = _ActivitySummary.fromItems(
      _applyDateRange(
        _applySearch(allItems, _searchController.text),
        _dateRange,
      ),
    );
    final List<_ActivityItem> visibleItems = _sortItems(
      _applyAdvancedFilters(
        _applyCategory(
          _applyDateRange(
            _applySearch(allItems, _searchController.text),
            _dateRange,
          ),
          _selectedCategory,
        ),
        currencyCode: _selectedCurrencyCode,
        walletName: _selectedWalletName,
        contactName: _selectedContactName,
        status: _selectedStatus,
      ),
      _sortOption,
    );
    final List<_ActivitySection> sections = _groupActivitiesByDate(
      context,
      visibleItems,
    );

    return PwScaffold(
      title: context.tr.transactions,
      actions: <Widget>[
        IconButton(
          onPressed: _showCreateActionSheet,
          icon: const Icon(Icons.add_rounded),
          tooltip: context.tr.transactionsCreateFirst,
        ),
      ],
      body: CustomScrollView(
        keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: _TransactionsHeader(
              controller: _searchController,
              onSearchChanged: (_) => setState(() {}),
              onOpenFilters: _showFilterSheet,
              onOpenDateRange: _showFilterSheet,
              dateRangeLabel: _dateRangeLabel(context, _dateRange),
              activeFilterCount: _activeFilterCount,
              hasCustomDateRange: _dateRange != _DateRangeFilter.all,
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.only(top: AppSpacing.md),
              child: isLoading
                  ? const _TransactionsSummarySkeleton()
                  : _TransactionsSummaryStrip(summary: summary),
            ),
          ),
          SliverPersistentHeader(
            pinned: true,
            delegate: _PinnedHeaderDelegate(
              minHeight: 52,
              maxHeight: 52,
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.xs),
                child: _CategoryChips(
                  selectedCategory: _selectedCategory,
                  onSelected: (_ActivityCategory value) {
                    setState(() => _selectedCategory = value);
                  },
                ),
              ),
            ),
          ),
          SliverPadding(
            padding: const EdgeInsets.only(
              top: AppSpacing.md,
              bottom: AppSpacing.xxl,
            ),
            sliver: isLoading
                ? const SliverToBoxAdapter(
                    child: _TransactionsTimelineSkeleton(),
                  )
                : allItems.isEmpty
                ? SliverToBoxAdapter(
                    child: DashboardEmptyState(
                      icon: Icons.receipt_long_outlined,
                      title: context.tr.transactionsEmptyStateTitle,
                      message: context.tr.transactionsEmptyStateMessage,
                      actionLabel: context.tr.transactionsCreateFirst,
                      onActionPressed: _showCreateActionSheet,
                    ),
                  )
                : visibleItems.isEmpty
                ? SliverToBoxAdapter(
                    child: DashboardEmptyState(
                      icon: Icons.search_off_rounded,
                      title: context.tr.noTransactionsTitle,
                      message: context.tr.transactionsNoResultsMessage,
                      actionLabel: context.tr.clearSearch,
                      onActionPressed: () {
                        _searchController.clear();
                        setState(() {
                          _selectedCategory = _ActivityCategory.all;
                          _dateRange = _DateRangeFilter.all;
                          _selectedCurrencyCode = null;
                          _selectedWalletName = null;
                          _selectedContactName = null;
                          _selectedStatus = null;
                        });
                      },
                    ),
                  )
                : SliverList(
                    delegate: SliverChildBuilderDelegate((
                      BuildContext context,
                      int index,
                    ) {
                      final _ActivitySection section = sections[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: _ActivityGroupSection(
                          section: section,
                          onTap: _showActivityDetails,
                        ),
                      );
                    }, childCount: sections.length),
                  ),
          ),
        ],
      ),
    );
  }

  int get _activeFilterCount {
    int count = 0;
    if (_selectedCurrencyCode != null) {
      count += 1;
    }
    if (_selectedWalletName != null) {
      count += 1;
    }
    if (_selectedContactName != null) {
      count += 1;
    }
    if (_selectedStatus != null) {
      count += 1;
    }
    return count;
  }

  Future<void> _showFilterSheet() async {
    final transactionState = ref.read(transactionControllerProvider);
    final transferState = ref.read(transferControllerProvider);
    final debtState = ref.read(debtControllerProvider);
    final walletState = ref.read(walletControllerProvider);
    final Map<String, WalletOverview> walletLookup = <String, WalletOverview>{
      for (final WalletOverview wallet in walletState.wallets)
        wallet.wallet.id: wallet,
    };
    final Set<String> hiddenLedgerIds = transferState.transfers
        .map((TransferSummary item) => item.transfer.ledgerTransactionId)
        .toSet();
    final List<_ActivityItem> allItems = _buildActivityFeed(
      context,
      transactions: transactionState.transactions,
      transfers: transferState.transfers,
      debts: debtState.debts,
      walletLookup: walletLookup,
      hiddenLedgerIds: hiddenLedgerIds,
    );
    final _ActivityFilterOptions options = _buildFilterOptions(allItems);
    final _ActivityFilterSheetResult? result =
        await showAppModalBottomSheet<_ActivityFilterSheetResult>(
          context: context,
          isScrollControlled: true,
          builder: (BuildContext context) {
            return _ActivityFilterSheet(
              selectedSortOption: _sortOption,
              selectedDateRange: _dateRange,
              selectedCurrencyCode: _selectedCurrencyCode,
              selectedWalletName: _selectedWalletName,
              selectedContactName: _selectedContactName,
              selectedStatus: _selectedStatus,
              options: options,
            );
          },
        );

    if (result == null) {
      return;
    }
    setState(() {
      _sortOption = result.sortOption;
      _dateRange = result.dateRange;
      _selectedCurrencyCode = result.currencyCode;
      _selectedWalletName = result.walletName;
      _selectedContactName = result.contactName;
      _selectedStatus = result.status;
    });
  }

  Future<void> _showCreateActionSheet() async {
    final _CreateAction? action = await showAppModalBottomSheet<_CreateAction>(
      context: context,
      builder: (BuildContext context) {
        return const _CreateActivitySheet();
      },
    );

    if (!mounted || action == null) {
      return;
    }

    switch (action) {
      case _CreateAction.deposit:
        showTransactionBottomSheet(
          context,
          type: TransactionOperationType.deposit,
        );
        break;
      case _CreateAction.withdraw:
        showTransactionBottomSheet(
          context,
          type: TransactionOperationType.withdraw,
        );
        break;
      case _CreateAction.exchange:
        showTransactionBottomSheet(
          context,
          type: TransactionOperationType.exchange,
        );
        break;
      case _CreateAction.transfer:
        context.push(AppRoutes.userTransferCreatePath);
        break;
      case _CreateAction.debt:
        showCreateDebtSheet(context);
        break;
    }
  }

  Future<void> _showActivityDetails(_ActivityItem item) {
    return showAppModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      builder: (BuildContext context) {
        return _ActivityDetailsSheet(item: item);
      },
    );
  }
}

enum _CreateAction { deposit, withdraw, exchange, transfer, debt }

class _TransactionsHeader extends StatelessWidget {
  const _TransactionsHeader({
    required this.controller,
    required this.onSearchChanged,
    required this.onOpenFilters,
    required this.onOpenDateRange,
    required this.dateRangeLabel,
    required this.activeFilterCount,
    required this.hasCustomDateRange,
  });

  final TextEditingController controller;
  final ValueChanged<String> onSearchChanged;
  final VoidCallback onOpenFilters;
  final VoidCallback onOpenDateRange;
  final String dateRangeLabel;
  final int activeFilterCount;
  final bool hasCustomDateRange;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Expanded(
                child: DashboardSurfaceCard(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.xs + 2,
                  ),
                  child: Row(
                    children: <Widget>[
                      Icon(
                        Icons.search_rounded,
                        size: 18,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppSpacing.xs + 2),
                      Expanded(
                        child: TextField(
                          controller: controller,
                          onChanged: onSearchChanged,
                          textInputAction: TextInputAction.search,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: context.tr.transactionsSearchHint,
                            hintStyle: theme.textTheme.bodyMedium?.copyWith(
                              color: theme.colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              _HeaderActionButton(
                icon: Icons.tune_rounded,
                label: context.tr.filter,
                isActive: activeFilterCount > 0,
                badgeLabel: activeFilterCount > 0 ? '$activeFilterCount' : null,
                onTap: onOpenFilters,
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xs + 2),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: _HeaderActionButton(
              icon: Icons.date_range_rounded,
              label: dateRangeLabel,
              isActive: hasCustomDateRange,
              onTap: onOpenDateRange,
            ),
          ),
        ],
      ),
    );
  }
}

class _PinnedHeaderDelegate extends SliverPersistentHeaderDelegate {
  const _PinnedHeaderDelegate({
    required this.minHeight,
    required this.maxHeight,
    required this.child,
  });

  final double minHeight;
  final double maxHeight;
  final Widget child;

  @override
  double get minExtent => minHeight;

  @override
  double get maxExtent => maxHeight;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: colorScheme.surfaceContainerLowest,
        border: Border(
          bottom: BorderSide(
            color: colorScheme.outline.withValues(alpha: 0.10),
          ),
        ),
        boxShadow: overlapsContent
            ? <BoxShadow>[
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 12,
                  offset: const Offset(0, 5),
                ),
              ]
            : const <BoxShadow>[],
      ),
      child: Align(alignment: AlignmentDirectional.centerStart, child: child),
    );
  }

  @override
  bool shouldRebuild(covariant _PinnedHeaderDelegate oldDelegate) {
    return minHeight != oldDelegate.minHeight ||
        maxHeight != oldDelegate.maxHeight ||
        child != oldDelegate.child;
  }
}

class _HeaderActionButton extends StatelessWidget {
  const _HeaderActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isActive = false,
    this.badgeLabel,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isActive;
  final String? badgeLabel;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: Ink(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs + 2,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? colorScheme.primary.withValues(alpha: 0.1)
              : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: isActive ? colorScheme.primary : AppColors.outlineSoft,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 16, color: colorScheme.primary),
            const SizedBox(width: 6),
            Text(
              label,
              style: Theme.of(
                context,
              ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
            if (badgeLabel != null) ...<Widget>[
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                child: Text(
                  badgeLabel!,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: colorScheme.onPrimary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _TransactionsSummaryStrip extends StatelessWidget {
  const _TransactionsSummaryStrip({required this.summary});

  final _ActivitySummary summary;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _SummaryCard(
            value: '${summary.totalCount}',
            label: context.tr.transactionsTotalSummary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryCard(
            value: '${summary.monthCount}',
            label: context.tr.transactionsMonthSummary,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Expanded(
          child: _SummaryCard(
            value: '${summary.todayCount}',
            label: context.tr.transactionsTodaySummary,
          ),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 1),
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelMedium?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _TransactionsSummarySkeleton extends StatelessWidget {
  const _TransactionsSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: List<Widget>.generate(
        3,
        (int index) => Expanded(
          child: Padding(
            padding: EdgeInsetsDirectional.only(
              end: index == 2 ? 0 : AppSpacing.sm,
            ),
            child: const TransactionSkeletonBlock(height: 52, radius: 16),
          ),
        ),
      ),
    );
  }
}

class _CategoryChips extends StatelessWidget {
  const _CategoryChips({
    required this.selectedCategory,
    required this.onSelected,
  });

  final _ActivityCategory selectedCategory;
  final ValueChanged<_ActivityCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: AlignmentDirectional.centerStart,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsetsDirectional.only(end: AppSpacing.xs),
        child: Row(
          children: _ActivityCategory.values
              .map(
                (_ActivityCategory category) => Padding(
                  padding: const EdgeInsetsDirectional.only(end: 6),
                  child: _FilterChip(
                    label: _categoryLabel(context, category),
                    selected: category == selectedCategory,
                    onTap: () => onSelected(category),
                  ),
                ),
              )
              .toList(growable: false),
        ),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: 6,
        ),
        decoration: BoxDecoration(
          color: selected ? colorScheme.primary : colorScheme.surface,
          borderRadius: BorderRadius.circular(AppRadius.pill),
          border: Border.all(
            color: selected
                ? colorScheme.primary
                : colorScheme.outline.withValues(alpha: 0.16),
          ),
          boxShadow: selected
              ? <BoxShadow>[
                  BoxShadow(
                    color: colorScheme.primary.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : const <BoxShadow>[],
        ),
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: selected
                ? colorScheme.onPrimary
                : colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}

class _ActivityGroupSection extends StatelessWidget {
  const _ActivityGroupSection({required this.section, required this.onTap});

  final _ActivitySection section;
  final ValueChanged<_ActivityItem> onTap;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: AppSpacing.xs + 2),
          child: Text(
            section.label,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w800),
          ),
        ),
        ...section.items.map(
          (_ActivityItem item) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.xs + 2),
            child: _ActivityCard(item: item, onTap: () => onTap(item)),
          ),
        ),
      ],
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({required this.item, required this.onTap});

  final _ActivityItem item;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return DashboardSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.sm,
              vertical: AppSpacing.xs + 2,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: item.amountColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(11),
                      ),
                      alignment: Alignment.center,
                      child: Icon(item.icon, color: item.amountColor, size: 17),
                    ),
                    const SizedBox(width: AppSpacing.xs + 2),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          _DirectionalText(
                            item.title,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.titleSmall
                                ?.copyWith(fontWeight: FontWeight.w900),
                          ),
                          const SizedBox(height: 2),
                          _DirectionalText(
                            item.primaryContext,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.bodySmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: colorScheme.onSurfaceVariant,
                                ),
                          ),
                          if (item.notePreview != null) ...<Widget>[
                            const SizedBox(height: 2),
                            _DirectionalText(
                              item.notePreview!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: colorScheme.onSurfaceVariant
                                        .withValues(alpha: 0.9),
                                  ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Directionality(
                          textDirection: TextDirection.ltr,
                          child: Text(
                            item.amountLabel,
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(
                                  color: item.amountColor,
                                  fontWeight: FontWeight.w900,
                                ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                        const SizedBox(height: 3),
                        _StatusDateLine(item: item),
                      ],
                    ),
                  ],
                ),
                if (item.secondaryContext.isNotEmpty ||
                    (item.exchangeFromAmountLabel != null &&
                        item.exchangeToAmountLabel != null)) ...<Widget>[
                  const SizedBox(height: AppSpacing.xs + 2),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      if (item.secondaryContext.isNotEmpty)
                        Expanded(
                          child: _DirectionalText(
                            item.secondaryContext,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: Theme.of(context).textTheme.labelMedium
                                ?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ),
                      if (item.secondaryContext.isNotEmpty &&
                          item.exchangeFromAmountLabel != null &&
                          item.exchangeToAmountLabel != null)
                        const SizedBox(width: AppSpacing.sm),
                      if (item.exchangeFromAmountLabel != null &&
                          item.exchangeToAmountLabel != null)
                        Expanded(
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: colorScheme.primary.withValues(
                                alpha: 0.06,
                              ),
                              borderRadius: BorderRadius.circular(AppRadius.md),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: AppSpacing.xs + 2,
                                vertical: 5,
                              ),
                              child: Directionality(
                                textDirection: TextDirection.ltr,
                                child: Text(
                                  '${item.exchangeFromAmountLabel!} -> ${item.exchangeToAmountLabel!}',
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.start,
                                  style: Theme.of(context).textTheme.labelMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: colorScheme.primary,
                                      ),
                                ),
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusDateLine extends StatelessWidget {
  const _StatusDateLine({required this.item});

  final _ActivityItem item;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;
    return Wrap(
      alignment: WrapAlignment.end,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 6,
      runSpacing: 3,
      children: <Widget>[
        if (item.status != null) _StatusPill(status: item.status!),
        Directionality(
          textDirection: TextDirection.ltr,
          child: Text(
            '${item.dateContextLabel} ${item.timeOfDayLabel}',
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
            textAlign: TextAlign.end,
          ),
        ),
      ],
    );
  }
}

class _DirectionalText extends StatelessWidget {
  const _DirectionalText(
    this.text, {
    required this.style,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final TextStyle? style;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: _resolveTextDirection(text),
      child: Text(text, maxLines: maxLines, overflow: overflow, style: style),
    );
  }
}

class _StatusPill extends StatelessWidget {
  const _StatusPill({required this.status});

  final _ActivityStatus status;

  @override
  Widget build(BuildContext context) {
    final (_ColorPair colors, String label) = (
      _statusColors(status, Theme.of(context).colorScheme),
      _statusLabel(context, status),
    );
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.xs + 2,
        vertical: 3,
      ),
      decoration: BoxDecoration(
        color: colors.background,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelSmall?.copyWith(
          color: colors.foreground,
          fontWeight: FontWeight.w800,
        ),
      ),
    );
  }
}

class _TransactionsTimelineSkeleton extends StatelessWidget {
  const _TransactionsTimelineSkeleton();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List<Widget>.generate(
        5,
        (int index) => const Padding(
          padding: EdgeInsets.only(bottom: AppSpacing.xs + 2),
          child: TransactionSkeletonBlock(height: 96, radius: 20),
        ),
      ),
    );
  }
}

class _ActivityFilterSheetResult {
  const _ActivityFilterSheetResult({
    required this.sortOption,
    required this.dateRange,
    required this.currencyCode,
    required this.walletName,
    required this.contactName,
    required this.status,
  });

  final TransactionSortOption sortOption;
  final _DateRangeFilter dateRange;
  final String? currencyCode;
  final String? walletName;
  final String? contactName;
  final _ActivityStatus? status;
}

class _ActivityFilterSheet extends StatefulWidget {
  const _ActivityFilterSheet({
    required this.selectedSortOption,
    required this.selectedDateRange,
    required this.selectedCurrencyCode,
    required this.selectedWalletName,
    required this.selectedContactName,
    required this.selectedStatus,
    required this.options,
  });

  final TransactionSortOption selectedSortOption;
  final _DateRangeFilter selectedDateRange;
  final String? selectedCurrencyCode;
  final String? selectedWalletName;
  final String? selectedContactName;
  final _ActivityStatus? selectedStatus;
  final _ActivityFilterOptions options;

  @override
  State<_ActivityFilterSheet> createState() => _ActivityFilterSheetState();
}

class _ActivityFilterSheetState extends State<_ActivityFilterSheet> {
  late TransactionSortOption _sortOption;
  late _DateRangeFilter _dateRange;
  late String? _currencyCode;
  late String? _walletName;
  late String? _contactName;
  late _ActivityStatus? _status;

  @override
  void initState() {
    super.initState();
    _sortOption = widget.selectedSortOption;
    _dateRange = widget.selectedDateRange;
    _currencyCode = widget.selectedCurrencyCode;
    _walletName = widget.selectedWalletName;
    _contactName = widget.selectedContactName;
    _status = widget.selectedStatus;
  }

  @override
  Widget build(BuildContext context) {
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.88;
    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: DashboardSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                context.tr.transactionsFilterSheetTitle,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.md),
              _FilterSheetSection(
                title: context.tr.sort,
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: TransactionSortOption.values
                      .map(
                        (TransactionSortOption option) => _FilterChip(
                          label: _sortLabel(context, option),
                          selected: option == _sortOption,
                          onTap: () => setState(() => _sortOption = option),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              _FilterSheetSection(
                title: context.tr.transactionsDateRange,
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: _DateRangeFilter.values
                      .map(
                        (_DateRangeFilter value) => _FilterChip(
                          label: _dateRangeLabel(context, value),
                          selected: value == _dateRange,
                          onTap: () => setState(() => _dateRange = value),
                        ),
                      )
                      .toList(growable: false),
                ),
              ),
              _FilterSheetSection(
                title: context.tr.transactionsStatusLabel,
                child: Wrap(
                  spacing: AppSpacing.xs,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    _FilterChip(
                      label: context.tr.all,
                      selected: _status == null,
                      onTap: () => setState(() => _status = null),
                    ),
                    ...widget.options.statuses.map(
                      (_ActivityStatus value) => _FilterChip(
                        label: _statusLabel(context, value),
                        selected: value == _status,
                        onTap: () => setState(() => _status = value),
                      ),
                    ),
                  ],
                ),
              ),
              _FilterSheetSection(
                title: context.tr.currency,
                child: _ValueChipWrap(
                  values: widget.options.currencies,
                  selectedValue: _currencyCode,
                  allLabel: context.tr.all,
                  onSelected: (String? value) {
                    setState(() => _currencyCode = value);
                  },
                ),
              ),
              _FilterSheetSection(
                title: context.tr.wallet,
                child: _ValueChipWrap(
                  values: widget.options.wallets,
                  selectedValue: _walletName,
                  allLabel: context.tr.all,
                  onSelected: (String? value) {
                    setState(() => _walletName = value);
                  },
                ),
              ),
              _FilterSheetSection(
                title: context.tr.contacts,
                child: _ValueChipWrap(
                  values: widget.options.contacts,
                  selectedValue: _contactName,
                  allLabel: context.tr.all,
                  onSelected: (String? value) {
                    setState(() => _contactName = value);
                  },
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Row(
                children: <Widget>[
                  Expanded(
                    child: PwButton.secondary(
                      label: context.tr.clearSearch,
                      onPressed: () {
                        setState(() {
                          _sortOption = TransactionSortOption.newest;
                          _dateRange = _DateRangeFilter.all;
                          _currencyCode = null;
                          _walletName = null;
                          _contactName = null;
                          _status = null;
                        });
                      },
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: PwButton.primary(
                      label: context.tr.saveChanges,
                      onPressed: () => Navigator.of(context).pop(
                        _ActivityFilterSheetResult(
                          sortOption: _sortOption,
                          dateRange: _dateRange,
                          currencyCode: _currencyCode,
                          walletName: _walletName,
                          contactName: _contactName,
                          status: _status,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FilterSheetSection extends StatelessWidget {
  const _FilterSheetSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }
}

class _ValueChipWrap extends StatelessWidget {
  const _ValueChipWrap({
    required this.values,
    required this.selectedValue,
    required this.allLabel,
    required this.onSelected,
  });

  final List<String> values;
  final String? selectedValue;
  final String allLabel;
  final ValueChanged<String?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: <Widget>[
        _FilterChip(
          label: allLabel,
          selected: selectedValue == null,
          onTap: () => onSelected(null),
        ),
        ...values.map(
          (String value) => _FilterChip(
            label: value,
            selected: selectedValue == value,
            onTap: () => onSelected(value),
          ),
        ),
      ],
    );
  }
}

class _CreateActivitySheet extends StatelessWidget {
  const _CreateActivitySheet();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: DashboardSurfaceCard(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              context.tr.transactionsSelectAction,
              style: Theme.of(
                context,
              ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
            ),
            const SizedBox(height: AppSpacing.md),
            ...<({_CreateAction action, IconData icon, String label})>[
              (
                action: _CreateAction.deposit,
                icon: Icons.south_west_rounded,
                label: context.tr.deposit,
              ),
              (
                action: _CreateAction.withdraw,
                icon: Icons.north_east_rounded,
                label: context.tr.withdraw,
              ),
              (
                action: _CreateAction.transfer,
                icon: Icons.swap_horiz_rounded,
                label: context.tr.transfer,
              ),
              (
                action: _CreateAction.exchange,
                icon: Icons.currency_exchange_rounded,
                label: context.tr.transactionsCurrencyExchangeChip,
              ),
              (
                action: _CreateAction.debt,
                icon: Icons.receipt_long_rounded,
                label: context.tr.debt,
              ),
            ].map(
              (({_CreateAction action, IconData icon, String label}) option) =>
                  Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.xs),
                    child: ListTile(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                      leading: Icon(option.icon),
                      title: Text(option.label),
                      onTap: () => Navigator.of(context).pop(option.action),
                    ),
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ActivityDetailsSheet extends ConsumerStatefulWidget {
  const _ActivityDetailsSheet({required this.item});

  final _ActivityItem item;

  @override
  ConsumerState<_ActivityDetailsSheet> createState() =>
      _ActivityDetailsSheetState();
}

class _ActivityDetailsSheetState extends ConsumerState<_ActivityDetailsSheet> {
  @override
  void initState() {
    super.initState();
    final AttachmentReference? reference = widget.item.attachmentReference;
    if (reference != null) {
      Future<void>.microtask(
        () => ref
            .read(attachmentControllerProvider.notifier)
            .loadReference(reference),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final AttachmentState attachmentState = ref.watch(
      attachmentControllerProvider,
    );
    final AttachmentReference? reference = widget.item.attachmentReference;
    final bool referenceMatches =
        reference != null &&
        attachmentState.activeReference?.type == reference.type &&
        attachmentState.activeReference?.entityId == reference.entityId;
    final List<Attachment> attachments = referenceMatches
        ? attachmentState.attachments
        : const <Attachment>[];
    final double maxHeight = MediaQuery.sizeOf(context).height * 0.88;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md,
          AppSpacing.md + MediaQuery.viewInsetsOf(context).bottom,
        ),
        child: DashboardSurfaceCard(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: widget.item.amountColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    alignment: Alignment.center,
                    child: Icon(
                      widget.item.icon,
                      color: widget.item.amountColor,
                    ),
                  ),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.item.title,
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w800),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.item.amountLabel,
                          style: Theme.of(context).textTheme.titleSmall
                              ?.copyWith(
                                color: widget.item.amountColor,
                                fontWeight: FontWeight.w800,
                              ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              ...widget.item.detailRows.map(
                (_ActivityDetailRowData row) => _ActivityDetailsRow(row: row),
              ),
              if (widget.item.notePreview != null) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(
                  context.tr.detailNotes,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(widget.item.notePreview!),
              ],
              if (reference != null) ...<Widget>[
                const SizedBox(height: AppSpacing.md),
                Text(
                  context.tr.attachments,
                  style: Theme.of(
                    context,
                  ).textTheme.labelLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: AppSpacing.xs),
                if (attachmentState.isLoading && !referenceMatches)
                  const TransactionSkeletonBlock(height: 72, radius: 18)
                else if (attachments.isEmpty)
                  Text(
                    context.tr.noAttachments,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  )
                else
                  _AttachmentPreviewStrip(
                    attachments: attachments,
                    viewerLabel: widget.item.attachmentViewerLabel,
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _ActivityDetailsRow extends StatelessWidget {
  const _ActivityDetailsRow({required this.row});

  final _ActivityDetailRowData row;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 108,
            child: Text(
              row.label,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
          ),
          Expanded(
            child: Text(
              row.value,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }
}

class _AttachmentPreviewStrip extends StatelessWidget {
  const _AttachmentPreviewStrip({
    required this.attachments,
    required this.viewerLabel,
  });

  final List<Attachment> attachments;
  final String? viewerLabel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: attachments
              .take(3)
              .map((_attachmentPreviewCard))
              .toList(growable: false),
        ),
        if (viewerLabel != null) ...<Widget>[
          const SizedBox(height: AppSpacing.sm),
          TextButton(
            onPressed: () => context.push(viewerLabel!),
            child: Text(context.tr.openAttachmentViewer),
          ),
        ],
      ],
    );
  }

  Widget _attachmentPreviewCard(Attachment attachment) {
    return Builder(
      builder: (BuildContext context) {
        final File file = File(attachment.localUri);
        final bool isImage =
            attachment.kind.name == 'image' && file.existsSync();
        return Container(
          width: 120,
          padding: const EdgeInsets.all(AppSpacing.sm),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(AppRadius.md),
            border: Border.all(color: AppColors.outlineSoft),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (isImage)
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: Image.file(
                    file,
                    height: 68,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                )
              else
                Container(
                  height: 68,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignment: Alignment.center,
                  child: const Icon(Icons.attach_file_rounded),
                ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                attachment.fileName,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: Theme.of(
                  context,
                ).textTheme.labelMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ActivitySummary {
  const _ActivitySummary({
    required this.todayCount,
    required this.monthCount,
    required this.totalCount,
  });

  factory _ActivitySummary.fromItems(List<_ActivityItem> items) {
    final DateTime now = DateTime.now();
    int todayCount = 0;
    int monthCount = 0;
    for (final _ActivityItem item in items) {
      if (_isSameDay(item.createdAt, now)) {
        todayCount += 1;
      }
      if (item.createdAt.year == now.year &&
          item.createdAt.month == now.month) {
        monthCount += 1;
      }
    }
    return _ActivitySummary(
      todayCount: todayCount,
      monthCount: monthCount,
      totalCount: items.length,
    );
  }

  final int todayCount;
  final int monthCount;
  final int totalCount;
}

class _ActivitySection {
  const _ActivitySection({required this.label, required this.items});

  final String label;
  final List<_ActivityItem> items;
}

class _ActivityDetailRowData {
  const _ActivityDetailRowData({required this.label, required this.value});

  final String label;
  final String value;
}

class _ActivityFilterOptions {
  const _ActivityFilterOptions({
    required this.currencies,
    required this.wallets,
    required this.contacts,
    required this.statuses,
  });

  final List<String> currencies;
  final List<String> wallets;
  final List<String> contacts;
  final List<_ActivityStatus> statuses;
}

class _ColorPair {
  const _ColorPair({required this.background, required this.foreground});

  final Color background;
  final Color foreground;
}

class _ActivityItem {
  const _ActivityItem({
    required this.id,
    required this.category,
    required this.title,
    required this.primaryContext,
    required this.secondaryContext,
    required this.dateContextLabel,
    required this.timeOfDayLabel,
    required this.amountLabel,
    required this.amountValue,
    required this.amountColor,
    required this.createdAt,
    required this.icon,
    required this.searchTokens,
    required this.detailRows,
    required this.walletNames,
    required this.currencyCodes,
    required this.referenceLabel,
    this.notePreview,
    this.contactName,
    this.status,
    this.exchangeFromAmountLabel,
    this.exchangeToAmountLabel,
    this.attachmentReference,
    this.attachmentViewerLabel,
  });

  final String id;
  final _ActivityCategory category;
  final String title;
  final String primaryContext;
  final String secondaryContext;
  final String dateContextLabel;
  final String timeOfDayLabel;
  final String amountLabel;
  final num amountValue;
  final Color amountColor;
  final DateTime createdAt;
  final IconData icon;
  final List<String> searchTokens;
  final List<_ActivityDetailRowData> detailRows;
  final List<String> walletNames;
  final List<String> currencyCodes;
  final String? referenceLabel;
  final String? notePreview;
  final String? contactName;
  final _ActivityStatus? status;
  final String? exchangeFromAmountLabel;
  final String? exchangeToAmountLabel;
  final AttachmentReference? attachmentReference;
  final String? attachmentViewerLabel;
}

List<_ActivityItem> _buildActivityFeed(
  BuildContext context, {
  required List<LedgerTransaction> transactions,
  required List<TransferSummary> transfers,
  required List<DebtSummary> debts,
  required Map<String, WalletOverview> walletLookup,
  required Set<String> hiddenLedgerIds,
}) {
  final List<_ActivityItem> items = <_ActivityItem>[
    ...transactions
        .where(
          (LedgerTransaction transaction) =>
              !hiddenLedgerIds.contains(transaction.id) &&
              transaction.recipientUserId == null &&
              transaction.transferRecordId == null &&
              transaction.debtSettlementId == null,
        )
        .map(
          (LedgerTransaction transaction) =>
              _ledgerToActivity(context, transaction, walletLookup),
        ),
    ...transfers.map(
      (TransferSummary transfer) =>
          _transferToActivity(context, transfer, walletLookup),
    ),
    ...debts.expand(
      (DebtSummary summary) => <_ActivityItem>[
        _debtToActivity(context, summary),
        ...summary.repayments.map(
          (DebtRepayment repayment) =>
              _repaymentToActivity(context, summary, repayment),
        ),
      ],
    ),
  ];

  items.sort(
    (_ActivityItem left, _ActivityItem right) =>
        right.createdAt.compareTo(left.createdAt),
  );
  return items;
}

_ActivityItem _ledgerToActivity(
  BuildContext context,
  LedgerTransaction transaction,
  Map<String, WalletOverview> walletLookup,
) {
  final String sourceWallet = _walletName(
    context,
    walletLookup,
    transaction.sourceWalletId,
  );
  final String destinationWallet = _walletName(
    context,
    walletLookup,
    transaction.destinationWalletId,
  );
  final String amount = AmountFormatter.format(transaction.sourceAmount);
  final _ActivityTimeData timeData = _timeData(context, transaction.createdAt);
  final Color amountColor;
  final IconData icon;
  final String amountLabel;
  final _ActivityCategory category;
  final String title;
  final String primaryContext;
  final String secondaryContext;
  final _ActivityStatus status = _ActivityStatus.completed;
  String? exchangeFromAmountLabel;
  String? exchangeToAmountLabel;

  switch (transaction.type) {
    case TransactionType.deposit:
      amountColor = AppColors.success;
      icon = Icons.south_west_rounded;
      amountLabel = '+$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      category = _ActivityCategory.deposit;
      title = context.tr.deposit;
      primaryContext = context.tr.toWallet(destinationWallet);
      secondaryContext = transaction.reference.value;
      break;
    case TransactionType.withdraw:
      amountColor = AppColors.warning;
      icon = Icons.north_east_rounded;
      amountLabel = '-$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      category = _ActivityCategory.withdraw;
      title = context.tr.withdraw;
      primaryContext = context.tr.fromWallet(sourceWallet);
      secondaryContext = transaction.reference.value;
      break;
    case TransactionType.transfer:
      amountColor = AppColors.brand;
      icon = Icons.swap_horiz_rounded;
      amountLabel = '$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      category = _ActivityCategory.transfer;
      title = context.tr.internalTransfer;
      primaryContext = context.tr.fromWallet(sourceWallet);
      secondaryContext = context.tr.toWallet(destinationWallet);
      break;
    case TransactionType.exchange:
      amountColor = AppColors.brand;
      icon = Icons.currency_exchange_rounded;
      amountLabel = '$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      category = _ActivityCategory.exchange;
      title = context.tr.transactionsCurrencyExchangeChip;
      primaryContext = context.tr.exchangeInWallet(sourceWallet);
      secondaryContext = transaction.destinationAmount == null
          ? transaction.reference.value
          : '${AmountFormatter.format(transaction.destinationAmount!)} ${transaction.destinationCurrency?.name.toUpperCase() ?? ''}'
                .trim();
      exchangeFromAmountLabel =
          '$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      exchangeToAmountLabel = transaction.destinationAmount == null
          ? null
          : '${AmountFormatter.format(transaction.destinationAmount!)} ${transaction.destinationCurrency?.name.toUpperCase() ?? ''}'
                .trim();
      break;
    case TransactionType.reversal:
      amountColor = AppColors.brand;
      icon = Icons.undo_rounded;
      amountLabel = '$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      category = _ActivityCategory.all;
      title = context.tr.reversalActivity;
      primaryContext = transaction.reference.value;
      secondaryContext = sourceWallet;
      break;
    case TransactionType.correction:
      amountColor = AppColors.brand;
      icon = Icons.rule_folder_outlined;
      amountLabel = '$amount ${transaction.sourceCurrency.name.toUpperCase()}';
      category = _ActivityCategory.all;
      title = context.tr.correctionActivity;
      primaryContext = transaction.reference.value;
      secondaryContext = sourceWallet;
      break;
  }

  return _ActivityItem(
    id: 'ledger_${transaction.id}',
    category: category,
    title: title,
    primaryContext: primaryContext,
    secondaryContext: secondaryContext,
    dateContextLabel: timeData.dateLabel,
    timeOfDayLabel: timeData.timeLabel,
    amountLabel: amountLabel,
    amountValue: num.tryParse(transaction.sourceAmount) ?? 0,
    amountColor: amountColor,
    createdAt: transaction.createdAt,
    icon: icon,
    status: status,
    referenceLabel: transaction.reference.value,
    notePreview: _trimmedText(transaction.note),
    walletNames: <String>[
      if (sourceWallet.isNotEmpty) sourceWallet,
      if (destinationWallet.isNotEmpty) destinationWallet,
    ],
    currencyCodes: <String>[
      transaction.sourceCurrency.name.toUpperCase(),
      if (transaction.destinationCurrency != null)
        transaction.destinationCurrency!.name.toUpperCase(),
    ],
    exchangeFromAmountLabel: exchangeFromAmountLabel,
    exchangeToAmountLabel: exchangeToAmountLabel,
    attachmentReference: AttachmentReference(
      type: AttachmentReferenceType.transaction,
      entityId: transaction.id,
      label: transaction.reference.value,
    ),
    attachmentViewerLabel:
        '${AppRoutes.attachmentViewerPath}?entityType=transaction&entityId=${Uri.encodeComponent(transaction.id)}&label=${Uri.encodeComponent(transaction.reference.value)}',
    searchTokens: <String>[
      transaction.reference.value,
      sourceWallet,
      destinationWallet,
      transaction.note ?? '',
      title,
      primaryContext,
      secondaryContext,
    ],
    detailRows: <_ActivityDetailRowData>[
      _ActivityDetailRowData(label: context.tr.detailType, value: title),
      _ActivityDetailRowData(
        label: context.tr.detailDate,
        value: DateFormatter.full(transaction.createdAt),
      ),
      _ActivityDetailRowData(label: context.tr.amount, value: amountLabel),
      _ActivityDetailRowData(
        label: context.tr.transactionsReferenceLabel,
        value: transaction.reference.value,
      ),
      if (transaction.type == TransactionType.transfer)
        _ActivityDetailRowData(
          label: context.tr.transactionsFromLabel,
          value: sourceWallet,
        ),
      if (transaction.type == TransactionType.transfer)
        _ActivityDetailRowData(
          label: context.tr.transactionsToLabel,
          value: destinationWallet,
        ),
      if (transaction.type == TransactionType.deposit)
        _ActivityDetailRowData(
          label: context.tr.wallet,
          value: destinationWallet,
        ),
      if (transaction.type == TransactionType.withdraw)
        _ActivityDetailRowData(label: context.tr.wallet, value: sourceWallet),
      if (transaction.type == TransactionType.exchange &&
          transaction.destinationAmount != null &&
          transaction.destinationCurrency != null)
        _ActivityDetailRowData(
          label: context.tr.detailReceived,
          value:
              '${AmountFormatter.format(transaction.destinationAmount!)} ${transaction.destinationCurrency!.name.toUpperCase()}',
        ),
      if ((transaction.exchangeRate ?? '').isNotEmpty)
        _ActivityDetailRowData(
          label: context.tr.exchangeRate,
          value: transaction.exchangeRate!,
        ),
      _ActivityDetailRowData(
        label: context.tr.transactionsStatusLabel,
        value: _statusLabel(context, status),
      ),
    ],
  );
}

_ActivityItem _transferToActivity(
  BuildContext context,
  TransferSummary transfer,
  Map<String, WalletOverview> walletLookup,
) {
  final String sourceWallet = _walletName(
    context,
    walletLookup,
    transfer.transfer.senderWalletId,
  );
  final String destinationWallet = _walletName(
    context,
    walletLookup,
    transfer.transfer.recipientWalletId,
  );
  final bool isIncoming = transfer.isIncoming;
  final bool isSettlement = transfer.isDebtSettlement;
  final String amount = AmountFormatter.format(transfer.transfer.amount);
  final _ActivityTimeData timeData = _timeData(
    context,
    transfer.transfer.createdAt,
  );
  final String amountLabel =
      '${isIncoming ? '+' : '-'}$amount ${transfer.transfer.currency.name.toUpperCase()}';
  final String title = isSettlement
      ? context.tr.transactionsDebtRepaymentChip
      : context.tr.transfer;

  return _ActivityItem(
    id: 'transfer_${transfer.transfer.id}',
    category: isSettlement
        ? _ActivityCategory.debtRepayment
        : _ActivityCategory.transfer,
    title: title,
    primaryContext: isIncoming
        ? context.tr.transactionsFromLabelValue(
            transfer.counterpartyDisplayName,
          )
        : context.tr.transactionsToLabelValue(transfer.counterpartyDisplayName),
    secondaryContext: isIncoming
        ? context.tr.toWallet(destinationWallet)
        : context.tr.fromWallet(sourceWallet),
    dateContextLabel: timeData.dateLabel,
    timeOfDayLabel: timeData.timeLabel,
    amountLabel: amountLabel,
    amountValue: num.tryParse(transfer.transfer.amount) ?? 0,
    amountColor: isIncoming ? AppColors.success : AppColors.warning,
    createdAt: transfer.transfer.createdAt,
    icon: isSettlement
        ? Icons.payments_rounded
        : Icons.swap_horizontal_circle_rounded,
    status: _ActivityStatus.completed,
    referenceLabel: transfer.transfer.reference.value,
    notePreview: _trimmedText(transfer.transfer.note),
    contactName: transfer.counterpartyDisplayName,
    walletNames: <String>[sourceWallet, destinationWallet],
    currencyCodes: <String>[transfer.transfer.currency.name.toUpperCase()],
    attachmentReference: AttachmentReference(
      type: AttachmentReferenceType.transaction,
      entityId: transfer.transfer.ledgerTransactionId,
      label: transfer.transfer.reference.value,
    ),
    attachmentViewerLabel:
        '${AppRoutes.attachmentViewerPath}?entityType=transaction&entityId=${Uri.encodeComponent(transfer.transfer.ledgerTransactionId)}&label=${Uri.encodeComponent(transfer.transfer.reference.value)}',
    searchTokens: <String>[
      transfer.transfer.reference.value,
      transfer.counterpartyDisplayName,
      transfer.transfer.note ?? '',
      sourceWallet,
      destinationWallet,
      title,
    ],
    detailRows: <_ActivityDetailRowData>[
      _ActivityDetailRowData(label: context.tr.detailType, value: title),
      _ActivityDetailRowData(
        label: context.tr.detailDate,
        value: DateFormatter.full(transfer.transfer.createdAt),
      ),
      _ActivityDetailRowData(label: context.tr.amount, value: amountLabel),
      _ActivityDetailRowData(
        label: context.tr.transactionsReferenceLabel,
        value: transfer.transfer.reference.value,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsFromLabel,
        value: transfer.transfer.senderDisplayName,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsToLabel,
        value: transfer.transfer.recipientDisplayName,
      ),
      _ActivityDetailRowData(
        label: context.tr.sourceWallet,
        value: sourceWallet,
      ),
      _ActivityDetailRowData(
        label: context.tr.destinationWallet,
        value: destinationWallet,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsStatusLabel,
        value: _statusLabel(context, _ActivityStatus.completed),
      ),
    ],
  );
}

_ActivityItem _debtToActivity(BuildContext context, DebtSummary summary) {
  final String amount =
      '${AmountFormatter.format(summary.debt.originalAmount)} ${summary.currency.name.toUpperCase()}';
  final _ActivityTimeData timeData = _timeData(context, summary.debt.createdAt);
  final _ActivityStatus status = summary.isCompleted
      ? _ActivityStatus.completed
      : _ActivityStatus.pending;
  return _ActivityItem(
    id: 'debt_${summary.debt.id}',
    category: _ActivityCategory.debt,
    title: context.tr.debt,
    primaryContext: summary.contact.name,
    secondaryContext: summary.debt.isOwedToMe
        ? context.tr.debtDirectionOwedToMeShort
        : context.tr.debtDirectionIOweShort,
    dateContextLabel: timeData.dateLabel,
    timeOfDayLabel: timeData.timeLabel,
    amountLabel: '-$amount',
    amountValue: num.tryParse(summary.debt.originalAmount) ?? 0,
    amountColor: AppColors.warning,
    createdAt: summary.debt.createdAt,
    icon: Icons.receipt_long_rounded,
    notePreview: _trimmedText(summary.debt.note),
    status: status,
    contactName: summary.contact.name,
    walletNames: const <String>[],
    currencyCodes: <String>[summary.currency.name.toUpperCase()],
    referenceLabel: summary.debt.id,
    attachmentReference: AttachmentReference(
      type: AttachmentReferenceType.debt,
      entityId: summary.debt.id,
      label: summary.contact.name,
    ),
    attachmentViewerLabel:
        '${AppRoutes.attachmentViewerPath}?entityType=debt&entityId=${Uri.encodeComponent(summary.debt.id)}&label=${Uri.encodeComponent(summary.contact.name)}',
    searchTokens: <String>[
      summary.contact.name,
      summary.debt.note ?? '',
      context.tr.debt,
      summary.debt.id,
    ],
    detailRows: <_ActivityDetailRowData>[
      _ActivityDetailRowData(
        label: context.tr.detailType,
        value: context.tr.debt,
      ),
      _ActivityDetailRowData(
        label: context.tr.detailDate,
        value: DateFormatter.full(summary.debt.createdAt),
      ),
      _ActivityDetailRowData(label: context.tr.amount, value: '-$amount'),
      _ActivityDetailRowData(
        label: context.tr.transactionsReferenceLabel,
        value: summary.debt.id,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsDetailContact,
        value: summary.contact.name,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsStatusLabel,
        value: _statusLabel(context, status),
      ),
    ],
  );
}

_ActivityItem _repaymentToActivity(
  BuildContext context,
  DebtSummary summary,
  DebtRepayment repayment,
) {
  final bool isIncoming = summary.debt.isOwedToMe;
  final String amount =
      '${AmountFormatter.format(repayment.amount)} ${summary.currency.name.toUpperCase()}';
  final _ActivityTimeData timeData = _timeData(context, repayment.createdAt);
  return _ActivityItem(
    id: 'repayment_${repayment.id}',
    category: _ActivityCategory.debtRepayment,
    title: context.tr.transactionsDebtRepaymentChip,
    primaryContext: summary.contact.name,
    secondaryContext: summary.debt.isOwedToMe
        ? context.tr.owedToMe
        : context.tr.iOwe,
    dateContextLabel: timeData.dateLabel,
    timeOfDayLabel: timeData.timeLabel,
    amountLabel: '${isIncoming ? '+' : '-'}$amount',
    amountValue: num.tryParse(repayment.amount) ?? 0,
    amountColor: isIncoming ? AppColors.success : AppColors.warning,
    createdAt: repayment.createdAt,
    icon: Icons.payments_rounded,
    notePreview: _trimmedText(repayment.note),
    status: _ActivityStatus.completed,
    contactName: summary.contact.name,
    walletNames: const <String>[],
    currencyCodes: <String>[summary.currency.name.toUpperCase()],
    referenceLabel: repayment.id,
    attachmentReference: AttachmentReference(
      type: AttachmentReferenceType.debt,
      entityId: summary.debt.id,
      label: summary.contact.name,
    ),
    attachmentViewerLabel:
        '${AppRoutes.attachmentViewerPath}?entityType=debt&entityId=${Uri.encodeComponent(summary.debt.id)}&label=${Uri.encodeComponent(summary.contact.name)}',
    searchTokens: <String>[
      summary.contact.name,
      repayment.note ?? '',
      context.tr.transactionsDebtRepaymentChip,
      summary.debt.id,
    ],
    detailRows: <_ActivityDetailRowData>[
      _ActivityDetailRowData(
        label: context.tr.detailType,
        value: context.tr.transactionsDebtRepaymentChip,
      ),
      _ActivityDetailRowData(
        label: context.tr.detailDate,
        value: DateFormatter.full(repayment.createdAt),
      ),
      _ActivityDetailRowData(
        label: context.tr.amount,
        value: '${isIncoming ? '+' : '-'}$amount',
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsDetailContact,
        value: summary.contact.name,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsReferenceLabel,
        value: repayment.id,
      ),
      _ActivityDetailRowData(
        label: context.tr.transactionsStatusLabel,
        value: _statusLabel(context, _ActivityStatus.completed),
      ),
    ],
  );
}

List<_ActivityItem> _applySearch(List<_ActivityItem> items, String query) {
  final String normalizedQuery = _normalizeSearchValue(query);
  if (normalizedQuery.isEmpty) {
    return items;
  }
  return items
      .where((_ActivityItem item) {
        return item.searchTokens.any(
          (String token) =>
              _normalizeSearchValue(token).contains(normalizedQuery),
        );
      })
      .toList(growable: false);
}

List<_ActivityItem> _applyCategory(
  List<_ActivityItem> items,
  _ActivityCategory category,
) {
  if (category == _ActivityCategory.all) {
    return items;
  }
  return items
      .where((_ActivityItem item) => item.category == category)
      .toList(growable: false);
}

List<_ActivityItem> _applyAdvancedFilters(
  List<_ActivityItem> items, {
  required String? currencyCode,
  required String? walletName,
  required String? contactName,
  required _ActivityStatus? status,
}) {
  return items
      .where((_ActivityItem item) {
        final bool matchesCurrency =
            currencyCode == null || item.currencyCodes.contains(currencyCode);
        final bool matchesWallet =
            walletName == null || item.walletNames.contains(walletName);
        final bool matchesContact =
            contactName == null || item.contactName == contactName;
        final bool matchesStatus = status == null || item.status == status;
        return matchesCurrency &&
            matchesWallet &&
            matchesContact &&
            matchesStatus;
      })
      .toList(growable: false);
}

List<_ActivityItem> _applyDateRange(
  List<_ActivityItem> items,
  _DateRangeFilter dateRange,
) {
  if (dateRange == _DateRangeFilter.all) {
    return items;
  }
  final DateTime now = DateTime.now();
  return items
      .where((_ActivityItem item) {
        final DateTime value = item.createdAt.toLocal();
        return switch (dateRange) {
          _DateRangeFilter.all => true,
          _DateRangeFilter.today => _isSameDay(value, now),
          _DateRangeFilter.thisWeek => value.isAfter(
            now.subtract(const Duration(days: 7)),
          ),
          _DateRangeFilter.thisMonth =>
            value.year == now.year && value.month == now.month,
          _DateRangeFilter.last30Days => value.isAfter(
            now.subtract(const Duration(days: 30)),
          ),
        };
      })
      .toList(growable: false);
}

List<_ActivityItem> _sortItems(
  List<_ActivityItem> items,
  TransactionSortOption sortOption,
) {
  final List<_ActivityItem> sorted = List<_ActivityItem>.from(items);
  sorted.sort((_ActivityItem left, _ActivityItem right) {
    switch (sortOption) {
      case TransactionSortOption.newest:
        return right.createdAt.compareTo(left.createdAt);
      case TransactionSortOption.oldest:
        return left.createdAt.compareTo(right.createdAt);
      case TransactionSortOption.highestAmount:
        return right.amountValue.compareTo(left.amountValue);
      case TransactionSortOption.lowestAmount:
        return left.amountValue.compareTo(right.amountValue);
    }
  });
  return sorted;
}

_ActivityFilterOptions _buildFilterOptions(List<_ActivityItem> items) {
  final Set<String> currencies = <String>{};
  final Set<String> wallets = <String>{};
  final Set<String> contacts = <String>{};
  final Set<_ActivityStatus> statuses = <_ActivityStatus>{};
  for (final _ActivityItem item in items) {
    currencies.addAll(item.currencyCodes);
    wallets.addAll(
      item.walletNames.where((String name) => name.trim().isNotEmpty),
    );
    if ((item.contactName ?? '').trim().isNotEmpty) {
      contacts.add(item.contactName!.trim());
    }
    if (item.status != null) {
      statuses.add(item.status!);
    }
  }

  List<String> sortedStrings(Set<String> values) =>
      values.toList()..sort((String a, String b) => a.compareTo(b));

  return _ActivityFilterOptions(
    currencies: sortedStrings(currencies),
    wallets: sortedStrings(wallets),
    contacts: sortedStrings(contacts),
    statuses: statuses.toList()
      ..sort(
        (_ActivityStatus a, _ActivityStatus b) => a.index.compareTo(b.index),
      ),
  );
}

List<_ActivitySection> _groupActivitiesByDate(
  BuildContext context,
  List<_ActivityItem> items,
) {
  final Map<String, List<_ActivityItem>> grouped =
      <String, List<_ActivityItem>>{};
  for (final _ActivityItem item in items) {
    final String label = _groupLabel(context, item.createdAt);
    grouped.putIfAbsent(label, () => <_ActivityItem>[]).add(item);
  }

  return grouped.entries
      .map(
        (MapEntry<String, List<_ActivityItem>> entry) =>
            _ActivitySection(label: entry.key, items: entry.value),
      )
      .toList(growable: false);
}

String _groupLabel(BuildContext context, DateTime date) {
  final DateTime localDate = date.toLocal();
  final DateTime now = DateTime.now();
  if (_isSameDay(localDate, now)) {
    return context.tr.transactionsTodayGroup;
  }
  if (_isSameDay(localDate, now.subtract(const Duration(days: 1)))) {
    return context.tr.transactionsYesterdayGroup;
  }
  if (localDate.isAfter(now.subtract(const Duration(days: 7)))) {
    return context.tr.transactionsThisWeekGroup;
  }
  if (localDate.year == now.year && localDate.month == now.month) {
    return context.tr.transactionsThisMonthGroup;
  }

  return DateFormat.yMMMMd(
    Localizations.localeOf(context).toString(),
  ).format(localDate);
}

class _ActivityTimeData {
  const _ActivityTimeData({required this.dateLabel, required this.timeLabel});

  final String dateLabel;
  final String timeLabel;
}

_ActivityTimeData _timeData(BuildContext context, DateTime value) {
  final DateTime local = value.toLocal();
  final DateTime now = DateTime.now();
  final String locale = Localizations.localeOf(context).toString();
  final String formattedTime = DateFormat.jm(locale).format(local);
  if (_isSameDay(local, now)) {
    return _ActivityTimeData(
      dateLabel: context.tr.transactionsTodayGroup,
      timeLabel: formattedTime,
    );
  }
  if (_isSameDay(local, now.subtract(const Duration(days: 1)))) {
    return _ActivityTimeData(
      dateLabel: context.tr.transactionsYesterdayGroup,
      timeLabel: formattedTime,
    );
  }
  final String dateLabel = local.year == now.year
      ? DateFormat.MMMd(locale).format(local)
      : DateFormat.yMMMd(locale).format(local);
  return _ActivityTimeData(dateLabel: dateLabel, timeLabel: formattedTime);
}

String _walletName(
  BuildContext context,
  Map<String, WalletOverview> walletLookup,
  String? walletId,
) {
  return walletLookup[walletId]?.wallet.name ?? context.tr.unknownWallet;
}

String? _trimmedText(String? value) {
  final String? normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return null;
  }
  return normalized;
}

String _normalizeSearchValue(String value) {
  return value.trim().toLowerCase().replaceAll(RegExp(r'\s+'), '');
}

bool _isSameDay(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}

String _categoryLabel(BuildContext context, _ActivityCategory category) {
  return switch (category) {
    _ActivityCategory.all => context.tr.all,
    _ActivityCategory.deposit => context.tr.deposit,
    _ActivityCategory.withdraw => context.tr.withdraw,
    _ActivityCategory.transfer => context.tr.transfer,
    _ActivityCategory.debt => context.tr.debt,
    _ActivityCategory.debtRepayment => context.tr.transactionsDebtRepaymentChip,
    _ActivityCategory.exchange => context.tr.transactionsCurrencyExchangeChip,
  };
}

String _dateRangeLabel(BuildContext context, _DateRangeFilter value) {
  return switch (value) {
    _DateRangeFilter.all => context.tr.transactionsDateRangeAll,
    _DateRangeFilter.today => context.tr.transactionsDateRangeToday,
    _DateRangeFilter.thisWeek => context.tr.transactionsDateRangeThisWeek,
    _DateRangeFilter.thisMonth => context.tr.transactionsDateRangeThisMonth,
    _DateRangeFilter.last30Days => context.tr.transactionsDateRangeLast30Days,
  };
}

String _sortLabel(BuildContext context, TransactionSortOption option) {
  return switch (option) {
    TransactionSortOption.newest => context.tr.newest,
    TransactionSortOption.oldest => context.tr.oldest,
    TransactionSortOption.highestAmount => context.tr.highestAmount,
    TransactionSortOption.lowestAmount => context.tr.lowestAmount,
  };
}

String _statusLabel(BuildContext context, _ActivityStatus status) {
  return switch (status) {
    _ActivityStatus.completed => context.tr.transactionsStatusCompleted,
    _ActivityStatus.pending => context.tr.transactionsStatusPending,
    _ActivityStatus.failed => context.tr.transactionsStatusFailed,
    _ActivityStatus.cancelled => context.tr.transactionsStatusCancelled,
  };
}

_ColorPair _statusColors(_ActivityStatus status, ColorScheme colorScheme) {
  return switch (status) {
    _ActivityStatus.completed => _ColorPair(
      background: AppColors.success.withValues(alpha: 0.12),
      foreground: AppColors.success,
    ),
    _ActivityStatus.pending => _ColorPair(
      background: AppColors.warning.withValues(alpha: 0.14),
      foreground: AppColors.warning,
    ),
    _ActivityStatus.failed => _ColorPair(
      background: colorScheme.error.withValues(alpha: 0.12),
      foreground: colorScheme.error,
    ),
    _ActivityStatus.cancelled => _ColorPair(
      background: colorScheme.onSurface.withValues(alpha: 0.08),
      foreground: colorScheme.onSurfaceVariant,
    ),
  };
}

TextDirection _resolveTextDirection(String value) {
  final String trimmed = value.trim();
  if (trimmed.isEmpty) {
    return TextDirection.rtl;
  }

  final RegExp arabicPattern = RegExp(r'[\u0600-\u06FF]');
  final RegExp latinPattern = RegExp(r'[A-Za-z0-9]');
  final bool hasArabic = arabicPattern.hasMatch(trimmed);
  final bool hasLatin = latinPattern.hasMatch(trimmed);

  if (hasArabic && !hasLatin) {
    return TextDirection.rtl;
  }
  if (hasLatin && !hasArabic) {
    return TextDirection.ltr;
  }
  return TextDirection.rtl;
}
