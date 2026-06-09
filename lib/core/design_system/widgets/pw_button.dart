import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';

class PwButton extends StatelessWidget {
  const PwButton.primary({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  }) : _isSecondary = false;

  const PwButton.secondary({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    super.key,
  }) : _isSecondary = true;

  final String label;
  final VoidCallback? onPressed;
  final bool isLoading;
  final bool _isSecondary;

  @override
  Widget build(BuildContext context) {
    final Widget child = isLoading
        ? const Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              _PwButtonLoadingBar(),
              SizedBox(width: AppSpacing.sm),
              _PwButtonLoadingBar(isShort: true),
            ],
          )
        : Text(label);

    if (_isSecondary) {
      return OutlinedButton(
        onPressed: isLoading ? null : onPressed,
        child: child,
      );
    }

    return FilledButton(onPressed: isLoading ? null : onPressed, child: child);
  }
}

class _PwButtonLoadingBar extends StatelessWidget {
  const _PwButtonLoadingBar({this.isShort = false});

  final bool isShort;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: isShort ? 18 : 30,
      height: 10,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(999),
      ),
    );
  }
}
