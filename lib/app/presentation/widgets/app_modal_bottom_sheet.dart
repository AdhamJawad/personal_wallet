import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';

const double appModalTabletBreakpoint = 600;
const double appModalMaxWidth = 720;
const double appModalHorizontalMargin = 16;

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
    constraints: _modalConstraints(context),
    shape:
        shape ??
        const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(AppRadius.xl),
          ),
        ),
    builder: (BuildContext context) {
      final ColorScheme colorScheme = Theme.of(context).colorScheme;
      final BoxConstraints? modalConstraints = _modalConstraints(context);
      final Widget sheet = Material(
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

      return Align(
        alignment: Alignment.bottomCenter,
        child: modalConstraints == null
            ? sheet
            : ConstrainedBox(constraints: modalConstraints, child: sheet),
      );
    },
  );
}

BoxConstraints? _modalConstraints(BuildContext context) {
  final double width = MediaQuery.sizeOf(context).width;
  if (width < appModalTabletBreakpoint) {
    return null;
  }

  return BoxConstraints(
    maxWidth: (width - (appModalHorizontalMargin * 2)).clamp(
      0,
      appModalMaxWidth,
    ),
  );
}
