import 'package:flutter/material.dart';

import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../domain/models/ledger_transaction.dart';

class TransactionListCard extends StatelessWidget {
  const TransactionListCard({
    required this.transaction,
    required this.walletNameResolver,
    this.onTap,
    super.key,
  });

  final LedgerTransaction transaction;
  final String Function(String? walletId) walletNameResolver;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return PwSectionCard(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(24),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.lg),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          transaction.reference.value,
                          style: context.titleMedium,
                        ),
                        const SizedBox(height: AppSpacing.xs),
                        Text(_transactionTypeLabel(transaction)),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.md,
                      vertical: AppSpacing.sm,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.canvasTop,
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '${AmountFormatter.format(transaction.sourceAmount)} ${transaction.sourceCurrency.name.toUpperCase()}',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.md),
              Text(_walletSummary()),
              const SizedBox(height: AppSpacing.sm),
              Text(DateFormatter.full(transaction.createdAt)),
              if ((transaction.note ?? '').isNotEmpty) ...<Widget>[
                const SizedBox(height: AppSpacing.sm),
                Text(transaction.note!),
              ],
            ],
          ),
        ),
      ),
    );
  }

  String _walletSummary() {
    switch (transaction.type) {
      case TransactionType.deposit:
        return 'To ${walletNameResolver(transaction.destinationWalletId)}';
      case TransactionType.withdraw:
        return 'From ${walletNameResolver(transaction.sourceWalletId)}';
      case TransactionType.transfer:
        if (transaction.recipientUserId != null) {
          if (transaction.sourceWalletId != null) {
            return '${walletNameResolver(transaction.sourceWalletId)} -> ${transaction.recipientDisplayName ?? 'User'}';
          }
          return 'From ${transaction.senderDisplayName ?? 'User'} to ${walletNameResolver(transaction.destinationWalletId)}';
        }
        return '${walletNameResolver(transaction.sourceWalletId)} -> ${walletNameResolver(transaction.destinationWalletId)}';
      case TransactionType.exchange:
        return 'Exchange in ${walletNameResolver(transaction.sourceWalletId)}';
      case TransactionType.reversal:
      case TransactionType.correction:
        return 'Ledger correction';
    }
  }
}

String _transactionTypeLabel(LedgerTransaction transaction) {
  switch (transaction.type) {
    case TransactionType.deposit:
      return 'Deposit';
    case TransactionType.withdraw:
      return 'Withdraw';
    case TransactionType.transfer:
      if (transaction.recipientUserId == null) {
        return 'Internal Transfer';
      }
      return transaction.debtSettlementId == null
          ? 'User Transfer'
          : 'Debt Settlement Transfer';
    case TransactionType.exchange:
      return 'Exchange';
    case TransactionType.reversal:
      return 'Reversal';
    case TransactionType.correction:
      return 'Correction';
  }
}
