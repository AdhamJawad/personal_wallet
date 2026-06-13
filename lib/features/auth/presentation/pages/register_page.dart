import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/localization/localization_extensions.dart';
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
  final TextEditingController _emailController = TextEditingController();

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
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
          emailAddress: _emailController.text.trim().isEmpty
              ? null
              : _emailController.text.trim(),
        );

    if (!mounted || result.isSuccess) {
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(_resolveMessage(context, result.message))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authControllerProvider);

    return AuthPageShell(
      title: context.tr.createAccount,
      subtitle: context.tr.registerPhoneSubtitle,
      footer: Center(
        child: TextButton(
          onPressed: () => context.go(AppRoutes.loginPath),
          child: Text(context.tr.backToSignIn),
        ),
      ),
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
              controller: _emailController,
              label: context.tr.emailAddressOptional,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: context.tr.continueLabel,
              isLoading: authState.isBusy,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  String _resolveMessage(BuildContext context, String key) {
    return switch (key) {
      'otp_sent_successfully' => context.tr.otpSentSuccessfully,
      'phone_already_registered' => context.tr.phoneAlreadyRegistered,
      _ => context.tr.somethingWentWrong,
    };
  }
}
