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
    required this.updatedLabel,
    this.isLoading = false,
    super.key,
  });

  final String totalUsd;
  final String totalSyp;
  final String updatedLabel;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const DashboardSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                DashboardSkeletonBlock(height: 18, width: 110),
                Spacer(),
                DashboardSkeletonBlock(height: 12, width: 70),
              ],
            ),
            SizedBox(height: AppSpacing.lg),
            DashboardSkeletonBlock(
              height: 34,
              width: 180,
              radius: AppRadius.lg,
            ),
            SizedBox(height: AppSpacing.sm),
            DashboardSkeletonBlock(height: 18, width: 132),
            SizedBox(height: AppSpacing.md),
            DashboardSkeletonBlock(height: 12, width: 96),
          ],
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return DashboardSurfaceCard(
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
                    Text(
                      context.tr.totalAssets,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xs),
                    Text(
                      updatedLabel,
                      textAlign: TextAlign.right,
                      style: theme.textTheme.labelSmall?.copyWith(
                        color: colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: 10,
                height: 10,
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  color: colorScheme.primary.withValues(alpha: 0.22),
                  shape: BoxShape.circle,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _AssetAmountLine(
            value: AmountFormatter.format(totalUsd),
            currency: context.tr.usdShort,
            textStyle: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.w700,
              letterSpacing: isArabic ? 0 : -0.8,
              height: 1,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          _AssetAmountLine(
            value: AmountFormatter.format(totalSyp),
            currency: context.tr.sypShort,
            textStyle: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Text(
            context.tr.activeWalletsHint,
            textAlign: TextAlign.right,
            style: theme.textTheme.bodySmall?.copyWith(
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
            child: Text(value, textAlign: TextAlign.right, style: textStyle),
          ),
        ),
      ],
    );
  }
}
