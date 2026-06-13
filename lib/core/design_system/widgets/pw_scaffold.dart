import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';

class PwScaffold extends StatelessWidget {
  const PwScaffold({
    required this.title,
    required this.body,
    this.actions,
    super.key,
  });

  final String title;
  final Widget body;
  final List<Widget>? actions;

  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(title, style: context.titleMedium),
        actions: actions,
      ),
      body: DecoratedBox(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: isDark
                ? <Color>[AppColors.brandDark, AppColors.surfaceDark]
                : <Color>[AppColors.canvasTop, AppColors.canvasBottom],
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: body,
        ),
      ),
    );
  }
}
