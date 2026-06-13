import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'dashboard_surface_card.dart';

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    super.key,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return DashboardSurfaceCard(
      child: Column(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: colorScheme.primary),
          ),
          const SizedBox(height: AppSpacing.lg),
          Text(
            title,
            textAlign: TextAlign.center,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            textAlign: TextAlign.center,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: colorScheme.onSurfaceVariant,
            ),
          ),
          if (actionLabel != null && onActionPressed != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            FilledButton(onPressed: onActionPressed, child: Text(actionLabel!)),
          ],
        ],
      ),
    );
  }
}
