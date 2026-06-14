import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/presentation/providers/app_preferences_provider.dart';
import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../app/router/app_routes.dart';
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
    final String? emailAddress = user?.emailAddress;
    final String fullName = _resolvedValue(
      user?.displayName,
      context.tr.notAdded,
    );
    return Scaffold(
      appBar: AppBar(title: Text(context.tr.profileTitle)),
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.lg,
          AppSpacing.xxl + MediaQuery.paddingOf(context).bottom,
        ),
        children: <Widget>[
          _ProfileHeader(
            name: fullName,
            email: emailAddress,
            profileImageUri: user?.profileImageUri,
            onTap: () => context.pushNamed(AppRoutes.profileAccount),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: context.tr.financialPreferencesSection,
            child: Column(
              children: <Widget>[
                _NavigationTile(
                  icon: Icons.attach_money_rounded,
                  title: context.tr.defaultCurrency,
                  value: preferences.defaultCurrencyCode,
                  onTap: () => _showSingleChoiceSheet<String>(
                    context,
                    title: context.tr.defaultCurrency,
                    options: const <_SelectionOption<String>>[
                      _SelectionOption(value: 'USD', label: 'USD'),
                      _SelectionOption(value: 'SYP', label: 'SYP'),
                    ],
                    selectedValue: preferences.defaultCurrencyCode,
                    onSelected: (String value) {
                      ref
                          .read(appPreferencesProvider.notifier)
                          .setDefaultCurrencyCode(value);
                    },
                  ),
                ),
                const Divider(height: 1),
                _NavigationTile(
                  icon: Icons.event_note_rounded,
                  title: context.tr.dateFormatSetting,
                  value: preferences.dateFormatPattern,
                  onTap: () => _showSingleChoiceSheet<String>(
                    context,
                    title: context.tr.dateFormatSetting,
                    options: const <_SelectionOption<String>>[
                      _SelectionOption(
                        value: 'DD/MM/YYYY',
                        label: 'DD/MM/YYYY',
                      ),
                      _SelectionOption(
                        value: 'MM/DD/YYYY',
                        label: 'MM/DD/YYYY',
                      ),
                    ],
                    selectedValue: preferences.dateFormatPattern,
                    onSelected: (String value) {
                      ref
                          .read(appPreferencesProvider.notifier)
                          .setDateFormatPattern(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: context.tr.preferencesSection,
            child: Column(
              children: <Widget>[
                _PreferenceToggleTile(
                  icon: Icons.translate_rounded,
                  title: context.tr.language,
                  value: preferences.locale.languageCode == 'ar'
                      ? context.tr.arabic
                      : context.tr.english,
                  onTap: () {
                    final String nextLanguageCode =
                        preferences.locale.languageCode == 'ar' ? 'en' : 'ar';
                    ref
                        .read(appPreferencesProvider.notifier)
                        .setLanguageCode(nextLanguageCode);
                  },
                ),
                const Divider(height: 1),
                _PreferenceToggleTile(
                  icon: preferences.themeMode == ThemeMode.dark
                      ? Icons.dark_mode_rounded
                      : Icons.light_mode_rounded,
                  title: context.tr.theme,
                  value: preferences.themeMode == ThemeMode.dark
                      ? context.tr.dark
                      : context.tr.light,
                  onTap: () {
                    final ThemeMode nextThemeMode = _nextThemeMode(
                      preferences.themeMode,
                      Theme.of(context).brightness,
                    );
                    ref
                        .read(appPreferencesProvider.notifier)
                        .setThemeMode(nextThemeMode);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: context.tr.contacts,
            child: Column(
              children: <Widget>[
                _NavigationTile(
                  icon: Icons.people_alt_outlined,
                  title: context.tr.manageContacts,
                  onTap: () => context.push(AppRoutes.contactsPath),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: context.tr.securitySection,
            child: Column(
              children: <Widget>[
                _NavigationTile(
                  icon: Icons.shield_outlined,
                  title: context.tr.securitySection,
                  onTap: () => context.pushNamed(AppRoutes.security),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _ProfileSection(
            title: context.tr.applicationSection,
            child: Column(
              children: <Widget>[
                _NavigationTile(
                  icon: Icons.privacy_tip_outlined,
                  title: context.tr.privacyPolicy,
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(context.tr.comingSoon)),
                    );
                  },
                ),
                const Divider(height: 1),
                _InfoTile(
                  label: context.tr.version,
                  value: '1.0.0+1',
                  icon: Icons.tag_rounded,
                  isSecondary: true,
                ),
                const Divider(height: 1),
                _NavigationTile(
                  icon: Icons.logout_rounded,
                  title: context.tr.logout,
                  onTap: () async {
                    final ScaffoldMessengerState? messenger =
                        ScaffoldMessenger.maybeOf(context);
                    final String successMessage = _resolveAuthMessage(
                      context,
                      'logged_out_successfully',
                    );
                    final String fallbackErrorMessage =
                        context.tr.somethingWentWrong;
                    final result = await ref
                        .read(authControllerProvider.notifier)
                        .logout();

                    if (messenger == null || !messenger.mounted) {
                      return;
                    }

                    messenger.showSnackBar(
                      SnackBar(
                        content: Text(
                          result.isSuccess
                              ? successMessage
                              : fallbackErrorMessage,
                        ),
                      ),
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

Future<void> _showSingleChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<_SelectionOption<T>> options,
  required T selectedValue,
  required ValueChanged<T> onSelected,
}) async {
  final T? result = await showAppModalBottomSheet<T>(
    context: context,
    builder: (BuildContext context) {
      return SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.md,
            0,
            AppSpacing.md,
            AppSpacing.md,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.sm),
              ...options.map(
                (_SelectionOption<T> option) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(option.label),
                  trailing: option.value == selectedValue
                      ? Icon(
                          Icons.check_rounded,
                          color: Theme.of(context).colorScheme.primary,
                        )
                      : null,
                  onTap: () => Navigator.of(context).pop(option.value),
                ),
              ),
            ],
          ),
        ),
      );
    },
  );

  if (result != null) {
    onSelected(result);
  }
}

class _SelectionOption<T> {
  const _SelectionOption({required this.value, required this.label});

  final T value;
  final String label;
}

class _PreferenceToggleTile extends StatelessWidget {
  const _PreferenceToggleTile({
    required this.icon,
    required this.title,
    required this.value,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;

    return ListTile(
      contentPadding: EdgeInsets.zero,
      onTap: onTap,
      leading: Container(
        width: 38,
        height: 38,
        decoration: BoxDecoration(
          color: colorScheme.primary.withValues(alpha: 0.10),
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        alignment: Alignment.center,
        child: Icon(icon, size: 18, color: colorScheme.primary),
      ),
      title: Text(
        title,
        style: theme.textTheme.titleSmall?.copyWith(
          fontWeight: FontWeight.w700,
        ),
      ),
      subtitle: Padding(
        padding: const EdgeInsets.only(top: 2),
        child: Text(
          value,
          style: theme.textTheme.bodySmall?.copyWith(
            color: colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      trailing: Icon(
        Icons.autorenew_rounded,
        size: 20,
        color: colorScheme.onSurfaceVariant,
      ),
    );
  }
}

class _ProfileHeader extends StatelessWidget {
  const _ProfileHeader({
    required this.name,
    required this.email,
    required this.profileImageUri,
    required this.onTap,
  });

  final String name;
  final String? email;
  final String? profileImageUri;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final ColorScheme colorScheme = theme.colorScheme;
    final File? imageFile = _resolvedImageFile(profileImageUri);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: Ink(
          decoration: BoxDecoration(
            color: theme.cardColor,
            borderRadius: BorderRadius.circular(AppRadius.lg),
            border: Border.all(
              color: colorScheme.outline.withValues(alpha: 0.12),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 24,
                  backgroundColor: colorScheme.primary.withValues(alpha: 0.12),
                  backgroundImage: imageFile == null
                      ? null
                      : FileImage(imageFile),
                  child: imageFile != null
                      ? null
                      : Text(
                          _initialsFromName(name),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: colorScheme.primary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: theme.textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      if ((email ?? '').trim().isNotEmpty) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          email!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(
                  Icons.chevron_right_rounded,
                  color: colorScheme.onSurfaceVariant,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
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
    this.isSecondary = false,
  });

  final String label;
  final String value;
  final IconData icon;
  final bool isSecondary;

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
      subtitleTextStyle:
          (isSecondary ? theme.textTheme.bodySmall : theme.textTheme.bodyMedium)
              ?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: isSecondary ? FontWeight.w600 : FontWeight.w500,
              ),
    );
  }
}

class _NavigationTile extends StatelessWidget {
  const _NavigationTile({
    required this.icon,
    required this.title,
    required this.onTap,
    this.value,
  });

  final IconData icon;
  final String title;
  final String? value;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Icon(icon),
      title: Text(title),
      subtitle: value == null
          ? null
          : Text(
              value!,
              style: theme.textTheme.bodySmall?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
      trailing: const Icon(Icons.chevron_right_rounded),
      onTap: onTap,
    );
  }
}

String _resolvedValue(String? value, String fallback) {
  final String? normalized = value?.trim();
  if (normalized == null || normalized.isEmpty) {
    return fallback;
  }
  return normalized;
}

String _initialsFromName(String value) {
  final List<String> parts = value
      .trim()
      .split(RegExp(r'\s+'))
      .where((String item) => item.isNotEmpty)
      .toList(growable: false);
  if (parts.isEmpty || value == '--') {
    return '--';
  }
  if (parts.length == 1) {
    return parts.first
        .substring(0, parts.first.length >= 2 ? 2 : 1)
        .toUpperCase();
  }
  return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
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

ThemeMode _nextThemeMode(ThemeMode current, Brightness activeBrightness) {
  if (current == ThemeMode.light) {
    return ThemeMode.dark;
  }
  if (current == ThemeMode.dark) {
    return ThemeMode.light;
  }
  return activeBrightness == Brightness.dark ? ThemeMode.light : ThemeMode.dark;
}

String _resolveAuthMessage(BuildContext context, String key) {
  return switch (key) {
    'biometric_enabled_successfully' => context.tr.biometricEnabledSuccessfully,
    'biometric_disabled_successfully' =>
      context.tr.biometricDisabledSuccessfully,
    'biometric_auth_failed' => context.tr.biometricAuthFailed,
    'biometric_not_available' => context.tr.biometricNotAvailable,
    'pin_changed_successfully' => context.tr.pinChangedSuccessfully,
    'pin_disabled_successfully' => context.tr.pinDisabledSuccessfully,
    'pin_saved_successfully' => context.tr.pinSavedSuccessfully,
    'current_pin_invalid' => context.tr.currentPinInvalid,
    'pin_setup_required' => context.tr.pinSetupRequired,
    'profile_updated_successfully' => context.tr.profileUpdatedSuccessfully,
    'logged_out_successfully' => context.tr.loggedOutSuccessfully,
    'lock_timeout_updated' => context.tr.lockTimeoutUpdated,
    _ => context.tr.somethingWentWrong,
  };
}
