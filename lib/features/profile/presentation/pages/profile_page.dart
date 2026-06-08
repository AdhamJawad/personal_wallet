import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/providers/app_preferences_provider.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final preferences = ref.watch(appPreferencesProvider);
    final session = authState.session;
    final user = session?.user;
    final String biometricLabel = authState.biometricCapability.hasFaceId
        ? context.tr.faceId
        : authState.biometricCapability.hasFingerprint
        ? context.tr.fingerprint
        : context.tr.notAvailable;

    return Scaffold(
      appBar: AppBar(title: Text(context.tr.profileTitle)),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.lg),
        children: <Widget>[
            _ProfileSection(
              title: context.tr.accountSection,
              child: Column(
                children: <Widget>[
                  _InfoTile(
                    label: context.tr.displayName,
                    value: user?.displayName ?? context.tr.userFallback,
                    icon: Icons.badge_rounded,
                  ),
                  const Divider(height: 1),
                  _InfoTile(
                    label: context.tr.userIdentifier,
                    value: user?.id ?? '--',
                    icon: Icons.tag_rounded,
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ProfileSection(
              title: context.tr.securitySection,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(context.tr.biometricLogin),
                    subtitle: Text(biometricLabel),
                    value: authState.isBiometricLoginEnabled,
                    onChanged: (bool value) async {
                      final result = await ref
                          .read(authControllerProvider.notifier)
                          .toggleBiometricLogin(value);

                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    },
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.password_rounded),
                    title: Text(context.tr.changePassword),
                    subtitle: Text(context.tr.comingSoon),
                    trailing: const Icon(Icons.chevron_right_rounded),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(context.tr.comingSoon)),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ProfileSection(
              title: context.tr.preferencesSection,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text(
                    context.tr.language,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<String>(
                    showSelectedIcon: false,
                    segments: <ButtonSegment<String>>[
                      ButtonSegment<String>(
                        value: 'en',
                        label: Text(context.tr.english),
                      ),
                      ButtonSegment<String>(
                        value: 'ar',
                        label: Text(context.tr.arabic),
                      ),
                    ],
                    selected: <String>{preferences.locale.languageCode},
                    onSelectionChanged: (Set<String> selection) {
                      ref
                          .read(appPreferencesProvider.notifier)
                          .setLanguageCode(selection.first);
                    },
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    context.tr.theme,
                    textAlign: TextAlign.right,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  SegmentedButton<ThemeMode>(
                    showSelectedIcon: false,
                    segments: <ButtonSegment<ThemeMode>>[
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.light,
                        label: Text(context.tr.light),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.dark,
                        label: Text(context.tr.dark),
                      ),
                      ButtonSegment<ThemeMode>(
                        value: ThemeMode.system,
                        label: Text(context.tr.system),
                      ),
                    ],
                    selected: <ThemeMode>{preferences.themeMode},
                    onSelectionChanged: (Set<ThemeMode> selection) {
                      ref
                          .read(appPreferencesProvider.notifier)
                          .setThemeMode(selection.first);
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            _ProfileSection(
              title: context.tr.applicationSection,
              child: Column(
                children: <Widget>[
                  _InfoTile(
                    label: context.tr.version,
                    value: '1.0.0+1',
                    icon: Icons.info_outline_rounded,
                  ),
                  const Divider(height: 1),
                  ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: const Icon(Icons.logout_rounded),
                    title: Text(context.tr.logout),
                    onTap: () async {
                      final result = await ref
                          .read(authControllerProvider.notifier)
                          .logout();

                      if (!context.mounted) {
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text(result.message)),
                      );
                    },
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.title,
    required this.child,
  });

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        Text(
          title,
          textAlign: TextAlign.right,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: AppSpacing.md),
        DecoratedBox(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: theme.colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: child,
          ),
        ),
      ],
    );
  }
}

class _InfoTile extends StatelessWidget {
  const _InfoTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(label),
      subtitle: Text(value),
      titleTextStyle: theme.textTheme.titleSmall?.copyWith(
        color: theme.colorScheme.onSurface,
        fontWeight: FontWeight.w700,
      ),
      subtitleTextStyle: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
      ),
    );
  }
}
