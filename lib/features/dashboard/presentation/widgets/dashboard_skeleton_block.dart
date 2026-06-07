import 'package:flutter/material.dart';

import '../../../../core/theme/app_radius.dart';

class DashboardSkeletonBlock extends StatelessWidget {
  const DashboardSkeletonBlock({
    required this.height,
    this.width,
    this.radius = AppRadius.md,
    super.key,
  });

  final double height;
  final double? width;
  final double radius;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool isDark = theme.brightness == Brightness.dark;

    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: isDark
            ? Colors.white.withValues(alpha: 0.08)
            : Colors.black.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}
