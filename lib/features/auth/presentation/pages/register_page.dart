import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page_shell.dart';

class RegisterPage extends ConsumerStatefulWidget {
  const RegisterPage({super.key});

  @override
  ConsumerState<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends ConsumerState<RegisterPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .register(
          fullName: _fullNameController.text.trim(),
          phoneNumber: _phoneController.text.trim(),
          password: _passwordController.text,
        );

    if (!mounted) {
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
      title: context.tr.createAccount,
      subtitle: context.tr.registerSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PwTextField(
              controller: _fullNameController,
              label: context.tr.fullName,
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr.fullNameRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
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
              textInputAction: TextInputAction.next,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return context.tr.passwordRequired;
                }
                return null;
              },
            ),
            const SizedBox(height: AppSpacing.md),
            PwTextField(
              controller: _confirmPasswordController,
              label: context.tr.confirmPassword,
              obscureText: true,
              textInputAction: TextInputAction.done,
              validator: (String? value) {
                if (value == null || value.isEmpty) {
                  return context.tr.confirmPasswordRequired;
                }
                if (value != _passwordController.text) {
                  return context.tr.passwordsDoNotMatch;
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: context.tr.continueToOtp,
              isLoading: authState.isBusy,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
