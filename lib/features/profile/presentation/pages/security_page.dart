import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../app/presentation/widgets/app_modal_bottom_sheet.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_radius.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../auth/domain/enums/lock_timeout_option.dart';
import '../../../auth/domain/models/biometric_capability.dart';
import '../../../auth/presentation/providers/auth_providers.dart';

class SecurityPage extends ConsumerWidget {
  const SecurityPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final String biometricLabel = _resolveBiometricLabel(
      context,
      authState.biometricCapability,
    );
    final bool canToggleBiometric =
        authState.isPinConfigured &&
        (authState.biometricCapability.canAuthenticate ||
            authState.isBiometricEnabled);

    return PwScaffold(
      title: context.tr.securitySection,
      body: ListView(
        padding: const EdgeInsets.only(bottom: AppSpacing.xxl),
        children: <Widget>[
          _SecuritySection(
            title: context.tr.enablePin,
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(context.tr.enablePin),
                  subtitle: Text(
                    authState.isPinConfigured
                        ? context.tr.pinEnabledDescription
                        : context.tr.pinDisabledDescription,
                  ),
                  value: authState.isPinConfigured,
                  onChanged: (bool value) {
                    if (value) {
                      _showPinManagementSheet(context, ref, isCreating: true);
                      return;
                    }
                    _showDisablePinSheet(context, ref);
                  },
                ),
                const Divider(height: 1),
                _SecurityTile(
                  icon: Icons.pin_rounded,
                  title: context.tr.changePin,
                  value: authState.isPinConfigured ? null : context.tr.notAdded,
                  onTap: authState.isPinConfigured
                      ? () => _showPinManagementSheet(
                          context,
                          ref,
                          isCreating: false,
                        )
                      : () => _showPinManagementSheet(
                          context,
                          ref,
                          isCreating: true,
                        ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SecuritySection(
            title: context.tr.enableBiometrics,
            child: SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: Text(context.tr.enableBiometrics),
              subtitle: Text(biometricLabel),
              value: authState.isBiometricEnabled,
              onChanged: canToggleBiometric
                  ? (bool value) async {
                      final result = await ref
                          .read(authControllerProvider.notifier)
                          .toggleBiometricLogin(value);

                      if (!context.mounted) {
                        return;
                      }

                      if (result.isSuccess) {
                        showAppSuccessSnackBar(
                          context,
                          _resolveAuthMessage(context, result.message),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _resolveAuthMessage(context, result.message),
                          ),
                        ),
                      );
                    }
                  : null,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          _SecuritySection(
            title: context.tr.lockTimeout,
            child: Column(
              children: <Widget>[
                _SecurityTile(
                  icon: Icons.timer_outlined,
                  title: context.tr.lockTimeout,
                  value: _lockTimeoutLabel(context, authState.lockTimeout),
                  onTap: () => _showSingleChoiceSheet<LockTimeoutOption>(
                    context,
                    title: context.tr.lockTimeout,
                    options: <_SelectionOption<LockTimeoutOption>>[
                      _SelectionOption(
                        value: LockTimeoutOption.immediate,
                        label: context.tr.lockImmediately,
                      ),
                      _SelectionOption(
                        value: LockTimeoutOption.seconds30,
                        label: context.tr.lockAfter30Seconds,
                      ),
                      _SelectionOption(
                        value: LockTimeoutOption.minute1,
                        label: context.tr.lockAfter1Minute,
                      ),
                      _SelectionOption(
                        value: LockTimeoutOption.minutes5,
                        label: context.tr.lockAfter5Minutes,
                      ),
                    ],
                    selectedValue: authState.lockTimeout,
                    onSelected: (LockTimeoutOption value) async {
                      final result = await ref
                          .read(authControllerProvider.notifier)
                          .setLockTimeout(value);

                      if (!context.mounted) {
                        return;
                      }

                      if (result.isSuccess) {
                        showAppSuccessSnackBar(
                          context,
                          _resolveAuthMessage(context, result.message),
                        );
                        return;
                      }

                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            _resolveAuthMessage(context, result.message),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SecuritySection extends StatelessWidget {
  const _SecuritySection({required this.title, required this.child});

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

class _SecurityTile extends StatelessWidget {
  const _SecurityTile({
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

Future<void> _showSingleChoiceSheet<T>(
  BuildContext context, {
  required String title,
  required List<_SelectionOption<T>> options,
  required T selectedValue,
  required Future<void> Function(T) onSelected,
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
    await onSelected(result);
  }
}

class _SelectionOption<T> {
  const _SelectionOption({required this.value, required this.label});

  final T value;
  final String label;
}

Future<void> _showDisablePinSheet(BuildContext context, WidgetRef ref) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _DisablePinSheet(ref: ref);
    },
  );
}

Future<void> _showPinManagementSheet(
  BuildContext context,
  WidgetRef ref, {
  required bool isCreating,
}) {
  return showAppModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return _PinManagementSheet(ref: ref, isCreating: isCreating);
    },
  );
}

class _DisablePinSheet extends ConsumerStatefulWidget {
  const _DisablePinSheet({required this.ref});

  final WidgetRef ref;

  @override
  ConsumerState<_DisablePinSheet> createState() => _DisablePinSheetState();
}

class _DisablePinSheetState extends ConsumerState<_DisablePinSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentPinController;

  @override
  void initState() {
    super.initState();
    _currentPinController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .disablePin(currentPin: _currentPinController.text);

    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      showAppSuccessSnackBar(
        context,
        _resolveAuthMessage(context, result.message),
      );
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_resolveAuthMessage(context, result.message))),
    );
  }

  String? _validateCurrentPin(String? value) {
    if ((value ?? '').isEmpty) {
      return context.tr.pinRequired;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider).isBusy;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                context.tr.disablePin,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                context.tr.disablePinDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              PwTextField(
                controller: _currentPinController,
                label: context.tr.currentPin,
                obscureText: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: _validateCurrentPin,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PwButton.primary(
                  label: context.tr.disablePin,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _PinManagementSheet extends ConsumerStatefulWidget {
  const _PinManagementSheet({required this.ref, required this.isCreating});

  final WidgetRef ref;
  final bool isCreating;

  @override
  ConsumerState<_PinManagementSheet> createState() =>
      _PinManagementSheetState();
}

class _PinManagementSheetState extends ConsumerState<_PinManagementSheet> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  late final TextEditingController _currentPinController;
  late final TextEditingController _newPinController;
  late final TextEditingController _confirmPinController;

  @override
  void initState() {
    super.initState();
    _currentPinController = TextEditingController();
    _newPinController = TextEditingController();
    _confirmPinController = TextEditingController();
  }

  @override
  void dispose() {
    _currentPinController.dispose();
    _newPinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final FormState? form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    final result = widget.isCreating
        ? await ref
              .read(authControllerProvider.notifier)
              .setPin(_newPinController.text, promptForBiometricSetup: true)
        : await ref
              .read(authControllerProvider.notifier)
              .changePin(
                currentPin: _currentPinController.text,
                newPin: _newPinController.text,
              );

    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      showAppSuccessSnackBar(
        context,
        _resolveAuthMessage(context, result.message),
      );
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_resolveAuthMessage(context, result.message))),
    );
  }

  String? _validateCurrentPin(String? value) {
    if (!widget.isCreating && (value ?? '').isEmpty) {
      return context.tr.pinRequired;
    }
    return null;
  }

  String? _validateNewPin(String? value) {
    final String normalized = value ?? '';
    if (normalized.isEmpty) {
      return context.tr.pinRequired;
    }
    if (normalized.length != 6) {
      return context.tr.pinMustBeSixDigits;
    }
    if (!widget.isCreating && normalized == _currentPinController.text) {
      return context.tr.newPinMustDiffer;
    }
    return null;
  }

  String? _validateConfirmationPin(String? value) {
    if ((value ?? '').isEmpty) {
      return context.tr.confirmPinRequired;
    }
    if (value != _newPinController.text) {
      return context.tr.pinsDoNotMatch;
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider).isBusy;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      behavior: HitTestBehavior.opaque,
      child: Padding(
        padding: EdgeInsets.only(
          left: AppSpacing.md,
          right: AppSpacing.md,
          top: AppSpacing.sm,
          bottom: MediaQuery.viewInsetsOf(context).bottom + AppSpacing.md,
        ),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Text(
                widget.isCreating
                    ? context.tr.createPinTitle
                    : context.tr.changePin,
                style: Theme.of(
                  context,
                ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w800),
              ),
              const SizedBox(height: AppSpacing.xs),
              Text(
                widget.isCreating
                    ? context.tr.createPinSubtitle
                    : context.tr.changePinDescription,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              if (!widget.isCreating) ...<Widget>[
                PwTextField(
                  controller: _currentPinController,
                  label: context.tr.currentPin,
                  obscureText: true,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: _validateCurrentPin,
                ),
                const SizedBox(height: AppSpacing.md),
              ],
              PwTextField(
                controller: _newPinController,
                label: context.tr.newPin,
                obscureText: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.next,
                validator: _validateNewPin,
              ),
              const SizedBox(height: AppSpacing.md),
              PwTextField(
                controller: _confirmPinController,
                label: context.tr.confirmPin,
                obscureText: true,
                keyboardType: TextInputType.number,
                textInputAction: TextInputAction.done,
                validator: _validateConfirmationPin,
                onFieldSubmitted: (_) => _submit(),
              ),
              const SizedBox(height: AppSpacing.lg),
              SizedBox(
                width: double.infinity,
                child: PwButton.primary(
                  label: context.tr.saveChanges,
                  isLoading: isLoading,
                  onPressed: _submit,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

String _lockTimeoutLabel(BuildContext context, LockTimeoutOption value) {
  return switch (value) {
    LockTimeoutOption.immediate => context.tr.lockImmediately,
    LockTimeoutOption.seconds30 => context.tr.lockAfter30Seconds,
    LockTimeoutOption.minute1 => context.tr.lockAfter1Minute,
    LockTimeoutOption.minutes5 => context.tr.lockAfter5Minutes,
  };
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
    'lock_timeout_updated' => context.tr.lockTimeoutUpdated,
    _ => context.tr.somethingWentWrong,
  };
}

String _resolveBiometricLabel(
  BuildContext context,
  BiometricCapability capability,
) {
  if (!capability.canAuthenticate) {
    return context.tr.notAvailable;
  }
  if (capability.hasSingleFaceOnly) {
    return context.tr.faceId;
  }
  if (capability.hasSingleFingerprintOnly) {
    return context.tr.fingerprint;
  }
  return context.tr.available;
}
