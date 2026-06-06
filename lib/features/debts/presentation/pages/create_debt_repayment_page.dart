import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/design_system/widgets/pw_text_field.dart';
import '../../../../core/theme/app_spacing.dart';
import '../providers/debt_providers.dart';

class CreateDebtRepaymentPage extends ConsumerStatefulWidget {
  const CreateDebtRepaymentPage({required this.debtId, super.key});

  final String debtId;

  @override
  ConsumerState<CreateDebtRepaymentPage> createState() =>
      _CreateDebtRepaymentPageState();
}

class _CreateDebtRepaymentPageState
    extends ConsumerState<CreateDebtRepaymentPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final bool success = await ref
        .read(debtControllerProvider.notifier)
        .createRepayment(
          debtId: widget.debtId,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(debtControllerProvider).errorMessage ??
              'Failed to record repayment.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);

    return PwScaffold(
      title: 'Record Repayment',
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 680),
          child: PwSectionCard(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.xl),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    PwTextField(
                      controller: _amountController,
                      label: 'Amount',
                      keyboardType: TextInputType.number,
                      validator: (String? value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Amount is required.';
                        }
                        final num? parsed = num.tryParse(value.trim());
                        if (parsed == null || parsed <= 0) {
                          return 'Enter a valid amount.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: AppSpacing.md),
                    TextFormField(
                      controller: _noteController,
                      maxLines: 3,
                      decoration: const InputDecoration(labelText: 'Note'),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    PwButton.primary(
                      label: 'Save repayment',
                      isLoading: debtState.isLoading,
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
}
