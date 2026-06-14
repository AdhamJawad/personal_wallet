import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../dashboard/presentation/widgets/dashboard_breakpoints.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_skeleton_block.dart';
import '../../../dashboard/presentation/widgets/dashboard_surface_card.dart';
import '../../domain/models/debt_summary.dart';
import '../providers/debt_providers.dart';
import 'create_debt_page.dart';

class DebtsPage extends ConsumerStatefulWidget {
  const DebtsPage({super.key});

  @override
  ConsumerState<DebtsPage> createState() => _DebtsPageState();
}

class _DebtsPageState extends ConsumerState<DebtsPage> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;
  _DebtFilter _selectedFilter = _DebtFilter.all;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    _searchFocusNode = FocusNode();
    _searchController.addListener(_handleSearchChanged);
  }

  @override
  void dispose() {
    _searchController
      ..removeListener(_handleSearchChanged)
      ..dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _handleSearchChanged() {
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);
    final List<DebtSummary> debts = List<DebtSummary>.from(debtState.debts)
      ..sort(
        (DebtSummary left, DebtSummary right) =>
            right.debt.updatedAt.compareTo(left.debt.updatedAt),
      );
    final List<DebtSummary> visibleDebts = _applyDebtFilter(
      debts,
      filter: _selectedFilter,
      query: _searchController.text,
    );
    final bool isInitialLoading = debtState.isLoading && debts.isEmpty;
    final bool hasLoadError = debtState.errorMessage != null && debts.isEmpty;
    final bool hasSearchQuery = _searchController.text.trim().isNotEmpty;
    final bool hasActiveFilter = _selectedFilter != _DebtFilter.all;
    final _DebtOverviewSummary summary = _DebtOverviewSummary.fromDebts(debts);

    return GestureDetector(
      behavior: HitTestBehavior.translucent,
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        appBar: AppBar(
          titleSpacing: AppSpacing.lg,
          title: Text(context.tr.debts),
          actions: <Widget>[
            Padding(
              padding: const EdgeInsetsDirectional.only(end: AppSpacing.lg),
              child: _CreateDebtAction(
                label: context.tr.createDebt,
                onPressed: () => showCreateDebtSheet(context),
              ),
            ),
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
            final int columns = switch (breakpoint) {
              DashboardBreakpoint.smallPhone => 1,
              DashboardBreakpoint.phone => 1,
              DashboardBreakpoint.tablet => 2,
              DashboardBreakpoint.largeTablet => 2,
            };

            return SafeArea(
              top: false,
              child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: dashboardPageMaxWidth,
                  ),
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
                        const _DebtOverviewSkeleton()
                      else
                        _DebtOverviewCard(summary: summary),
                      const SizedBox(height: AppSpacing.md),
                      _DebtFilters(
                        selectedFilter: _selectedFilter,
                        onFilterSelected: (_DebtFilter filter) {
                          setState(() => _selectedFilter = filter);
                        },
                      ),
                      const SizedBox(height: AppSpacing.md),
                      _DebtSearchBar(
                        controller: _searchController,
                        focusNode: _searchFocusNode,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      if (isInitialLoading)
                        _DebtListSkeleton(columns: columns)
                      else if (hasLoadError)
                        DashboardEmptyState.error(
                          title: context.tr.somethingWentWrong,
                          message: context.tr.debtsLoadFailedMessage,
                          actionLabel: context.tr.tryAgain,
                          onActionPressed: () {
                            ref
                                .read(debtControllerProvider.notifier)
                                .initialize();
                          },
                        )
                      else if (debts.isEmpty)
                        DashboardEmptyState(
                          icon: Icons.receipt_long_outlined,
                          title: context.tr.noDebtRecordsYetTitle,
                          message: context.tr.noDebtRecordsYetMessage,
                          actionLabel: context.tr.createDebt,
                          onActionPressed: () => showCreateDebtSheet(context),
                        )
                      else if (visibleDebts.isEmpty && hasSearchQuery)
                        DashboardEmptyState.search(
                          title: context.tr.noDebtSearchResultsTitle,
                          message: context.tr.noDebtSearchResultsMessage,
                          actionLabel: context.tr.clearSearch,
                          onActionPressed: () => _searchController.clear(),
                          secondaryActionLabel: hasActiveFilter
                              ? context.tr.clearFilters
                              : null,
                          onSecondaryActionPressed: hasActiveFilter
                              ? () => setState(
                                  () => _selectedFilter = _DebtFilter.all,
                                )
                              : null,
                        )
                      else if (visibleDebts.isEmpty && hasActiveFilter)
                        DashboardEmptyState.filter(
                          title: context.tr.noDebtFilterResultsTitle,
                          message: context.tr.noDebtFilterResultsMessage,
                          actionLabel: context.tr.clearFilters,
                          onActionPressed: () {
                            setState(() => _selectedFilter = _DebtFilter.all);
                          },
                        )
                      else
                        _DebtGrid(
                          debts: visibleDebts,
                          columns: columns,
                          onDebtPressed: (DebtSummary debt) {
                            context.push(
                              AppRoutes.debtDetailsLocation(debt.debt.id),
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
    );
  }
}

class _CreateDebtAction extends StatelessWidget {
  const _CreateDebtAction({required this.label, required this.onPressed});

  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Ink(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: AppSpacing.sm,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.10),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Icon(Icons.add_rounded, size: 18, color: colorScheme.primary),
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

class _DebtOverviewCard extends StatelessWidget {
  const _DebtOverviewCard({required this.summary});

  final _DebtOverviewSummary summary;

  @override
  Widget build(BuildContext context) {
    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            context.tr.debtOverview,
            style: Theme.of(
              context,
            ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: AppSpacing.md),
          LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool stacked = constraints.maxWidth < 640;
              final Widget owedMetric = _DebtOverviewMetric(
                label: context.tr.owedToMe,
                value: summary.owedToMeLabel(context),
                tone: AppColors.success,
              );
              final Widget iOweMetric = _DebtOverviewMetric(
                label: context.tr.iOwe,
                value: summary.iOweLabel(context),
                tone: AppColors.warning,
              );
              final Widget openMetric = _DebtOverviewMetric(
                label: context.tr.openRecords,
                value: '${summary.openCount}',
                tone: Theme.of(context).colorScheme.primary,
              );

              if (stacked) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    owedMetric,
                    const SizedBox(height: AppSpacing.sm),
                    iOweMetric,
                    const SizedBox(height: AppSpacing.sm),
                    openMetric,
                  ],
                );
              }

              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Expanded(child: owedMetric),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: iOweMetric),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(child: openMetric),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

class _DebtOverviewMetric extends StatelessWidget {
  const _DebtOverviewMetric({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

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
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.titleSmall?.copyWith(
            color: tone,
            fontWeight: FontWeight.w700,
            height: 1.15,
          ),
        ),
      ],
    );
  }
}

class _DebtFilters extends StatelessWidget {
  const _DebtFilters({
    required this.selectedFilter,
    required this.onFilterSelected,
  });

  final _DebtFilter selectedFilter;
  final ValueChanged<_DebtFilter> onFilterSelected;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: _DebtFilter.values
            .map(
              (_DebtFilter filter) => Padding(
                padding: const EdgeInsetsDirectional.only(end: AppSpacing.sm),
                child: _DebtFilterChip(
                  label: _filterLabel(context, filter),
                  selected: selectedFilter == filter,
                  onTap: () => onFilterSelected(filter),
                ),
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _DebtFilterChip extends StatelessWidget {
  const _DebtFilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
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
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.md,
            vertical: 10,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colorScheme.primary.withValues(alpha: 0.10)
                : colorScheme.surface,
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: selected
                  ? colorScheme.primary.withValues(alpha: 0.24)
                  : colorScheme.outline.withValues(alpha: 0.16),
            ),
          ),
          child: Text(
            label,
            style: theme.textTheme.labelLarge?.copyWith(
              color: selected
                  ? colorScheme.primary
                  : colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

class _DebtSearchBar extends StatelessWidget {
  const _DebtSearchBar({required this.controller, required this.focusNode});

  final TextEditingController controller;
  final FocusNode focusNode;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return _DebtsPageSurface(
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
                labelText: context.tr.searchDebts,
                hintText: context.tr.searchDebtsHint,
              ),
            ),
          ),
          if (controller.text.trim().isNotEmpty) ...<Widget>[
            const SizedBox(width: AppSpacing.sm),
            Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: controller.clear,
                borderRadius: BorderRadius.circular(AppRadius.pill),
                child: Padding(
                  padding: const EdgeInsets.all(AppSpacing.xs),
                  child: Icon(
                    Icons.close_rounded,
                    size: 18,
                    color: colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _DebtGrid extends StatelessWidget {
  const _DebtGrid({
    required this.debts,
    required this.columns,
    required this.onDebtPressed,
  });

  final List<DebtSummary> debts;
  final int columns;
  final ValueChanged<DebtSummary> onDebtPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (columns == 1) {
          return Column(
            children: debts
                .map(
                  (DebtSummary debt) => Padding(
                    padding: const EdgeInsets.only(bottom: AppSpacing.md),
                    child: _DebtListCard(
                      debt: debt,
                      onTap: () => onDebtPressed(debt),
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
          children: debts
              .map(
                (DebtSummary debt) => SizedBox(
                  width: itemWidth,
                  child: _DebtListCard(
                    debt: debt,
                    onTap: () => onDebtPressed(debt),
                  ),
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _DebtListCard extends StatelessWidget {
  const _DebtListCard({required this.debt, required this.onTap});

  final DebtSummary debt;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final _DebtPresentationModel presentation = _DebtPresentationModel.fromDebt(
      context,
      debt,
    );

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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          TextButton(
                            onPressed: () => context.push(
                              AppRoutes.contactDetailsLocation(debt.contact.id),
                            ),
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.zero,
                              minimumSize: Size.zero,
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(
                              debt.contact.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: theme.textTheme.titleSmall?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: AppSpacing.md),
                    _DebtBadge(
                      label: presentation.directionLabel,
                      backgroundColor: presentation.directionColor.withValues(
                        alpha: 0.10,
                      ),
                      foregroundColor: presentation.directionColor,
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  presentation.amountLabel,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: presentation.directionColor,
                    height: 1.05,
                  ),
                ),
                const SizedBox(height: AppSpacing.md),
                Wrap(
                  spacing: AppSpacing.md,
                  runSpacing: AppSpacing.xs,
                  children: <Widget>[
                    Text(
                      '${context.tr.createdLabel}: ${DateFormatter.short(debt.debt.createdAt)}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                    Text(
                      '${context.tr.remainingAmountLabel}: ${presentation.remainingLabel}',
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: <Widget>[
                    _DebtBadge(
                      label: presentation.statusLabel,
                      backgroundColor: presentation.statusColor.withValues(
                        alpha: 0.10,
                      ),
                      foregroundColor: presentation.statusColor,
                    ),
                    const Spacer(),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _DebtBadge extends StatelessWidget {
  const _DebtBadge({
    required this.label,
    required this.backgroundColor,
    required this.foregroundColor,
  });

  final String label;
  final Color backgroundColor;
  final Color foregroundColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: foregroundColor,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _DebtOverviewSkeleton extends StatelessWidget {
  const _DebtOverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DashboardSkeletonBlock(height: 22, width: 140),
          SizedBox(height: AppSpacing.md),
          Row(
            children: <Widget>[
              Expanded(child: _DebtOverviewMetricSkeleton()),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _DebtOverviewMetricSkeleton()),
              SizedBox(width: AppSpacing.md),
              Expanded(child: _DebtOverviewMetricSkeleton()),
            ],
          ),
        ],
      ),
    );
  }
}

class _DebtOverviewMetricSkeleton extends StatelessWidget {
  const _DebtOverviewMetricSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        DashboardSkeletonBlock(height: 14, width: 82),
        SizedBox(height: AppSpacing.xs),
        DashboardSkeletonBlock(height: 18, width: 112),
      ],
    );
  }
}

class _DebtListSkeleton extends StatelessWidget {
  const _DebtListSkeleton({required this.columns});

  final int columns;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        if (columns == 1) {
          return const Column(
            children: <Widget>[
              _DebtListCardSkeleton(),
              SizedBox(height: AppSpacing.md),
              _DebtListCardSkeleton(),
              SizedBox(height: AppSpacing.md),
              _DebtListCardSkeleton(),
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
              child: const _DebtListCardSkeleton(),
            ),
          ),
        );
      },
    );
  }
}

class _DebtListCardSkeleton extends StatelessWidget {
  const _DebtListCardSkeleton();

  @override
  Widget build(BuildContext context) {
    return const DashboardSurfaceCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    DashboardSkeletonBlock(height: 18, width: 138),
                    SizedBox(height: AppSpacing.xs),
                    DashboardSkeletonBlock(height: 14, width: 104),
                  ],
                ),
              ),
              SizedBox(width: AppSpacing.md),
              DashboardSkeletonBlock(
                height: 30,
                width: 88,
                radius: AppRadius.pill,
              ),
            ],
          ),
          SizedBox(height: AppSpacing.md),
          DashboardSkeletonBlock(height: 22, width: 122),
          SizedBox(height: AppSpacing.xs),
          DashboardSkeletonBlock(height: 14, width: 168),
          SizedBox(height: AppSpacing.md),
          DashboardSkeletonBlock(height: 14, width: 182),
          SizedBox(height: AppSpacing.md),
          DashboardSkeletonBlock(height: 30, width: 72, radius: AppRadius.pill),
        ],
      ),
    );
  }
}

class _DebtsPageSurface extends StatelessWidget {
  const _DebtsPageSurface({required this.child, required this.padding});

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

enum _DebtFilter { all, owedToMe, iOwe, open, settled }

List<DebtSummary> _applyDebtFilter(
  List<DebtSummary> debts, {
  required _DebtFilter filter,
  required String query,
}) {
  final String normalizedQuery = query.trim().toLowerCase();

  return debts
      .where((DebtSummary debt) {
        final bool matchesFilter = switch (filter) {
          _DebtFilter.all => true,
          _DebtFilter.owedToMe => debt.debt.isOwedToMe,
          _DebtFilter.iOwe => !debt.debt.isOwedToMe,
          _DebtFilter.open => !debt.isCompleted,
          _DebtFilter.settled => debt.isCompleted,
        };

        if (!matchesFilter) {
          return false;
        }

        if (normalizedQuery.isEmpty) {
          return true;
        }

        final String note = (debt.debt.note ?? '').toLowerCase();
        final String contactName = debt.contact.name.toLowerCase();
        final String reference = _debtReference(debt.debt.id).toLowerCase();

        return contactName.contains(normalizedQuery) ||
            note.contains(normalizedQuery) ||
            reference.contains(normalizedQuery);
      })
      .toList(growable: false);
}

String _filterLabel(BuildContext context, _DebtFilter filter) {
  return switch (filter) {
    _DebtFilter.all => context.tr.all,
    _DebtFilter.owedToMe => context.tr.owedToMe,
    _DebtFilter.iOwe => context.tr.iOwe,
    _DebtFilter.open => context.tr.openStatus,
    _DebtFilter.settled => context.tr.settledStatus,
  };
}

String _debtReference(String debtId) {
  return debtId.replaceAll('_', '-').toUpperCase();
}

class _DebtOverviewSummary {
  const _DebtOverviewSummary({
    required this.owedToMeUsd,
    required this.owedToMeSyp,
    required this.iOweUsd,
    required this.iOweSyp,
    required this.openCount,
  });

  factory _DebtOverviewSummary.fromDebts(List<DebtSummary> debts) {
    num owedToMeUsd = 0;
    num owedToMeSyp = 0;
    num iOweUsd = 0;
    num iOweSyp = 0;
    int openCount = 0;

    for (final DebtSummary debt in debts) {
      final num remaining = num.tryParse(debt.remainingAmount) ?? 0;
      if (!debt.isCompleted) {
        openCount += 1;
      }

      if (debt.debt.isOwedToMe) {
        if (debt.currency.name == 'usd') {
          owedToMeUsd += remaining;
        } else {
          owedToMeSyp += remaining;
        }
      } else if (debt.currency.name == 'usd') {
        iOweUsd += remaining;
      } else {
        iOweSyp += remaining;
      }
    }

    return _DebtOverviewSummary(
      owedToMeUsd: owedToMeUsd.toString(),
      owedToMeSyp: owedToMeSyp.toString(),
      iOweUsd: iOweUsd.toString(),
      iOweSyp: iOweSyp.toString(),
      openCount: openCount,
    );
  }

  final String owedToMeUsd;
  final String owedToMeSyp;
  final String iOweUsd;
  final String iOweSyp;
  final int openCount;

  String owedToMeLabel(BuildContext context) {
    return _formatCurrencyPair(
      context,
      usdAmount: owedToMeUsd,
      sypAmount: owedToMeSyp,
    );
  }

  String iOweLabel(BuildContext context) {
    return _formatCurrencyPair(context, usdAmount: iOweUsd, sypAmount: iOweSyp);
  }

  String _formatCurrencyPair(
    BuildContext context, {
    required String usdAmount,
    required String sypAmount,
  }) {
    final num usd = num.tryParse(usdAmount) ?? 0;
    final num syp = num.tryParse(sypAmount) ?? 0;
    final List<String> segments = <String>[];

    if (usd > 0 || (usd == 0 && syp == 0)) {
      segments.add(_formatAmountWithCurrency(usdAmount, context.tr.usdShort));
    }
    if (syp > 0) {
      segments.add(_formatAmountWithCurrency(sypAmount, context.tr.sypShort));
    }

    return segments.join(' · ');
  }

  String _formatAmountWithCurrency(String amount, String currency) {
    return '\u2066${AmountFormatter.format(amount)} $currency\u2069';
  }
}

class _DebtPresentationModel {
  const _DebtPresentationModel({
    required this.amountLabel,
    required this.remainingLabel,
    required this.directionLabel,
    required this.directionColor,
    required this.statusLabel,
    required this.statusColor,
  });

  factory _DebtPresentationModel.fromDebt(
    BuildContext context,
    DebtSummary debt,
  ) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color directionColor = debt.debt.isOwedToMe
        ? AppColors.success
        : AppColors.warning;
    final _DebtStatusPresentation status = _resolveDebtStatus(
      context,
      debt,
      colorScheme,
    );
    final String currencyCode = debt.currency.name.toUpperCase();

    return _DebtPresentationModel(
      amountLabel:
          '${AmountFormatter.format(debt.debt.originalAmount)} $currencyCode',
      remainingLabel:
          '${AmountFormatter.format(debt.remainingAmount)} $currencyCode',
      directionLabel: debt.debt.isOwedToMe
          ? context.tr.owedToMe
          : context.tr.iOwe,
      directionColor: directionColor,
      statusLabel: status.label,
      statusColor: status.color,
    );
  }

  final String amountLabel;
  final String remainingLabel;
  final String directionLabel;
  final Color directionColor;
  final String statusLabel;
  final Color statusColor;
}

class _DebtStatusPresentation {
  const _DebtStatusPresentation({required this.label, required this.color});

  final String label;
  final Color color;
}

_DebtStatusPresentation _resolveDebtStatus(
  BuildContext context,
  DebtSummary debt,
  ColorScheme colorScheme,
) {
  if (debt.isCompleted) {
    return _DebtStatusPresentation(
      label: context.tr.settledStatus,
      color: colorScheme.onSurfaceVariant,
    );
  }

  return _DebtStatusPresentation(
    label: context.tr.openStatus,
    color: colorScheme.primary,
  );
}
