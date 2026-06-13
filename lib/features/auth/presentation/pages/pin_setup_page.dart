import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_providers.dart';
import '../widgets/pin_code_field.dart';

class PinSetupPage extends ConsumerStatefulWidget {
  const PinSetupPage({super.key});

  @override
  ConsumerState<PinSetupPage> createState() => _PinSetupPageState();
}

class _PinSetupPageState extends ConsumerState<PinSetupPage> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();
  final FocusNode _confirmPinFocusNode = FocusNode();
  String? _errorKey;

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    _pinFocusNode.dispose();
    _confirmPinFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    final String pin = _pinController.text;
    final String confirmPin = _confirmPinController.text;

    if (pin.length != 6 || confirmPin.length != 6) {
      setState(() => _errorKey = 'pin_must_be_six_digits');
      return;
    }

    if (pin != confirmPin) {
      setState(() => _errorKey = 'pins_do_not_match');
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .setPin(pin, promptForBiometricSetup: true);

    if (!mounted || result.isSuccess) {
      return;
    }

    setState(() => _errorKey = result.message);
  }

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authControllerProvider).isBusy;
    final ThemeData theme = Theme.of(context);

    return Scaffold(
      body: DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: <Color>[AppColors.canvasTop, AppColors.canvasBottom],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 440),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Text(
                      context.tr.createPinTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.tr.createPinSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    Text(
                      context.tr.newPin,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PinCodeField(
                      controller: _pinController,
                      focusNode: _pinFocusNode,
                      autofocus: true,
                      textInputAction: TextInputAction.next,
                      onSubmitted: (_) => _confirmPinFocusNode.requestFocus(),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      context.tr.confirmPin,
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PinCodeField(
                      controller: _confirmPinController,
                      focusNode: _confirmPinFocusNode,
                      textInputAction: TextInputAction.done,
                      onSubmitted: (_) => _submit(),
                    ),
                    if (_errorKey != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        _resolveError(context, _errorKey!),
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xxl),
                    PwButton.primary(
                      label: context.tr.continueLabel,
                      isLoading: isLoading,
                      onPressed: _submit,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _resolveError(BuildContext context, String key) {
    return switch (key) {
      'pin_must_be_six_digits' => context.tr.pinMustBeSixDigits,
      'pins_do_not_match' => context.tr.pinsDoNotMatch,
      _ => context.tr.somethingWentWrong,
    };
  }
}
