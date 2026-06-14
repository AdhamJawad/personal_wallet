import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page_shell.dart';

class ForgotPasswordPage extends ConsumerStatefulWidget {
  const ForgotPasswordPage({super.key});

  @override
  ConsumerState<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends ConsumerState<ForgotPasswordPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void dispose() {
    _phoneController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .requestPinReset(phoneNumber: _phoneController.text.trim());

    if (!mounted) {
      return;
    }

    if (result.isSuccess) {
      showAppSuccessSnackBar(context, _resolveMessage(context, result.message));
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
      title: context.tr.resetPinTitle,
      subtitle: context.tr.resetPinSubtitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            PwTextField(
              controller: _phoneController,
              label: context.tr.phoneNumber,
              keyboardType: TextInputType.phone,
              textInputAction: TextInputAction.done,
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr.phoneNumberRequired;
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: context.tr.sendOtp,
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
      'phone_not_registered' => context.tr.phoneNotRegistered,
      _ => context.tr.somethingWentWrong,
    };
  }
}
