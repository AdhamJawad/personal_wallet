import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

SnackBar buildAppSuccessSnackBar(BuildContext context, String message) {
  return SnackBar(
    behavior: SnackBarBehavior.floating,
    backgroundColor: AppColors.success,
    content: Row(
      children: <Widget>[
        const Icon(Icons.check_circle_rounded, color: Colors.white),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    ),
  );
}

void showAppSuccessSnackBar(BuildContext context, String message) {
  final ScaffoldMessengerState? messenger = ScaffoldMessenger.maybeOf(context);
  if (messenger == null) {
    return;
  }
  messenger
    ..hideCurrentSnackBar()
    ..showSnackBar(buildAppSuccessSnackBar(context, message));
}
