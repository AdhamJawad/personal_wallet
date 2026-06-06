import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../domain/models/wallet_overview.dart';
import 'wallet_balance_panel.dart';

class WalletOverviewCard extends StatelessWidget {
  const WalletOverviewCard({
    required this.walletOverview,
    this.onTap,
    this.trailing,
    super.key,
  });

  final WalletOverview walletOverview;
  final VoidCallback? onTap;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final wallet = walletOverview.wallet;

    return PwSectionCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(wallet.name, style: context.titleMedium),
                        const SizedBox(height: AppSpacing.xs),
                        Text(
                          wallet.isArchived
                              ? 'Archived wallet'
                              : 'Active wallet',
                          style: TextStyle(
                            color: wallet.isArchived
                                ? AppColors.warning
                                : AppColors.success,
                          ),
                        ),
                      ],
                    ),
                  ),
                  trailing ?? const SizedBox.shrink(),
                ],
              ),
              const SizedBox(height: AppSpacing.lg),
              WalletBalancePanel(
                usdAmount: walletOverview.balance.usdBalance.amount,
                sypAmount: walletOverview.balance.sypBalance.amount,
              ),
              const SizedBox(height: AppSpacing.lg),
              Text('Created ${DateFormatter.short(wallet.createdAt)}'),
            ],
          ),
        ),
      ),
    );
  }
}
