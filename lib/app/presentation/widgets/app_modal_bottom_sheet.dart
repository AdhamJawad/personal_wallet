import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

Future<T?> showAppModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isScrollControlled = false,
  bool useSafeArea = true,
  bool showDragHandle = true,
  Color? backgroundColor,
  ShapeBorder? shape,
}) {
  return showModalBottomSheet<T>(
    context: context,
    useRootNavigator: true,
    isScrollControlled: isScrollControlled,
    useSafeArea: useSafeArea,
    showDragHandle: showDragHandle,
    backgroundColor: backgroundColor ?? Colors.transparent,
    barrierColor: Colors.black.withValues(alpha: 0.45),
    elevation: 24,
    shape:
        shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
    builder: (BuildContext context) {
      final ColorScheme colorScheme = Theme.of(context).colorScheme;
      return Material(
        color: backgroundColor ?? colorScheme.surface,
        elevation: 24,
        shadowColor: AppColors.shadow,
        shape:
            shape ??
            const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.xl),
              ),
            ),
        clipBehavior: Clip.antiAlias,
        child: builder(context),
      );
    },
  );
}
