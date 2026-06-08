import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../dashboard/presentation/widgets/dashboard_breakpoints.dart';
import '../../../dashboard/presentation/widgets/dashboard_copy.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_skeleton_block.dart';
import '../../domain/enums/wallet_sort_option.dart';
import '../../domain/models/wallet_overview.dart';
import '../providers/wallet_providers.dart';
import '../widgets/wallet_overview_card.dart';

class WalletsPage extends ConsumerStatefulWidget {
  const WalletsPage({super.key});

  @override
  ConsumerState<WalletsPage> createState() => _WalletsPageState();
}

class _WalletsPageState extends ConsumerState<WalletsPage>
    with WidgetsBindingObserver {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  late final VoidCallback _searchListener;
  double _lastBottomInset = 0;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchListener = () {
      ref
          .read(walletControllerProvider.notifier)
          .setSearchQuery(_searchController.text);
    };
    _searchController.addListener(_searchListener);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _searchController.removeListener(_searchListener);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  @override
  void didChangeMetrics() {
    super.didChangeMetrics();
    final FlutterView view = View.of(context);
    final double currentBottomInset =
        view.viewInsets.bottom / view.devicePixelRatio;

    if (_lastBottomInset > 0 &&
        currentBottomInset == 0 &&
        _searchFocusNode.hasFocus) {
      _searchFocusNode.unfocus();
    }

    _lastBottomInset = currentBottomInset;
  }

  @override
  Widget build(BuildContext context) {
    final DashboardCopy copy = DashboardCopy.of(context);
    final walletState = ref.watch(walletControllerProvider);
    final List<WalletOverview> visibleWallets = walletState.visibleWallets;
    final bool isInitialLoading =
        walletState.isLoading && walletState.wallets.isEmpty;
    final bool hasSearchQuery = walletState.searchQuery.trim().isNotEmpty;
    final _WalletSummary summary = _WalletSummary.fromWallets(
      walletState.wallets,
    );

    if (_searchController.text != walletState.searchQuery) {
      _searchController.value = TextEditingValue(
        text: walletState.searchQuery,
        selection: TextSelection.collapsed(
          offset: walletState.searchQuery.length,
        ),
      );
    }

    return Directionality(
      textDirection: copy.textDirection,
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(copy.wallets),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.md),
                child: _CreateWalletAction(
                  tooltip: copy.createWallet,
                  onPressed: () => context.push(AppRoutes.walletCreatePath),
                ),
              ),
            ],
          ),
          body: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final DashboardBreakpoint breakpoint = resolveDashboardBreakpoint(
                constraints.maxWidth,
              );
              final double horizontalPadding = switch (breakpoint) {
                DashboardBreakpoint.smallPhone => AppSpacing.lg,
                DashboardBreakpoint.phone => AppSpacing.xl,
                DashboardBreakpoint.tablet => AppSpacing.xxl,
                DashboardBreakpoint.largeTablet => 40,
              };
              final int columns = switch (breakpoint) {
                DashboardBreakpoint.smallPhone => 1,
                DashboardBreakpoint.phone => 1,
                DashboardBreakpoint.tablet => 2,
                DashboardBreakpoint.largeTablet => 3,
              };

              return SafeArea(
                top: false,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 1120),
                    child: ListView(
                      keyboardDismissBehavior:
                          ScrollViewKeyboardDismissBehavior.onDrag,
                      padding: EdgeInsets.fromLTRB(
                        horizontalPadding,
                        AppSpacing.md,
                        horizontalPadding,
                        AppSpacing.xxl,
                      ),
                      children: <Widget>[
                        if (isInitialLoading)
                          const _WalletSummarySkeleton()
                        else
                          _WalletSummaryCard(summary: summary),
                        const SizedBox(height: AppSpacing.md),
                        _WalletSearchBar(
                          controller: _searchController,
                          focusNode: _searchFocusNode,
                          label: copy.searchWallets,
                          hint: copy.searchWalletsHint,
                          sortLabel: copy.sortWallets,
                          activeSortOption: walletState.sortOption,
                          onSortSelected: (WalletSortOption option) {
                            ref
                                .read(walletControllerProvider.notifier)
                                .setSortOption(option);
                          },
                        ),
                        const SizedBox(height: AppSpacing.md),
                        if (isInitialLoading)
                          _WalletListSkeleton(columns: columns)
                        else if (visibleWallets.isEmpty &&
                            walletState.wallets.isEmpty)
                          DashboardEmptyState(
                            icon: Icons.account_balance_wallet_outlined,
                            title: copy.noWalletsTitle,
                            message: copy.noWalletsMessage,
                            actionLabel: copy.createWallet,
                            onActionPressed: () =>
                                context.push(AppRoutes.walletCreatePath),
                          )
                        else if (visibleWallets.isEmpty && hasSearchQuery)
                          DashboardEmptyState(
                            icon: Icons.search_off_rounded,
                            title: copy.noWalletSearchResultsTitle,
                            message: copy.noWalletSearchResultsMessage,
                            actionLabel: copy.clearSearch,
                            onActionPressed: () {
                              _searchController.clear();
                              ref
                                  .read(walletControllerProvider.notifier)
                                  .setSearchQuery('');
                            },
                          )
                        else
                          _WalletGrid(
                            wallets: visibleWallets,
                            columns: columns,
                            onWalletPressed: (WalletOverview walletOverview) {
                              context.push(
                                AppRoutes.walletDetailsLocation(
                                  walletOverview.wallet.id,
                                ),
                              );
                            },
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _CreateWalletAction extends StatelessWidget {
  const _CreateWalletAction({required this.tooltip, required this.onPressed});

  final String tooltip;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Material(
      color: colorScheme.primary.withValues(alpha: 0.10),
      borderRadius: BorderRadius.circular(AppRadius.pill),
      child: IconButton(
        onPressed: onPressed,
        tooltip: tooltip,
        visualDensity: VisualDensity.compact,
        icon: Icon(Icons.add_rounded, color: colorScheme.primary),
      ),
    );
  }
}

class _WalletSearchBar extends StatelessWidget {
  const _WalletSearchBar({
    required this.controller,
    required this.focusNode,
    required this.label,
    required this.hint,
    required this.sortLabel,
    required this.activeSortOption,
    required this.onSortSelected,
  });

  final TextEditingController controller;
  final FocusNode focusNode;
  final String label;
  final String hint;
  final String sortLabel;
  final WalletSortOption activeSortOption;
  final ValueChanged<WalletSortOption> onSortSelected;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final DashboardCopy copy = DashboardCopy.of(context);

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool isCompact = constraints.maxWidth < 390;

        return _WalletPageSurface(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          child: Row(
            children: <Widget>[
              Icon(Icons.search_rounded, color: colorScheme.onSurfaceVariant),
              const SizedBox(width: AppSpacing.sm),
              Expanded(
                child: TextField(
                  controller: controller,
                  focusNode: focusNode,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    isDense: true,
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    hintText: hint,
                    labelText: label,
                  ),
                ),
              ),
              const SizedBox(width: AppSpacing.sm),
              PopupMenuButton<WalletSortOption>(
                tooltip: sortLabel,
                initialValue: activeSortOption,
                onSelected: onSortSelected,
                position: PopupMenuPosition.under,
                itemBuilder: (BuildContext context) {
                  return WalletSortOption.values
                      .map(
                        (WalletSortOption option) =>
                            PopupMenuItem<WalletSortOption>(
                              value: option,
                              child: Text(_sortLabel(copy, option)),
                            ),
                      )
                      .toList(growable: false);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.sm,
                    vertical: AppSpacing.sm,
                  ),
                  decoration: BoxDecoration(
                    color: colorScheme.surfaceContainerHighest.withValues(
                      alpha: 0.42,
                    ),
                    borderRadius: BorderRadius.circular(AppRadius.pill),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Icon(
                        Icons.tune_rounded,
                        size: 18,
                        color: colorScheme.onSurfaceVariant,
                      ),
                      if (!isCompact) ...<Widget>[
                        const SizedBox(width: AppSpacing.xs),
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 92),
                          child: Text(
                            _sortLabel(copy, activeSortOption),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: colorScheme.onSurfaceVariant,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _WalletSummaryCard extends StatelessWidget {
  const _WalletSummaryCard({required this.summary});

  final _WalletSummary summary;

  @override
  Widget build(BuildContext context) {
    final DashboardCopy copy = DashboardCopy.of(context);

    return _WalletPageSurface(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stacked = constraints.maxWidth < 600;

          if (stacked) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  copy.walletSummary,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                _SummaryLine(
                  label: copy.totalWallets,
                  value: '${summary.walletCount}',
                ),
                const SizedBox(height: AppSpacing.md),
                _SummaryLine(
                  label: copy.usdTotal,
                  value:
                      '${AmountFormatter.format(summary.totalUsd)} ${copy.usdShort}',
                ),
                const SizedBox(height: AppSpacing.md),
                _SummaryLine(
                  label: copy.sypTotal,
                  value:
                      '${AmountFormatter.format(summary.totalSyp)} ${copy.sypShort}',
                ),
              ],
            );
          }

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                copy.walletSummary,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  Expanded(
                    child: _SummaryLine(
                      label: copy.totalWallets,
                      value: '${summary.walletCount}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _SummaryLine(
                      label: copy.usdTotal,
                      value:
                          '${AmountFormatter.format(summary.totalUsd)} ${copy.usdShort}',
                    ),
                  ),
                  const SizedBox(width: AppSpacing.lg),
                  Expanded(
                    child: _SummaryLine(
                      label: copy.sypTotal,
                      value:
                          '${AmountFormatter.format(summary.totalSyp)} ${copy.sypShort}',
                    ),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.labelMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        Text(
          value,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
      ],
    );
  }
}

class _WalletSummarySkeleton extends StatelessWidget {
  const _WalletSummarySkeleton();

  @override
  Widget build(BuildContext context) {
    return _WalletPageSurface(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stacked = constraints.maxWidth < 600;

          if (stacked) {
            return const Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DashboardSkeletonBlock(height: 20, width: 122),
                SizedBox(height: AppSpacing.lg),
                _SummaryLineSkeleton(),
                SizedBox(height: AppSpacing.md),
                _SummaryLineSkeleton(),
                SizedBox(height: AppSpacing.md),
                _SummaryLineSkeleton(),
              ],
            );
          }

          return const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              DashboardSkeletonBlock(height: 20, width: 122),
              SizedBox(height: AppSpacing.lg),
              Row(
                children: <Widget>[
                  Expanded(child: _SummaryLineSkeleton()),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(child: _SummaryLineSkeleton()),
                  SizedBox(width: AppSpacing.lg),
                  Expanded(child: _SummaryLineSkeleton()),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

class _SummaryLineSkeleton extends StatelessWidget {
  const _SummaryLineSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DashboardSkeletonBlock(height: 14, width: 84),
        SizedBox(height: AppSpacing.xs),
        DashboardSkeletonBlock(height: 22, width: 116),
      ],
    );
  }
}

class _WalletGrid extends StatelessWidget {
  const _WalletGrid({
    required this.wallets,
    required this.columns,
    required this.onWalletPressed,
  });

  final List<WalletOverview> wallets;
  final int columns;
  final ValueChanged<WalletOverview> onWalletPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (columns == 1) {
          return Column(
            children: wallets
                .map(
                  (WalletOverview wallet) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: WalletOverviewCard(
                      walletOverview: wallet,
                      onTap: () => onWalletPressed(wallet),
                    ),
                  ),
                )
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
                  child: WalletOverviewCard(
                    walletOverview: wallet,
                    onTap: () => onWalletPressed(wallet),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _WalletListSkeleton extends StatelessWidget {
  const _WalletListSkeleton({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (columns == 1) {
          return const Column(
            children: <Widget>[
              WalletOverviewCard(isLoading: true),
              SizedBox(height: AppSpacing.md),
              WalletOverviewCard(isLoading: true),
              SizedBox(height: AppSpacing.md),
              WalletOverviewCard(isLoading: true),
            ],
          );
        }

        final double itemWidth =
            (constraints.maxWidth - AppSpacing.md * (columns - 1)) / columns;

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: List<Widget>.generate(
            columns * 2,
            (_) => SizedBox(
              width: itemWidth,
              child: const WalletOverviewCard(isLoading: true),
            ),
          ),
        );
      },
    );
  }
}

class _WalletPageSurface extends StatelessWidget {
  const _WalletPageSurface({required this.child, required this.padding});

  final Widget child;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: theme.brightness == Brightness.dark
              ? colorScheme.outline.withValues(alpha: 0.24)
              : colorScheme.outline.withValues(alpha: 0.14),
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(
              alpha: theme.brightness == Brightness.dark ? 0.09 : 0.03,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}

class _WalletSummary {
  const _WalletSummary({
    required this.walletCount,
    required this.totalUsd,
    required this.totalSyp,
  });

  factory _WalletSummary.fromWallets(List<WalletOverview> wallets) {
    final num totalUsd = wallets.fold<num>(
      0,
      (num total, WalletOverview wallet) =>
          total + (num.tryParse(wallet.balance.usdBalance.amount) ?? 0),
    );
    final num totalSyp = wallets.fold<num>(
      0,
      (num total, WalletOverview wallet) =>
          total + (num.tryParse(wallet.balance.sypBalance.amount) ?? 0),
    );

    return _WalletSummary(
      walletCount: wallets.length,
      totalUsd: totalUsd.toString(),
      totalSyp: totalSyp.toString(),
    );
  }

  final int walletCount;
  final String totalUsd;
  final String totalSyp;
}

String _sortLabel(DashboardCopy copy, WalletSortOption option) {
  return switch (option) {
    WalletSortOption.newest => copy.newest,
    WalletSortOption.oldest => copy.oldest,
    WalletSortOption.nameAscending => copy.nameAscending,
    WalletSortOption.nameDescending => copy.nameDescending,
    WalletSortOption.highestUsd => copy.highestUsd,
    WalletSortOption.highestSyp => copy.highestSyp,
  };
}
