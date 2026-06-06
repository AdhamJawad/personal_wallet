import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class DisabledQuickActionCard extends StatelessWidget {
  const DisabledQuickActionCard({
    required this.label,
    required this.icon,
    super.key,
  });

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.65,
      child: PwSectionCard(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Icon(icon, color: AppColors.textPrimary),
              const SizedBox(height: AppSpacing.md),
              Text(label, style: context.titleMedium),
              const SizedBox(height: AppSpacing.sm),
              const Text('Available after the transaction module is added.'),
            ],
          ),
        ),
      ),
    );
  }
}
