import 'package:flutter/material.dart';

import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class WalletBalancePanel extends StatelessWidget {
  const WalletBalancePanel({
    required this.usdAmount,
    required this.sypAmount,
    super.key,
  });

  final String usdAmount;
  final String sypAmount;

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: AppSpacing.md,
      runSpacing: AppSpacing.md,
      children: <Widget>[
        _BalanceChip(
          label: 'USD',
          value: AmountFormatter.format(usdAmount),
          color: AppColors.brand,
        ),
        _BalanceChip(
          label: 'SYP',
          value: AmountFormatter.format(sypAmount),
          color: AppColors.accent,
        ),
      ],
    );
  }
}

class _BalanceChip extends StatelessWidget {
  const _BalanceChip({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minWidth: 140),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.2)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label),
          const SizedBox(height: AppSpacing.xs),
          Text(value, style: context.titleMedium),
        ],
      ),
    );
  }
}
