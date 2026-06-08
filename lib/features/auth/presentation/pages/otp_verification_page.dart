import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/auth_providers.dart';
import '../widgets/auth_page_shell.dart';

class OtpVerificationPage extends ConsumerStatefulWidget {
  const OtpVerificationPage({super.key});

  @override
  ConsumerState<OtpVerificationPage> createState() =>
      _OtpVerificationPageState();
}

class _OtpVerificationPageState extends ConsumerState<OtpVerificationPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _otpController = TextEditingController();

  @override
  void dispose() {
    _otpController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final result = await ref
        .read(authControllerProvider.notifier)
        .verifyOtp(otpCode: _otpController.text.trim());

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
    final phoneNumber =
        authState.pendingVerification?.phoneNumber ?? context.tr.yourPhone;

    return AuthPageShell(
      title: context.tr.verifyOtp,
      subtitle: context.tr.verifyOtpSubtitle(phoneNumber),
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
              child: Text(context.tr.mockOtp),
            ),
            const SizedBox(height: AppSpacing.lg),
            PwTextField(
              controller: _otpController,
              label: context.tr.otpCode,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.done,
              maxLength: 6,
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
              validator: (String? value) {
                if (value == null || value.trim().isEmpty) {
                  return context.tr.otpCodeRequired;
                }
                if (value.trim().length != 6) {
                  return context.tr.otpMustBeSixDigits;
                }
                return null;
              },
              onFieldSubmitted: (_) => _submit(),
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: context.tr.verifyAndContinue,
              isLoading: authState.isBusy,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
