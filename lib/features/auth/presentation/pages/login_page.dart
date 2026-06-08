import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page_shell.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController(
    text: '+963999999999',
  );
  final TextEditingController _passwordController = TextEditingController(
    text: '123456',
  );

  @override
  void dispose() {
    _phoneController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .login(
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted || result.isSuccess) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
  }

  Future<void> _submitBiometricLogin() async {
    final result = await ref
        .read(authControllerProvider.notifier)
        .loginWithBiometrics();

    if (!mounted || result.isSuccess) {
      return;
    }

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(result.message)));
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return AuthPageShell(
      title: context.tr.welcomeBack,
      subtitle: context.tr.loginSubtitle,
      footer: Center(
        child: TextButton(
          onPressed: () => context.go(AppRoutes.registerPath),
          child: Text(context.tr.createNewAccount),
        ),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Container(
              padding: const EdgeInsets.all(AppSpacing.md),
              decoration: BoxDecoration(
                color: AppColors.canvasTop,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Text(context.tr.mockLoginCredentials),
            ),
            const SizedBox(height: AppSpacing.lg),
            PwTextField(
              controller: _phoneController,
              label: context.tr.phoneNumber,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr.phoneNumberRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PwTextField(
              controller: _passwordController,
              label: context.tr.password,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return context.tr.passwordRequired;
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: () => context.go(AppRoutes.forgotPasswordPath),
                child: Text(context.tr.forgotPassword),
              ),
            ),
            const SizedBox(height: AppSpacing.sm),
            PwButton.primary(
              label: context.tr.signIn,
              isLoading: authState.isBusy,
              onPressed: _submit,
            ),
            if (authState.canUseBiometricLogin) ...<Widget>[
              const SizedBox(height: AppSpacing.md),
              PwButton.secondary(
                label: context.tr.useBiometricLogin,
                isLoading: authState.isBusy,
                onPressed: _submitBiometricLogin,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
