import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../shared/domain/enums/contact_kind.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../contacts/domain/models/contact.dart';
import '../../../contacts/presentation/providers/contact_providers.dart';
import '../../../transactions/presentation/widgets/transaction_form_text_field.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/transfer_draft.dart';
import '../widgets/transfer_page_shell.dart';

class TransferPage extends ConsumerStatefulWidget {
  const TransferPage({
    this.preselectedRecipientUserId,
    this.preselectedRecipientName,
    super.key,
  });

  final String? preselectedRecipientUserId;
  final String? preselectedRecipientName;

  @override
  ConsumerState<TransferPage> createState() => _TransferPageState();
}

class _TransferPageState extends ConsumerState<TransferPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _senderWalletId;
  String? _recipientUserId;
  String? _recipientDisplayName;
  Currency _currency = Currency.usd;

  @override
  void initState() {
    super.initState();
    _recipientUserId = widget.preselectedRecipientUserId;
    _recipientDisplayName = widget.preselectedRecipientName;
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  void _submit(List<WalletOverview> activeWallets, List<Contact> registeredContacts) {
    if (!_formKey.currentState!.validate() ||
        _senderWalletId == null ||
        _recipientUserId == null ||
        _recipientDisplayName == null) {
      return;
    }

    final WalletOverview wallet = activeWallets.firstWhere(
      (WalletOverview item) => item.wallet.id == _senderWalletId,
    );
    final TransferDraft draft = TransferDraft(
      senderWalletId: wallet.wallet.id,
      senderWalletName: wallet.wallet.name,
      recipientUserId: _recipientUserId!,
      recipientDisplayName: _recipientDisplayName!,
      currency: _currency,
      amount: _amountController.text.trim(),
      note: _noteController.text.trim().isEmpty
          ? null
          : _noteController.text.trim(),
    );

    context.push(AppRoutes.userTransferConfirmationPath, extra: draft);
  }

  @override
  Widget build(BuildContext context) {
    final walletState = ref.watch(walletControllerProvider);
    final contactState = ref.watch(contactControllerProvider);
    final List<WalletOverview> activeWallets = walletState.wallets
        .where((WalletOverview item) => !item.wallet.isArchived)
        .toList(growable: false);
    final List<Contact> registeredContacts = contactState.contacts
        .where(
          (Contact item) =>
              item.kind == ContactKind.registered && item.linkedUserId != null,
        )
        .toList(growable: false);
    final bool hasPreselectedRecipient =
        widget.preselectedRecipientUserId != null &&
        widget.preselectedRecipientName != null;

    return TransferPageShell(
      title: 'Send Money',
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              'Create a standard user-to-user transfer. Debt balances are not affected unless you use debt settlement.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            const SizedBox(height: AppSpacing.lg),
            DropdownButtonFormField<String>(
              initialValue: _senderWalletId,
              decoration: const InputDecoration(labelText: 'Sender wallet'),
              items: activeWallets
                  .map(
                    (WalletOverview item) => DropdownMenuItem<String>(
                      value: item.wallet.id,
                      child: Text(item.wallet.name),
                    ),
                  )
                  .toList(growable: false),
              onChanged: (String? value) => setState(() => _senderWalletId = value),
              validator: (String? value) =>
                  value == null ? 'Sender wallet is required.' : null,
            ),
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<String>(
              initialValue: _recipientUserId,
              decoration: const InputDecoration(labelText: 'Recipient user'),
              items: <DropdownMenuItem<String>>[
                if (hasPreselectedRecipient)
                  DropdownMenuItem<String>(
                    value: widget.preselectedRecipientUserId,
                    child: Text(widget.preselectedRecipientName!),
                  ),
                ...registeredContacts
                    .where(
                      (Contact item) =>
                          item.linkedUserId != widget.preselectedRecipientUserId,
                    )
                    .map(
                      (Contact item) => DropdownMenuItem<String>(
                        value: item.linkedUserId,
                        child: Text(item.name),
                      ),
                    ),
              ],
              onChanged: (String? value) {
                final Contact? contact = registeredContacts.cast<Contact?>().firstWhere(
                  (Contact? item) => item?.linkedUserId == value,
                  orElse: () => null,
                );
                setState(() {
                  _recipientUserId = value;
                  _recipientDisplayName =
                      contact?.name ?? widget.preselectedRecipientName;
                });
              },
              validator: (String? value) =>
                  value == null ? 'Recipient user is required.' : null,
            ),
            if (registeredContacts.isEmpty && !hasPreselectedRecipient) ...<Widget>[
              const SizedBox(height: AppSpacing.sm),
              Text(
                'No registered contacts yet. Add one from Contacts or scan a QR identity.',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
            const SizedBox(height: AppSpacing.md),
            DropdownButtonFormField<Currency>(
              initialValue: _currency,
              decoration: const InputDecoration(labelText: 'Currency'),
              items: Currency.values
                  .map(
                    (Currency currency) => DropdownMenuItem<Currency>(
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
              label: 'Review transfer',
              onPressed: activeWallets.isEmpty ? null : () => _submit(activeWallets, registeredContacts),
            ),
          ],
        ),
      ),
    );
  }
}
