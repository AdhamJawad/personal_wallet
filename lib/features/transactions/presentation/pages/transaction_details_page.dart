import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/ledger_transaction.dart';
import '../providers/transaction_providers.dart';

class TransactionDetailsPage extends ConsumerStatefulWidget {
  const TransactionDetailsPage({required this.transactionId, super.key});

  final String transactionId;

  @override
  ConsumerState<TransactionDetailsPage> createState() =>
      _TransactionDetailsPageState();
}

class _TransactionDetailsPageState
    extends ConsumerState<TransactionDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref
          .read(transactionControllerProvider.notifier)
          .loadTransaction(widget.transactionId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final transactionState = ref.watch(transactionControllerProvider);
    final walletState = ref.watch(walletControllerProvider);
    final LedgerTransaction? transaction = transactionState.selectedTransaction;

    String resolveWalletName(String? walletId) {
      final WalletOverview? wallet = walletState.wallets
          .cast<WalletOverview?>()
          .firstWhere(
            (WalletOverview? item) => item?.wallet.id == walletId,
            orElse: () => null,
          );
      return wallet?.wallet.name ?? 'Unknown wallet';
    }

    String walletValue() {
      if (transaction == null) {
        return '';
      }
      if (transaction.type.name == 'deposit') {
        return resolveWalletName(transaction.destinationWalletId);
      }
      return resolveWalletName(transaction.sourceWalletId);
    }

    return PwScaffold(
      title: 'Transaction Details',
      body: transactionState.isLoading && transaction == null
          ? const Center(child: CircularProgressIndicator())
          : transaction == null
          ? const Center(child: Text('Transaction not found.'))
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: Text(
                                transaction.reference.value,
                                style: context.titleLarge,
                              ),
                            ),
                            TextButton(
                              onPressed: () => context.push(
                                '${AppRoutes.attachmentViewerPath}?entityType=transaction&entityId=${Uri.encodeComponent(transaction.id)}&label=${Uri.encodeComponent(transaction.reference.value)}',
                              ),
                              child: const Text('Attachments'),
                            ),
                          ],
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        _DetailRow(
                          label: 'Date',
                          value: DateFormatter.full(transaction.createdAt),
                        ),
                        _DetailRow(
                          label: 'Type',
                          value: _typeLabel(transaction),
                        ),
                        _DetailRow(label: 'Wallet', value: walletValue()),
                        if (transaction.destinationWalletId != null &&
                            transaction.recipientUserId == null &&
                            transaction.sourceWalletId != null)
                          _DetailRow(
                            label: 'Destination wallet',
                            value: resolveWalletName(
                              transaction.destinationWalletId,
                            ),
                          ),
                        if (transaction.recipientDisplayName != null)
                          _DetailRow(
                            label: 'Recipient',
                            value: transaction.recipientDisplayName!,
                          ),
                        if (transaction.senderDisplayName != null &&
                            transaction.sourceWalletId == null)
                          _DetailRow(
                            label: 'Sender',
                            value: transaction.senderDisplayName!,
                          ),
                        _DetailRow(
                          label: 'Amount',
                          value:
                              '${AmountFormatter.format(transaction.sourceAmount)} ${transaction.sourceCurrency.name.toUpperCase()}',
                        ),
                        if (transaction.destinationCurrency != null &&
                            transaction.destinationAmount != null)
                          _DetailRow(
                            label: 'Received',
                            value:
                                '${AmountFormatter.format(transaction.destinationAmount!)} ${transaction.destinationCurrency!.name.toUpperCase()}',
                          ),
                        if ((transaction.exchangeRate ?? '').isNotEmpty)
                          _DetailRow(
                            label: 'Exchange rate',
                            value: transaction.exchangeRate!,
                          ),
                        if (transaction.transferRecordId != null)
                          _DetailRow(
                            label: 'Transfer id',
                            value: transaction.transferRecordId!,
                          ),
                        if (transaction.debtSettlementId != null)
                          _DetailRow(
                            label: 'Settlement id',
                            value: transaction.debtSettlementId!,
                          ),
                        if ((transaction.note ?? '').isNotEmpty)
                          _DetailRow(label: 'Notes', value: transaction.note!),
                        _DetailRow(
                          label: 'Attachment',
                          value: transaction.attachmentLabel ?? 'None',
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  String _typeLabel(LedgerTransaction transaction) {
    if (transaction.type.name != 'transfer') {
      return transaction.type.name.toUpperCase();
    }
    if (transaction.recipientUserId == null) {
      return 'INTERNAL TRANSFER';
    }
    return transaction.debtSettlementId == null
        ? 'USER TRANSFER'
        : 'DEBT SETTLEMENT TRANSFER';
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(width: 180, child: Text(label)),
          Expanded(child: Text(value, style: context.bodyLarge)),
        ],
      ),
    );
  }
}
