import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../transactions/domain/models/ledger_transaction.dart';
import 'dashboard_copy.dart';
import 'dashboard_empty_state.dart';
import 'dashboard_formatters.dart';
import 'dashboard_skeleton_block.dart';
import 'dashboard_surface_card.dart';

class DashboardActivityData {
  const DashboardActivityData({
    required this.title,
    required this.subtitle,
    required this.timestamp,
    required this.amount,
    required this.currencyCode,
    required this.walletLabel,
    required this.type,
  });

  final String title;
  final String subtitle;
  final DateTime timestamp;
  final String amount;
  final String currencyCode;
  final String walletLabel;
  final TransactionType type;

  static DashboardActivityData fromTransaction(
    LedgerTransaction transaction,
    String walletLabel,
    DashboardCopy copy,
  ) {
    return DashboardActivityData(
      title: switch (transaction.type) {
        TransactionType.deposit => copy.depositActivity,
        TransactionType.withdraw => copy.withdrawActivity,
        TransactionType.transfer => transaction.recipientUserId == null
            ? copy.transferActivity
            : transaction.debtSettlementId == null
            ? copy.transferActivity
            : copy.debtSettlementActivity,
        TransactionType.exchange => copy.exchangeActivity,
        TransactionType.reversal => copy.reversalActivity,
        TransactionType.correction => copy.correctionActivity,
      },
      subtitle: transaction.note?.trim().isNotEmpty == true
          ? transaction.note!.trim()
          : transaction.reference.value,
      timestamp: transaction.createdAt,
      amount: transaction.sourceAmount,
      currencyCode: transaction.sourceCurrency.name.toUpperCase(),
      walletLabel: walletLabel,
      type: transaction.type,
    );
  }
}

class DashboardActivityList extends StatelessWidget {
  const DashboardActivityList({
    required this.items,
    this.isLoading = false,
    super.key,
  });

  final List<DashboardActivityData> items;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const DashboardSurfaceCard(
        child: Column(
          children: <Widget>[
            _DashboardActivitySkeletonRow(),
            SizedBox(height: AppSpacing.lg),
            _DashboardActivitySkeletonRow(),
            SizedBox(height: AppSpacing.lg),
            _DashboardActivitySkeletonRow(),
            SizedBox(height: AppSpacing.lg),
            _DashboardActivitySkeletonRow(),
            SizedBox(height: AppSpacing.lg),
            _DashboardActivitySkeletonRow(),
          ],
        ),
      );
    }

    if (items.isEmpty) {
      final DashboardCopy copy = DashboardCopy.of(context);
      return DashboardEmptyState(
        icon: Icons.receipt_long_rounded,
        title: copy.noActivityTitle,
        message: copy.noActivityMessage,
      );
    }

    return DashboardSurfaceCard(
      child: Column(
        children: List<Widget>.generate(items.length, (int index) {
          final DashboardActivityData item = items[index];
          return Padding(
            padding: EdgeInsets.only(
              bottom: index == items.length - 1 ? 0 : AppSpacing.lg,
            ),
            child: _DashboardActivityRow(item: item),
          );
        }),
      ),
    );
  }
}

class _DashboardActivityRow extends StatelessWidget {
  const _DashboardActivityRow({required this.item});

  final DashboardActivityData item;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final IconData icon = switch (item.type) {
      TransactionType.deposit => Icons.south_west_rounded,
      TransactionType.withdraw => Icons.north_east_rounded,
      TransactionType.transfer => Icons.swap_horiz_rounded,
      TransactionType.exchange => Icons.currency_exchange_rounded,
      TransactionType.reversal => Icons.undo_rounded,
      TransactionType.correction => Icons.rule_folder_rounded,
    };
    final bool isPositive = item.type == TransactionType.deposit;
    final Color amountColor = isPositive
        ? Colors.green.shade600
        : colorScheme.onSurface;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: colorScheme.primary.withValues(alpha: 0.10),
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Icon(icon, color: colorScheme.primary, size: 20),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.title,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          item.walletLabel,
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          formatDashboardTimestamp(context, item.timestamp),
                          textAlign: TextAlign.right,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minWidth: 88,
                      maxWidth: 124,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text(
                              item.currencyCode,
                              textAlign: TextAlign.right,
                              style: theme.textTheme.labelMedium?.copyWith(
                                color: colorScheme.onSurfaceVariant,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(width: AppSpacing.xs),
                            Flexible(
                              child: FittedBox(
                                fit: BoxFit.scaleDown,
                                alignment: Alignment.centerRight,
                                child: Text(
                                  '${isPositive ? '+' : ''}${AmountFormatter.format(item.amount)}',
                                  textAlign: TextAlign.right,
                                  style: theme.textTheme.titleSmall?.copyWith(
                                    fontWeight: FontWeight.w700,
                                    color: amountColor,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          item.subtitle,
                          textAlign: TextAlign.left,
                          maxLines: 2,
                          overflow: TextOverflow.visible,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _DashboardActivitySkeletonRow extends StatelessWidget {
  const _DashboardActivitySkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: <Widget>[
                      DashboardSkeletonBlock(height: 16, width: 82),
                      SizedBox(height: AppSpacing.xs),
                      DashboardSkeletonBlock(height: 12, width: 60),
                    ],
                  ),
                  SizedBox(width: AppSpacing.md),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        DashboardSkeletonBlock(height: 16, width: 104),
                        SizedBox(height: AppSpacing.xs),
                        DashboardSkeletonBlock(height: 14, width: 76),
                        SizedBox(height: AppSpacing.xs),
                        DashboardSkeletonBlock(height: 12, width: 94),
                      ],
                    ),
                  ),
                  SizedBox(width: AppSpacing.md),
                  DashboardSkeletonBlock(
                    height: 40,
                    width: 40,
                    radius: AppRadius.md,
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
