import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import 'dashboard_skeleton_block.dart';
import 'dashboard_surface_card.dart';

class DashboardWalletPreviewCard extends StatelessWidget {
  const DashboardWalletPreviewCard({
    this.walletOverview,
    required this.showBalances,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  final WalletOverview? walletOverview;
  final bool showBalances;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const DashboardSurfaceCard(
        padding: EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.md,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Row(
              children: <Widget>[
                DashboardSkeletonBlock(height: 18, width: 110),
                Spacer(),
                DashboardSkeletonBlock(
                  height: 24,
                  width: 60,
                  radius: AppRadius.pill,
                ),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            Row(
              children: <Widget>[
                Expanded(child: DashboardSkeletonBlock(height: 14, width: 72)),
                SizedBox(width: AppSpacing.md),
                Expanded(child: DashboardSkeletonBlock(height: 14, width: 72)),
              ],
            ),
            SizedBox(height: AppSpacing.xs),
            Row(
              children: <Widget>[
                Expanded(child: DashboardSkeletonBlock(height: 18, width: 92)),
                SizedBox(width: AppSpacing.md),
                Expanded(child: DashboardSkeletonBlock(height: 18, width: 92)),
              ],
            ),
          ],
        ),
      );
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final WalletOverview resolvedWalletOverview = walletOverview!;
    final wallet = resolvedWalletOverview.wallet;
    final bool isArabic = Directionality.of(context) == TextDirection.rtl;

    return DashboardSurfaceCard(
      padding: EdgeInsets.zero,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            child: Stack(
              children: <Widget>[
                PositionedDirectional(
                  top: 0,
                  start: isArabic ? null : 0,
                  end: isArabic ? 0 : null,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.sm,
                      vertical: AppSpacing.xs,
                    ),
                    decoration: BoxDecoration(
                      color:
                          (wallet.isArchived
                                  ? colorScheme.error
                                  : colorScheme.primary)
                              .withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppRadius.pill),
                    ),
                    child: Text(
                      wallet.isArchived
                          ? context.tr.archived
                          : context.tr.active,
                      style: theme.textTheme.labelMedium?.copyWith(
                        color: wallet.isArchived
                            ? colorScheme.error
                            : colorScheme.primary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsetsDirectional.only(
                        start: isArabic ? 0 : 80,
                        end: isArabic ? 80 : 0,
                      ),
                      child: Text(
                        wallet.name,
                        textAlign: TextAlign.right,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: _WalletBalanceLine(
                            value: showBalances
                                ? AmountFormatter.format(
                                    resolvedWalletOverview
                                        .balance
                                        .sypBalance
                                        .amount,
                                  )
                                : context.tr.hiddenValue,
                            currency: context.tr.sypShort,
                          ),
                        ),
                        const SizedBox(width: AppSpacing.md),
                        Expanded(
                          child: _WalletBalanceLine(
                            value: showBalances
                                ? AmountFormatter.format(
                                    resolvedWalletOverview
                                        .balance
                                        .usdBalance
                                        .amount,
                                  )
                                : context.tr.hiddenValue,
                            currency: context.tr.usdShort,
                          ),
                        ),
                      ],
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

class _WalletBalanceLine extends StatelessWidget {
  const _WalletBalanceLine({required this.value, required this.currency});

  final String value;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            Text(
              currency,
              style: theme.textTheme.labelMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Flexible(
              child: FittedBox(
                fit: BoxFit.scaleDown,
                alignment: Alignment.centerRight,
                child: Text(
                  value,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
