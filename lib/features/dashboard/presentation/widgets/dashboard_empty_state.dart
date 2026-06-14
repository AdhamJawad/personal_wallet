import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'dashboard_surface_card.dart';

enum DashboardStateVariant { empty, error, notFound, search, filter }

class DashboardEmptyState extends StatelessWidget {
  const DashboardEmptyState({
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.actions,
    this.variant = DashboardStateVariant.empty,
    super.key,
  });

  const DashboardEmptyState.error({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.actions,
    IconData? icon,
    super.key,
  }) : icon = icon ?? Icons.error_outline_rounded,
       variant = DashboardStateVariant.error;

  const DashboardEmptyState.notFound({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.actions,
    IconData? icon,
    super.key,
  }) : icon = icon ?? Icons.search_off_rounded,
       variant = DashboardStateVariant.notFound;

  const DashboardEmptyState.search({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.actions,
    IconData? icon,
    super.key,
  }) : icon = icon ?? Icons.search_off_rounded,
       variant = DashboardStateVariant.search;

  const DashboardEmptyState.filter({
    required this.title,
    required this.message,
    this.actionLabel,
    this.onActionPressed,
    this.secondaryActionLabel,
    this.onSecondaryActionPressed,
    this.actions,
    IconData? icon,
    super.key,
  }) : icon = icon ?? Icons.filter_alt_off_rounded,
       variant = DashboardStateVariant.filter;

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onActionPressed;
  final String? secondaryActionLabel;
  final VoidCallback? onSecondaryActionPressed;
  final Widget? actions;
  final DashboardStateVariant variant;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final Color accentColor = switch (variant) {
      DashboardStateVariant.error => colorScheme.error,
      DashboardStateVariant.empty => colorScheme.primary,
      DashboardStateVariant.notFound => colorScheme.primary,
      DashboardStateVariant.search => colorScheme.primary,
      DashboardStateVariant.filter => colorScheme.primary,
    };
    final Color badgeColor = accentColor.withValues(alpha: 0.10);

    return DashboardSurfaceCard(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 64,
            height: 64,
            decoration: BoxDecoration(
              color: badgeColor,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Icon(icon, color: accentColor, size: 30),
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
          if (actions != null) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            actions!,
          ] else if ((actionLabel != null && onActionPressed != null) ||
              (secondaryActionLabel != null &&
                  onSecondaryActionPressed != null)) ...<Widget>[
            const SizedBox(height: AppSpacing.lg),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: <Widget>[
                if (actionLabel != null && onActionPressed != null)
                  FilledButton(
                    onPressed: onActionPressed,
                    child: Text(actionLabel!),
                  ),
                if (secondaryActionLabel != null &&
                    onSecondaryActionPressed != null)
                  OutlinedButton(
                    onPressed: onSecondaryActionPressed,
                    child: Text(secondaryActionLabel!),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}
