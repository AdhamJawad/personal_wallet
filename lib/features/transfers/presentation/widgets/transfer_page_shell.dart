import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';

class TransferPageShell extends StatelessWidget {
  const TransferPageShell({
    required this.title,
    required this.child,
    super.key,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return PwScaffold(
      title: title,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: PwSectionCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}
