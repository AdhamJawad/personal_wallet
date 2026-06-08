import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import 'dashboard_skeleton_block.dart';
import 'dashboard_surface_card.dart';

class DashboardQuickActionItem {
  const DashboardQuickActionItem({
    required this.label,
    required this.icon,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback onTap;
}

class DashboardQuickActions extends StatelessWidget {
  const DashboardQuickActions({
    required this.actions,
    this.isLoading = false,
    super.key,
  });

  final List<DashboardQuickActionItem> actions;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const DashboardSurfaceCard(
        padding: EdgeInsets.all(AppSpacing.lg),
        child: Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: <Widget>[
            _QuickActionSkeletonChip(),
            _QuickActionSkeletonChip(),
            _QuickActionSkeletonChip(),
            _QuickActionSkeletonChip(),
            _QuickActionSkeletonChip(),
          ],
        ),
      );
    }

    final bool compactLayout = MediaQuery.sizeOf(context).width < 390;
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return DashboardSurfaceCard(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Wrap(
        spacing: AppSpacing.sm,
        runSpacing: AppSpacing.sm,
        children: actions
            .map(
              (DashboardQuickActionItem action) => _QuickActionButton(
                action: action,
                compactLayout: compactLayout,
                isArabic: isArabic,
              ),
            )
            .toList(growable: false),
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.action,
    required this.compactLayout,
    required this.isArabic,
  });

  final DashboardQuickActionItem action;
  final bool compactLayout;
  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: action.onTap,
        borderRadius: BorderRadius.circular(AppRadius.pill),
        child: Ink(
          padding: EdgeInsets.symmetric(
            horizontal: compactLayout ? AppSpacing.sm : AppSpacing.md,
            vertical: compactLayout ? AppSpacing.sm : 10,
          ),
          decoration: BoxDecoration(
            color: colorScheme.primary.withValues(alpha: 0.07),
            borderRadius: BorderRadius.circular(AppRadius.pill),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.10),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                action.label,
                style: theme.textTheme.labelLarge?.copyWith(
                  fontWeight: FontWeight.w700,
                  fontSize: isArabic ? 13 : null,
                ),
              ),
              SizedBox(width: compactLayout ? AppSpacing.sm : AppSpacing.md),
              Container(
                width: compactLayout ? 28 : 30,
                height: compactLayout ? 28 : 30,
                decoration: BoxDecoration(
                  color: colorScheme.primary,
                  borderRadius: BorderRadius.circular(AppRadius.pill),
                ),
                alignment: Alignment.center,
                child: Icon(
                  action.icon,
                  color: colorScheme.onPrimary,
                  size: 16,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionSkeletonChip extends StatelessWidget {
  const _QuickActionSkeletonChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.pill),
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          DashboardSkeletonBlock(height: 12, width: 54),
          SizedBox(width: AppSpacing.md),
          DashboardSkeletonBlock(height: 30, width: 30, radius: AppRadius.pill),
        ],
      ),
    );
  }
}
