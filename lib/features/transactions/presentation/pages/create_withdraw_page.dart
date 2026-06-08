import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_form_text_field.dart';
import '../widgets/transaction_form_validators.dart';
import '../widgets/transaction_page_shell.dart';

class CreateWithdrawPage extends ConsumerStatefulWidget {
  const CreateWithdrawPage({super.key});

  @override
  ConsumerState<CreateWithdrawPage> createState() => _CreateWithdrawPageState();
}

class _CreateWithdrawPageState extends ConsumerState<CreateWithdrawPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();
  String? _walletId;
  Currency _currency = Currency.usd;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _walletId == null) {
      return;
    }

    final bool success = await ref
        .read(transactionControllerProvider.notifier)
        .createWithdraw(
          walletId: _walletId!,
          currency: _currency,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
          attachmentLabel: _attachmentController.text.trim().isEmpty
              ? null
              : _attachmentController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    if (success) {
      ref.read(walletControllerProvider.notifier).initialize();
      Navigator.of(context).pop();
      return;
    }

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          ref.read(transactionControllerProvider).errorMessage ??
              context.tr.failedCreateWithdrawal,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);

    return TransactionPageShell(
      title: context.tr.createWithdrawTitle,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              initialValue: _walletId,
              decoration: InputDecoration(labelText: context.tr.wallet),
              items: walletState.wallets
                  .where((item) => !item.wallet.isArchived)
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.wallet.id,
                      child: Text(item.wallet.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? value) {
                setState(() => _walletId = value);
              },
              validator: (String? value) =>
                  value == null ? context.tr.walletRequired : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<Currency>(
              initialValue: _currency,
              decoration: InputDecoration(labelText: context.tr.currency),
              items: Currency.values
                  .map(
                    (Currency currency) => DropdownMenuItem(
                      value: currency,
                      child: Text(currency.name.toUpperCase()),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (Currency? value) {
                if (value != null) {
                  setState(() => _currency = value);
                }
              },
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _amountController,
              label: context.tr.amount,
              keyboardType: TextInputType.number,
              validator: (String? value) => amountValidator(context, value),
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _noteController,
              label: context.tr.note,
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _attachmentController,
              label: context.tr.attachmentLabel,
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: context.tr.saveWithdrawal,
              isLoading: transactionState.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
