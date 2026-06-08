import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../domain/models/wallet_overview.dart';
import '../../../dashboard/presentation/widgets/dashboard_copy.dart';
import '../../../dashboard/presentation/widgets/dashboard_skeleton_block.dart';

class WalletOverviewCard extends StatelessWidget {
  const WalletOverviewCard({
    this.walletOverview,
    this.onTap,
    this.isLoading = false,
    super.key,
  });

  final WalletOverview? walletOverview;
  final VoidCallback? onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const _WalletOverviewSkeleton();
    }

    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final DashboardCopy copy = DashboardCopy.of(context);
    final WalletOverview walletOverview = this.walletOverview!;
    final wallet = walletOverview.wallet;
    final Color indicatorColor = _walletIndicatorColor(
      wallet.name,
      wallet.id,
      colorScheme,
    );

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
              alpha: theme.brightness == Brightness.dark ? 0.10 : 0.035,
            ),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(26),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    Container(
                      width: 10,
                      height: 10,
                      decoration: BoxDecoration(
                        color: indicatorColor,
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
                    _WalletStatusPill(
                      label: wallet.isArchived ? copy.archived : copy.active,
                      emphasized: !wallet.isArchived,
                    ),
                    const SizedBox(width: AppSpacing.xs),
                    Icon(
                      Icons.chevron_right_rounded,
                      size: 18,
                      color: colorScheme.onSurfaceVariant.withValues(
                        alpha: 0.72,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.md),
                _BalanceRow(
                  label: copy.usdShort,
                  amount: AmountFormatter.format(
                    walletOverview.balance.usdBalance.amount,
                  ),
                  currency: copy.usdShort,
                ),
                const SizedBox(height: AppSpacing.sm),
                _BalanceRow(
                  label: copy.sypShort,
                  amount: AmountFormatter.format(
                    walletOverview.balance.sypBalance.amount,
                  ),
                  currency: copy.sypShort,
                ),
                const SizedBox(height: AppSpacing.md),
                Text(
                  _relativeUpdatedLabel(copy, wallet.updatedAt),
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

class _BalanceRow extends StatelessWidget {
  const _BalanceRow({
    required this.label,
    required this.amount,
    required this.currency,
  });

  final String label;
  final String amount;
  final String currency;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return RichText(
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '$label ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          TextSpan(
            text: '$amount $currency',
            style: theme.textTheme.titleMedium?.copyWith(
              color: colorScheme.onSurface,
              fontWeight: FontWeight.w700,
              height: 1.05,
            ),
          ),
        ],
      ),
    );
  }
}

class _WalletStatusPill extends StatelessWidget {
  const _WalletStatusPill({required this.label, required this.emphasized});

  final String label;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.sm,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: emphasized
            ? colorScheme.primary.withValues(alpha: 0.10)
            : colorScheme.surfaceContainerHighest.withValues(alpha: 0.50),
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: Text(
        label,
        style: Theme.of(context).textTheme.labelMedium?.copyWith(
          color: emphasized
              ? colorScheme.primary
              : colorScheme.onSurfaceVariant,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class _WalletOverviewSkeleton extends StatelessWidget {
  const _WalletOverviewSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(26),
        border: Border.all(
          color: Theme.of(context).colorScheme.outline.withValues(alpha: 0.16),
        ),
      ),
      child: const Padding(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              children: <Widget>[
                DashboardSkeletonBlock(height: 10, width: 10, radius: 999),
                SizedBox(width: AppSpacing.sm),
                Expanded(child: DashboardSkeletonBlock(height: 20, width: 140)),
                SizedBox(width: AppSpacing.sm),
                DashboardSkeletonBlock(height: 28, width: 74, radius: 999),
                SizedBox(width: AppSpacing.xs),
                DashboardSkeletonBlock(height: 18, width: 18, radius: 999),
              ],
            ),
            SizedBox(height: AppSpacing.md),
            _WalletBalanceRowSkeleton(),
            SizedBox(height: AppSpacing.sm),
            _WalletBalanceRowSkeleton(),
            SizedBox(height: AppSpacing.md),
            DashboardSkeletonBlock(height: 14, width: 116),
          ],
        ),
      ),
    );
  }
}

class _WalletBalanceRowSkeleton extends StatelessWidget {
  const _WalletBalanceRowSkeleton();

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: <Widget>[
        DashboardSkeletonBlock(height: 14, width: 30),
        SizedBox(width: AppSpacing.sm),
        DashboardSkeletonBlock(height: 22, width: 148),
      ],
    );
  }
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

String _relativeUpdatedLabel(DashboardCopy copy, DateTime updatedAt) {
  final DateTime now = DateTime.now();
  final Duration difference = now.difference(updatedAt.toLocal());

  if (difference.inMinutes < 1) {
    return copy.updatedJustNow;
  }
  if (difference.inMinutes < 60) {
    return copy.updatedMinutesAgo(difference.inMinutes);
  }
  if (difference.inHours < 6) {
    return copy.updatedHoursAgo(difference.inHours);
  }
  if (_isSameDate(now, updatedAt.toLocal())) {
    return copy.updatedToday;
  }
  if (_isSameDate(now.subtract(const Duration(days: 1)), updatedAt.toLocal())) {
    return copy.updatedYesterday;
  }
  return copy.updatedDaysAgo(difference.inDays);
}

bool _isSameDate(DateTime left, DateTime right) {
  return left.year == right.year &&
      left.month == right.month &&
      left.day == right.day;
}
