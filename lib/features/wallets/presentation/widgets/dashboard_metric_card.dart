import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';

class DashboardMetricCard extends StatelessWidget {
  const DashboardMetricCard({
    required this.label,
    required this.value,
    required this.caption,
    required this.icon,
    super.key,
  });

  final String label;
  final String value;
  final String caption;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return PwSectionCard(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Icon(icon, color: AppColors.brand),
            const SizedBox(height: AppSpacing.md),
            Text(label, style: context.bodyLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(value, style: context.titleLarge),
            const SizedBox(height: AppSpacing.sm),
            Text(caption),
          ],
        ),
      ),
    );
  }
}
