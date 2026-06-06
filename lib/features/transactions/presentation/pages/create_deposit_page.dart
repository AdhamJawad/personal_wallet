import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_form_text_field.dart';
import '../widgets/transaction_form_validators.dart';
import '../widgets/transaction_page_shell.dart';

class CreateDepositPage extends ConsumerStatefulWidget {
  const CreateDepositPage({super.key});

  @override
  ConsumerState<CreateDepositPage> createState() => _CreateDepositPageState();
}

class _CreateDepositPageState extends ConsumerState<CreateDepositPage> {
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
        .createDeposit(
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
              'Failed to create deposit.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);

    return TransactionPageShell(
      title: 'Create Deposit',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              initialValue: _walletId,
              decoration: const InputDecoration(labelText: 'Wallet'),
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
                  value == null ? 'Wallet is required.' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<Currency>(
              initialValue: _currency,
              decoration: const InputDecoration(labelText: 'Currency'),
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
              label: 'Amount',
              keyboardType: TextInputType.number,
              validator: amountValidator,
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _noteController,
              label: 'Note',
              maxLines: 3,
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _attachmentController,
              label: 'Attachment label',
              hint: 'receipt.jpg',
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: 'Save deposit',
              isLoading: transactionState.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
