import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../controllers/auth_state.dart';
import '../providers/auth_providers.dart';
import '../widgets/pin_code_field.dart';

class UnlockPage extends ConsumerStatefulWidget {
  const UnlockPage({super.key});

  @override
  ConsumerState<UnlockPage> createState() => _UnlockPageState();
}

class _UnlockPageState extends ConsumerState<UnlockPage> {
  final TextEditingController _pinController = TextEditingController();
  bool _didAttemptBiometric = false;
  String? _errorKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _tryBiometric());
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _submitPin() async {
    if (_pinController.text.length != 6) {
      setState(() => _errorKey = 'pin_must_be_six_digits');
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .unlockWithPin(_pinController.text);

    if (!mounted) {
      return;
    }

    if (!result.isSuccess) {
      _pinController.clear();
      setState(() => _errorKey = result.message);
    }
  }

  Future<void> _tryBiometric() async {
    final authState = ref.read(authControllerProvider);
    if (_didAttemptBiometric || !authState.canUseBiometricUnlock) {
      return;
    }

    _didAttemptBiometric = true;
    final result = await ref
        .read(authControllerProvider.notifier)
        .unlockWithBiometrics();

    if (!mounted || result.isSuccess) {
      return;
    }

    setState(() => _errorKey = result.message);
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);
    final ThemeData theme = Theme.of(context);
    final String? errorText = _resolveMessage(context, _errorKey);

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
                constraints: const BoxConstraints(maxWidth: 420),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: 76,
                      height: 76,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary.withValues(
                          alpha: 0.14,
                        ),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Icon(
                        Icons.account_balance_wallet_rounded,
                        size: 34,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      context.tr.unlockWelcomeBack,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      authState.session?.user.displayName ?? context.tr.appName,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    PinCodeField(
                      controller: _pinController,
                      autofocus: true,
                      onCompleted: (_) => _submitPin(),
                    ),
                    if (errorText != null) ...<Widget>[
                      const SizedBox(height: AppSpacing.md),
                      Text(
                        errorText,
                        textAlign: TextAlign.center,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: theme.colorScheme.error,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                    const SizedBox(height: AppSpacing.xl),
                    if (authState.canUseBiometricUnlock)
                      IconButton.filledTonal(
                        onPressed: _tryBiometric,
                        icon: Icon(_resolveBiometricIcon(authState)),
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

  IconData _resolveBiometricIcon(AuthState authState) {
    if (authState.biometricCapability.hasSingleFaceOnly) {
      return Icons.face_retouching_natural_rounded;
    }
    return Icons.fingerprint_rounded;
  }

  String? _resolveMessage(BuildContext context, String? key) {
    return switch (key) {
      'pin_invalid' => context.tr.pinInvalid,
      'pin_must_be_six_digits' => context.tr.pinMustBeSixDigits,
      'biometric_auth_failed' => context.tr.biometricAuthFailed,
      _ => null,
    };
  }
}
