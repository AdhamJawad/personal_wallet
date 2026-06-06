import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../transactions/presentation/providers/transaction_providers.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/transfer_draft.dart';
import '../providers/transfer_providers.dart';
import '../widgets/transfer_page_shell.dart';

class TransferConfirmationPage extends ConsumerWidget {
  const TransferConfirmationPage({required this.draft, super.key});

  final TransferDraft? draft;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferControllerProvider);
    final TransferDraft? flowDraft = draft;

    if (flowDraft == null) {
      return const TransferPageShell(
        title: 'Confirm Transfer',
        child: Center(child: Text('Transfer draft not found.')),
      );
    }

    return TransferPageShell(
      title: 'Confirm Transfer',
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            'Review the transfer details before creating the immutable ledger entry.',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: AppSpacing.lg),
          _SummaryRow(label: 'From wallet', value: flowDraft.senderWalletName),
          _SummaryRow(label: 'Recipient', value: flowDraft.recipientDisplayName),
          _SummaryRow(
            label: 'Amount',
            value:
                '${AmountFormatter.format(flowDraft.amount)} ${flowDraft.currency.name.toUpperCase()}',
          ),
          _SummaryRow(label: 'Note', value: flowDraft.note ?? 'None'),
          const SizedBox(height: AppSpacing.xl),
          Row(
            children: <Widget>[
              Expanded(
                child: PwButton.secondary(
                  label: 'Back',
                  onPressed: () => context.pop(),
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: PwButton.primary(
                  label: 'Confirm transfer',
                  isLoading: transferState.isLoading,
                  onPressed: () async {
                    final bool success = await ref
                        .read(transferControllerProvider.notifier)
                        .createTransfer(
                          senderWalletId: flowDraft.senderWalletId,
                          recipientUserId: flowDraft.recipientUserId,
                          recipientDisplayName: flowDraft.recipientDisplayName,
                          currency: flowDraft.currency,
                          amount: flowDraft.amount,
                          note: flowDraft.note,
                        );

                    if (!context.mounted) {
                      return;
                    }

                    if (!success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            ref.read(transferControllerProvider).errorMessage ??
                                'Transfer failed.',
                          ),
                        ),
                      );
                      return;
                    }

                    await ref.read(walletControllerProvider.notifier).initialize();
                    await ref
                        .read(transactionControllerProvider.notifier)
                        .initialize();

                    if (!context.mounted) {
                      return;
                    }

                    context.go(AppRoutes.userTransferSuccessPath);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 160, child: Text(label)),
          Expanded(child: Text(value, style: context.bodyLarge)),
        ],
      ),
    );
  }
}
