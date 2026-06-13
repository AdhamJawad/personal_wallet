import 'dart:io';

import 'package:flutter/material.dart';
import '../../../../core/theme/app_spacing.dart';

class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    required this.greeting,
    required this.userName,
    this.profileImageUri,
    super.key,
  });

  final String greeting;
  final String userName;
  final String? profileImageUri;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final String initials = _resolveInitials(userName);
    final File? imageFile = _resolvedImageFile(profileImageUri);
    final bool isArabic = Localizations.localeOf(context).languageCode == 'ar';

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          width: 58,
          height: 58,
          padding: const EdgeInsets.all(3),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: colorScheme.primary.withValues(alpha: 0.16),
            ),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: colorScheme.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(19),
            ),
            child: Stack(
              children: <Widget>[
                Center(
                  child: imageFile == null
                      ? Text(
                          initials,
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        )
                      : ClipRRect(
                          borderRadius: BorderRadius.circular(19),
                          child: Image.file(
                            imageFile,
                            width: double.infinity,
                            height: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                ),
                PositionedDirectional(
                  end: 6,
                  bottom: 6,
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: const Color(0xFF1D9C5A),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: theme.scaffoldBackgroundColor,
                        width: 1.6,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Flexible(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                greeting,
                textAlign: TextAlign.right,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                userName,
                textAlign: TextAlign.right,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  letterSpacing: isArabic ? 0 : -0.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  String _resolveInitials(String value) {
    final List<String> parts = value
        .trim()
        .split(RegExp(r'\s+'))
        .where((String item) => item.isNotEmpty)
        .toList(growable: false);

    if (parts.isEmpty) {
      return 'U';
    }

    if (parts.length == 1) {
      return parts.first.characters.first.toUpperCase();
    }

    return '${parts.first.characters.first}${parts.last.characters.first}'
        .toUpperCase();
  }

  File? _resolvedImageFile(String? path) {
    final String normalized = (path ?? '').trim();
    if (normalized.isEmpty) {
      return null;
    }
    final File file = File(normalized);
    if (!file.existsSync()) {
      return null;
    }
    return file;
  }
}
