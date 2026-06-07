import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import 'dashboard_copy.dart';
import 'dashboard_empty_state.dart';
import 'dashboard_skeleton_block.dart';
import 'dashboard_surface_card.dart';

class DashboardDebtOverviewData {
  const DashboardDebtOverviewData({
    required this.owedToMeUsd,
    required this.owedToMeSyp,
    required this.iOweUsd,
    required this.iOweSyp,
    required this.outstandingCount,
  });

  final String owedToMeUsd;
  final String owedToMeSyp;
  final String iOweUsd;
  final String iOweSyp;
  final int outstandingCount;

  bool get isEmpty =>
      outstandingCount == 0 &&
      num.tryParse(owedToMeUsd) == 0 &&
      num.tryParse(owedToMeSyp) == 0 &&
      num.tryParse(iOweUsd) == 0 &&
      num.tryParse(iOweSyp) == 0;
}

class DashboardDebtOverview extends StatelessWidget {
  const DashboardDebtOverview({
    required this.data,
    this.isLoading = false,
    this.onCreateDebtPressed,
    super.key,
  });

  final DashboardDebtOverviewData data;
  final bool isLoading;
  final VoidCallback? onCreateDebtPressed;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool useGrid = constraints.maxWidth >= 600;
          if (useGrid) {
            return const _DashboardDebtGridSkeleton();
          }

          return const Column(
            children: <Widget>[
              DashboardSkeletonBlock(height: 102, radius: AppRadius.lg),
              SizedBox(height: AppSpacing.md),
              DashboardSkeletonBlock(height: 102, radius: AppRadius.lg),
              SizedBox(height: AppSpacing.md),
              DashboardSkeletonBlock(height: 102, radius: AppRadius.lg),
            ],
          );
        },
      );
    }

    final DashboardCopy copy = DashboardCopy.of(context);
    if (data.isEmpty) {
      return DashboardEmptyState(
        icon: Icons.account_balance_wallet_outlined,
        title: copy.noDebtsTitle,
        message: copy.noDebtsMessage,
        actionLabel: onCreateDebtPressed == null ? null : copy.createDebt,
        onActionPressed: onCreateDebtPressed,
      );
    }

    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final bool useGrid = constraints.maxWidth >= 600;
        final List<Widget> cards = <Widget>[
          _DebtSummaryCard(
            title: copy.owedToMe,
            usdValue: data.owedToMeUsd,
            sypValue: data.owedToMeSyp,
            tone: AppColors.success,
          ),
          _DebtSummaryCard(
            title: copy.iOwe,
            usdValue: data.iOweUsd,
            sypValue: data.iOweSyp,
            tone: AppColors.warning,
          ),
          _DebtCountCard(
            count: data.outstandingCount,
            title: copy.outstandingDebts,
            caption: copy.outstandingDebtCaption,
          ),
        ];

        if (!useGrid) {
          return Column(
            children: List<Widget>.generate(cards.length, (int index) {
              return Padding(
                padding: EdgeInsets.only(
                  bottom: index == cards.length - 1 ? 0 : AppSpacing.md,
                ),
                child: cards[index],
              );
            }),
          );
        }

        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: cards
              .map(
                (Widget card) => SizedBox(
                  width: (constraints.maxWidth - AppSpacing.md * 2) / 3,
                  child: card,
                ),
              )
              .toList(growable: false),
        );
      },
    );
  }
}

class _DebtSummaryCard extends StatelessWidget {
  const _DebtSummaryCard({
    required this.title,
    required this.usdValue,
    required this.sypValue,
    required this.tone,
  });

  final String title;
  final String usdValue;
  final String sypValue;
  final Color tone;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _DebtAmountLine(
            label: 'USD',
            value: AmountFormatter.format(usdValue),
            tone: tone,
          ),
          const SizedBox(height: AppSpacing.sm),
          _DebtAmountLine(
            label: 'SYP',
            value: AmountFormatter.format(sypValue),
            tone: colorScheme.onSurface,
          ),
        ],
      ),
    );
  }
}

class _DebtAmountLine extends StatelessWidget {
  const _DebtAmountLine({
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

    return Row(
      children: <Widget>[
        Text(
          '$value $label',
          style: theme.textTheme.titleSmall?.copyWith(
            color: tone,
            fontWeight: FontWeight.w700,
          ),
        ),
        const Spacer(),
        Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: colorScheme.onSurfaceVariant,
          ),
        ),
      ],
    );
  }
}

class _DebtCountCard extends StatelessWidget {
  const _DebtCountCard({
    required this.count,
    required this.title,
    required this.caption,
  });

  final int count;
  final String title;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          Text(
            title,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            '$count',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            caption,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardDebtGridSkeleton extends StatelessWidget {
  const _DashboardDebtGridSkeleton();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = (constraints.maxWidth - AppSpacing.md * 2) / 3;
        return Wrap(
          spacing: AppSpacing.md,
          runSpacing: AppSpacing.md,
          children: List<Widget>.generate(
            3,
            (_) => SizedBox(
              width: width,
              child: const DashboardSkeletonBlock(
                height: 128,
                radius: AppRadius.lg,
              ),
            ),
          ),
        );
      },
    );
  }
}
