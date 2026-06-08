import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../debts/domain/models/debt_summary.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../transactions/presentation/widgets/transaction_form_text_field.dart';
import '../../../transactions/presentation/widgets/transaction_form_validators.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/debt_settlement_draft.dart';
import '../providers/transfer_providers.dart';
import '../widgets/transfer_page_shell.dart';

class DebtSettlementPage extends ConsumerStatefulWidget {
  const DebtSettlementPage({required this.debtId, super.key});

  final String debtId;

  @override
  ConsumerState<DebtSettlementPage> createState() => _DebtSettlementPageState();
}

class _DebtSettlementPageState extends ConsumerState<DebtSettlementPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _noteController = TextEditingController();
  String? _walletId;

  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(debtControllerProvider.notifier).loadDebt(widget.debtId);
    });
  }

  @override
  void dispose() {
    _amountController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _submit(DebtSummary summary, WalletOverview wallet) async {
    final DebtSettlementDraft draft = DebtSettlementDraft(
      debtId: summary.debt.id,
      debtContactName: summary.contact.name,
      senderWalletId: wallet.wallet.id,
      senderWalletName: wallet.wallet.name,
      recipientUserId: summary.contact.linkedUserId!,
      recipientDisplayName: summary.contact.name,
      currency: summary.currency,
      amount: _amountController.text.trim(),
      remainingAmountBeforeSettlement: summary.remainingAmount,
      note: _noteController.text.trim().isEmpty ? null : _noteController.text.trim(),
    );

    final bool success = await ref
        .read(transferControllerProvider.notifier)
        .createDebtSettlement(
          debtId: draft.debtId,
          senderWalletId: draft.senderWalletId,
          recipientUserId: draft.recipientUserId,
          recipientDisplayName: draft.recipientDisplayName,
          currency: draft.currency,
          amount: draft.amount,
          note: draft.note,
        );

    if (!mounted) {
      return;
    }

    if (!success) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            ref.read(transferControllerProvider).errorMessage ??
                'Debt settlement failed.',
          ),
        ),
      );
      return;
    }

    await ref.read(debtControllerProvider.notifier).loadDebt(summary.debt.id);
    await ref.read(walletControllerProvider.notifier).initialize();
    await ref.read(transactionControllerProvider.notifier).initialize();

    if (!mounted) {
      return;
    }

    context.go(AppRoutes.debtSettlementSuccessLocation(summary.debt.id));
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);
    final transferState = ref.watch(transferControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final DebtSummary? summary = debtState.selectedDebt;
    final List<WalletOverview> activeWallets = walletState.wallets
        .where((WalletOverview item) => !item.wallet.isArchived)
        .toList(growable: false);

    return TransferPageShell(
      title: 'Debt Settlement',
      child: debtState.isLoading && summary == null
          ? const Center(child: CircularProgressIndicator())
          : summary == null
          ? const Text('Debt not found.')
          : summary.contact.linkedUserId == null
          ? Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                const Text(
                  'This debt belongs to an external contact. Transfer-backed settlement is available only for registered users.',
                ),
                const SizedBox(height: AppSpacing.lg),
                PwButton.primary(
                  label: 'Back to debt details',
                  onPressed: () => context.pop(),
                ),
              ],
            )
          : Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'Settlement will reduce the debt and create a linked financial transfer.',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    'Remaining debt: ${AmountFormatter.format(summary.remainingAmount)} ${summary.currency.name.toUpperCase()}',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  DropdownButtonFormField<String>(
                    initialValue: _walletId,
                    decoration: const InputDecoration(labelText: 'Sender wallet'),
                    items: activeWallets
                        .map(
                          (WalletOverview item) => DropdownMenuItem<String>(
                            value: item.wallet.id,
                            child: Text(item.wallet.name),
                          ),
                        )
                        .toList(growable: false),
                    onChanged: (String? value) => setState(() => _walletId = value),
                    validator: (String? value) =>
                        value == null ? 'Sender wallet is required.' : null,
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TransactionFormTextField(
                    controller: _amountController,
                    label: 'Settlement amount',
                    keyboardType: TextInputType.number,
                    validator: (String? value) {
                      final String? basic = amountValidator(context, value);
                      if (basic != null) {
                        return basic;
                      }
                      final num requested = num.tryParse(value!.trim()) ?? 0;
                      final num remaining =
                          num.tryParse(summary.remainingAmount) ?? 0;
                      if (requested > remaining) {
                        return 'Settlement cannot exceed remaining debt.';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: AppSpacing.md),
                  TransactionFormTextField(
                    controller: _noteController,
                    label: 'Note',
                    maxLines: 3,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  PwButton.primary(
                    label: 'Settle debt',
                    isLoading: transferState.isLoading,
                    onPressed: () {
                      if (!_formKey.currentState!.validate() || _walletId == null) {
                        return;
                      }
                      final WalletOverview wallet = activeWallets.firstWhere(
                        (WalletOverview item) => item.wallet.id == _walletId,
                      );
                      _submit(summary, wallet);
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
