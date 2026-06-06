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

class CreateTransferPage extends ConsumerStatefulWidget {
  const CreateTransferPage({super.key});

  @override
  ConsumerState<CreateTransferPage> createState() => _CreateTransferPageState();
}

class _CreateTransferPageState extends ConsumerState<CreateTransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _sourceWalletId;
  String? _destinationWalletId;
  Currency _currency = Currency.usd;

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() ||
        _sourceWalletId == null ||
        _destinationWalletId == null) {
      return;
    }

    if (_sourceWalletId == _destinationWalletId) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Source and destination wallets must be different.'),
        ),
      );
      return;
    }

    final bool success = await ref
        .read(transactionControllerProvider.notifier)
        .createTransfer(
          sourceWalletId: _sourceWalletId!,
          destinationWalletId: _destinationWalletId!,
          currency: _currency,
          amount: _amountController.text.trim(),
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
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
              'Failed to create transfer.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);
    final activeWallets = walletState.wallets
        .where((item) => !item.wallet.isArchived)
        .toList(growable: false);

    return TransactionPageShell(
      title: 'Create Internal Transfer',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            DropdownButtonFormField<String>(
              initialValue: _sourceWalletId,
              decoration: const InputDecoration(labelText: 'Source wallet'),
              items: activeWallets
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.wallet.id,
                      child: Text(item.wallet.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? value) {
                setState(() => _sourceWalletId = value);
              },
              validator: (String? value) =>
                  value == null ? 'Source wallet is required.' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _destinationWalletId,
              decoration: const InputDecoration(
                labelText: 'Destination wallet',
              ),
              items: activeWallets
                  .map(
                    (item) => DropdownMenuItem(
                      value: item.wallet.id,
                      child: Text(item.wallet.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? value) {
                setState(() => _destinationWalletId = value);
              },
              validator: (String? value) =>
                  value == null ? 'Destination wallet is required.' : null,
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
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: 'Save transfer',
              isLoading: transactionState.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
