import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import 'dashboard_skeleton_block.dart';
import 'dashboard_surface_card.dart';

class DashboardTotalAssetsCard extends StatelessWidget {
  const DashboardTotalAssetsCard({
    required this.totalUsd,
    required this.totalSyp,
    required this.showBalances,
    required this.onToggleVisibility,
    required this.updatedLabel,
    this.isLoading = false,
    super.key,
  });

  final String totalUsd;
  final String totalSyp;
  final bool showBalances;
  final VoidCallback onToggleVisibility;
  final String updatedLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const DashboardSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.xl),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                DashboardSkeletonBlock(
                  height: 40,
                  width: 40,
                  radius: AppRadius.md,
                ),
                Spacer(),
                DashboardSkeletonBlock(height: 18, width: 110),
              ],
            ),
            SizedBox(height: AppSpacing.xl),
            DashboardSkeletonBlock(
              height: 42,
              width: 210,
              radius: AppRadius.lg,
            ),
            SizedBox(height: AppSpacing.sm),
            DashboardSkeletonBlock(height: 22, width: 148),
            SizedBox(height: AppSpacing.lg),
            DashboardSkeletonBlock(height: 14, width: 124),
            SizedBox(height: AppSpacing.sm),
            DashboardSkeletonBlock(height: 12, width: 150),
          ],
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.xl),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      context.tr.totalAssets,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withValues(alpha: 0.22),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.10),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: IconButton(
                  onPressed: onToggleVisibility,
                  padding: EdgeInsets.zero,
                  tooltip: showBalances
                      ? context.tr.hideBalances
                      : context.tr.showBalances,
                  icon: Icon(
                    showBalances
                        ? Icons.visibility_off_rounded
                        : Icons.visibility_rounded,
                    size: 20,
                  ),
                  color: colorScheme.primary,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          _AssetAmountLine(
            value: showBalances
                ? AmountFormatter.format(totalUsd)
                : context.tr.hiddenValue,
            currency: context.tr.usdShort,
            textStyle: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: isArabic ? 0 : -0.8,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _AssetAmountLine(
            value: showBalances
                ? AmountFormatter.format(totalSyp)
                : context.tr.hiddenValue,
            currency: context.tr.sypShort,
            textStyle: theme.textTheme.titleLarge?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            context.tr.activeWalletsHint,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            updatedLabel,
            textAlign: TextAlign.right,
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _AssetAmountLine extends StatelessWidget {
  const _AssetAmountLine({
    required this.value,
    required this.currency,
    required this.textStyle,
  });

  final String value;
  final String currency;
  final TextStyle? textStyle;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          currency,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleSmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Flexible(
          child: FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerRight,
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: textStyle,
            ),
          ),
        ),
      ],
    );
  }
}
