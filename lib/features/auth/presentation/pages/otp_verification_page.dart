import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/feedback/app_feedback.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/enums/otp_flow_type.dart';
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
    final pendingOtpFlow = authState.pendingOtpFlow;
    final phoneNumber = pendingOtpFlow?.phoneNumber ?? context.tr.yourPhone;
    final OtpFlowType? flowType = pendingOtpFlow?.type;

    return AuthPageShell(
      title: context.tr.verifyOtp,
      subtitle: _resolveSubtitle(context, flowType, phoneNumber),
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

  String _resolveMessage(BuildContext context, String key) {
    return switch (key) {
      'otp_invalid' => context.tr.otpInvalid,
      'login_successful' => context.tr.loginSuccessful,
      'registration_completed' => context.tr.registrationCompleted,
      'pin_reset_verified' => context.tr.pinResetVerified,
      'otp_context_missing' => context.tr.otpContextMissing,
      'phone_not_registered' => context.tr.phoneNotRegistered,
      _ => context.tr.somethingWentWrong,
    };
  }

  String _resolveSubtitle(
    BuildContext context,
    OtpFlowType? type,
    String phoneNumber,
  ) {
    return switch (type) {
      OtpFlowType.pinReset => context.tr.resetPinOtpSubtitle(phoneNumber),
      OtpFlowType.signUp => context.tr.verifyOtpSubtitle(phoneNumber),
      _ => context.tr.signInOtpSubtitle(phoneNumber),
    };
  }
}
