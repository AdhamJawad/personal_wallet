import 'package:flutter/material.dart';

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
        ? const SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
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
