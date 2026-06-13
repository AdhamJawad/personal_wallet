import 'package:flutter/material.dart';

import '../../../../core/localization/localization_extensions.dart';
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
                        Text(_transactionTypeLabel(context, transaction)),
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
              Text(_walletSummary(context)),
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

  String _walletSummary(BuildContext context) {
    switch (transaction.type) {
      case TransactionType.deposit:
        return context.tr.toWallet(
          walletNameResolver(transaction.destinationWalletId),
        );
      case TransactionType.withdraw:
        return context.tr.fromWallet(
          walletNameResolver(transaction.sourceWalletId),
        );
      case TransactionType.transfer:
        if (transaction.recipientUserId != null) {
          if (transaction.sourceWalletId != null) {
            return context.tr.walletToUser(
              walletNameResolver(transaction.sourceWalletId),
              transaction.recipientDisplayName ?? context.tr.userFallback,
            );
          }
          return context.tr.userToWallet(
            transaction.senderDisplayName ?? context.tr.userFallback,
            walletNameResolver(transaction.destinationWalletId),
          );
        }
        return context.tr.walletToWallet(
          walletNameResolver(transaction.sourceWalletId),
          walletNameResolver(transaction.destinationWalletId),
        );
      case TransactionType.exchange:
        return context.tr.exchangeInWallet(
          walletNameResolver(transaction.sourceWalletId),
        );
      case TransactionType.reversal:
      case TransactionType.correction:
        return context.tr.ledgerCorrection;
    }
  }
}

String _transactionTypeLabel(
  BuildContext context,
  LedgerTransaction transaction,
) {
  switch (transaction.type) {
    case TransactionType.deposit:
      return context.tr.deposit;
    case TransactionType.withdraw:
      return context.tr.withdraw;
    case TransactionType.transfer:
      if (transaction.recipientUserId == null) {
        return context.tr.internalTransfer;
      }
      return transaction.debtSettlementId == null
          ? context.tr.userTransfer
          : context.tr.debtSettlementTransfer;
    case TransactionType.exchange:
      return context.tr.exchange;
    case TransactionType.reversal:
      return context.tr.reversalActivity;
    case TransactionType.correction:
      return context.tr.correctionActivity;
  }
}
