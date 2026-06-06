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

class CreateExchangePage extends ConsumerStatefulWidget {
  const CreateExchangePage({super.key});

  @override
  ConsumerState<CreateExchangePage> createState() => _CreateExchangePageState();
}

class _CreateExchangePageState extends ConsumerState<CreateExchangePage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountGivenController = TextEditingController();
  final TextEditingController _exchangeRateController = TextEditingController();
  final TextEditingController _amountReceivedController =
      TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  final TextEditingController _attachmentController = TextEditingController();
  String? _walletId;
  Currency _sourceCurrency = Currency.usd;
  Currency _destinationCurrency = Currency.syp;

  @override
  void dispose() {
    _amountGivenController.dispose();
    _exchangeRateController.dispose();
    _amountReceivedController.dispose();
    _noteController.dispose();
    _attachmentController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate() || _walletId == null) {
      return;
    }

    if (_sourceCurrency == _destinationCurrency) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Source and destination currencies must be different.'),
        ),
      );
      return;
    }

    final bool success = await ref
        .read(transactionControllerProvider.notifier)
        .createExchange(
          walletId: _walletId!,
          sourceCurrency: _sourceCurrency,
          destinationCurrency: _destinationCurrency,
          amountGiven: _amountGivenController.text.trim(),
          exchangeRate: _exchangeRateController.text.trim(),
          amountReceived: _amountReceivedController.text.trim(),
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
              'Failed to create exchange.',
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final transactionState = ref.watch(transactionControllerProvider);

    return TransactionPageShell(
      title: 'Create Exchange',
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
            Row(
              children: <Widget>[
                Expanded(
                  child: DropdownButtonFormField<Currency>(
                    initialValue: _sourceCurrency,
                    decoration: const InputDecoration(
                      labelText: 'Source currency',
                    ),
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
                        setState(() => _sourceCurrency = value);
                      }
                    },
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: DropdownButtonFormField<Currency>(
                    initialValue: _destinationCurrency,
                    decoration: const InputDecoration(
                      labelText: 'Destination currency',
                    ),
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
                        setState(() => _destinationCurrency = value);
                      }
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _amountGivenController,
              label: 'Amount given',
              keyboardType: TextInputType.number,
              validator: amountValidator,
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _exchangeRateController,
              label: 'Exchange rate',
              keyboardType: TextInputType.number,
              validator: amountValidator,
            ),
            const SizedBox(height: AppSpacing.md),
            TransactionFormTextField(
              controller: _amountReceivedController,
              label: 'Amount received',
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
            ),
            const SizedBox(height: AppSpacing.lg),
            PwButton.primary(
              label: 'Save exchange',
              isLoading: transactionState.isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }
}
