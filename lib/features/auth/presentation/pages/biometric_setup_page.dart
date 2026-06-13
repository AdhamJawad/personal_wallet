import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_providers.dart';

class BiometricSetupPage extends ConsumerWidget {
  const BiometricSetupPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final ThemeData theme = Theme.of(context);
    final IconData biometricIcon =
        authState.biometricCapability.hasSingleFaceOnly
        ? Icons.face_retouching_natural_rounded
        : Icons.fingerprint_rounded;

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
                    Icon(
                      biometricIcon,
                      size: 68,
                      color: theme.colorScheme.primary,
                    ),
                    const SizedBox(height: AppSpacing.xl),
                    Text(
                      context.tr.enableBiometricsTitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    Text(
                      context.tr.enableBiometricsSubtitle,
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppSpacing.xxl),
                    PwButton.primary(
                      label: context.tr.enableBiometrics,
                      isLoading: authState.isBusy,
                      onPressed: () async {
                        final result = await ref
                            .read(authControllerProvider.notifier)
                            .toggleBiometricLogin(true);

                        if (!context.mounted || result.isSuccess) {
                          return;
                        }

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              _resolveMessage(context, result.message),
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    PwButton.secondary(
                      label: context.tr.later,
                      onPressed: () {
                        ref
                            .read(authControllerProvider.notifier)
                            .skipBiometricSetup();
                      },
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

  String _resolveMessage(BuildContext context, String key) {
    return switch (key) {
      'biometric_auth_failed' => context.tr.biometricAuthFailed,
      'biometric_not_available' => context.tr.biometricNotAvailable,
      _ => context.tr.somethingWentWrong,
    };
  }
}
