import 'package:flutter/material.dart';

import '../../theme/app_spacing.dart';
import '../../theme/app_text_styles.dart';
import 'pw_scaffold.dart';
import 'pw_section_card.dart';

class PwPlaceholderView extends StatelessWidget {
  const PwPlaceholderView({
    required this.title,
    required this.description,
    super.key,
  });

  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return PwScaffold(
      title: title,
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: PwSectionCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: context.titleLarge),
                  const SizedBox(height: AppSpacing.md),
                  Text(description, style: context.bodyLarge),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
