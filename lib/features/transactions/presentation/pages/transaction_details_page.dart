import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/localization/localization_extensions.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import '../../../dashboard/presentation/widgets/dashboard_empty_state.dart';
import '../../../dashboard/presentation/widgets/dashboard_breakpoints.dart';
import '../../../wallets/domain/models/wallet_overview.dart';
import '../../../wallets/presentation/providers/wallet_providers.dart';
import '../../domain/models/ledger_transaction.dart';
import '../providers/transaction_providers.dart';
import '../widgets/transaction_flow_support.dart';

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
      return wallet?.wallet.name ?? context.tr.unknownWallet;
    }

    String walletValue() {
      if (transaction == null) {
        return '';
      }
      if (transaction.type == TransactionType.deposit) {
        return resolveWalletName(transaction.destinationWalletId);
      }
      return resolveWalletName(transaction.sourceWalletId);
    }

    return PwScaffold(
      title: context.tr.transactionDetailsTitle,
      body: transactionState.isLoading && transaction == null
          ? const Center(child: TransactionSkeletonBlock(height: 180))
          : transactionState.errorMessage != null && transaction == null
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: DashboardEmptyState(
                  icon: Icons.error_outline_rounded,
                  title: context.tr.somethingWentWrong,
                  message:
                      transactionState.errorMessage ??
                      context.tr.somethingWentWrong,
                  actionLabel: context.tr.tryAgain,
                  onActionPressed: () {
                    ref
                        .read(transactionControllerProvider.notifier)
                        .loadTransaction(widget.transactionId);
                  },
                  secondaryActionLabel: context.tr.back,
                  onSecondaryActionPressed: () =>
                      context.go(AppRoutes.transactionsPath),
                ),
              ),
            )
          : transaction == null
          ? Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 420),
                child: DashboardEmptyState(
                  icon: Icons.receipt_long_outlined,
                  title: context.tr.transactionNotFound,
                  message: context.tr.transactionNotFound,
                  actionLabel: context.tr.tryAgain,
                  onActionPressed: () {
                    ref
                        .read(transactionControllerProvider.notifier)
                        .loadTransaction(widget.transactionId);
                  },
                  secondaryActionLabel: context.tr.back,
                  onSecondaryActionPressed: () =>
                      context.go(AppRoutes.transactionsPath),
                ),
              ),
            )
          : Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(
                  maxWidth: dashboardReadableContentMaxWidth,
                ),
                child: LayoutBuilder(
                  builder: (BuildContext context, BoxConstraints constraints) {
                    final bool compactLayout = constraints.maxWidth < 460;

                    return PwSectionCard(
                      child: Padding(
                        padding: EdgeInsets.all(
                          compactLayout ? AppSpacing.lg : AppSpacing.xl,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            if (compactLayout) ...<Widget>[
                              Text(
                                transaction.reference.value,
                                style: context.titleLarge,
                              ),
                              const SizedBox(height: AppSpacing.sm),
                              Align(
                                alignment: AlignmentDirectional.centerStart,
                                child: TextButton(
                                  onPressed: () => context.push(
                                    '${AppRoutes.attachmentViewerPath}?entityType=transaction&entityId=${Uri.encodeComponent(transaction.id)}&label=${Uri.encodeComponent(transaction.reference.value)}',
                                  ),
                                  child: Text(context.tr.attachmentsButton),
                                ),
                              ),
                            ] else
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Expanded(
                                    child: Text(
                                      transaction.reference.value,
                                      style: context.titleLarge,
                                    ),
                                  ),
                                  const SizedBox(width: AppSpacing.sm),
                                  TextButton(
                                    onPressed: () => context.push(
                                      '${AppRoutes.attachmentViewerPath}?entityType=transaction&entityId=${Uri.encodeComponent(transaction.id)}&label=${Uri.encodeComponent(transaction.reference.value)}',
                                    ),
                                    child: Text(context.tr.attachmentsButton),
                                  ),
                                ],
                              ),
                            const SizedBox(height: AppSpacing.lg),
                            _DetailRow(
                              label: context.tr.detailDate,
                              value: DateFormatter.full(transaction.createdAt),
                            ),
                            _DetailRow(
                              label: context.tr.detailType,
                              value: _typeLabel(context, transaction),
                            ),
                            _DetailRow(
                              label: context.tr.wallet,
                              value: walletValue(),
                            ),
                            if (transaction.destinationWalletId != null &&
                                transaction.recipientUserId == null &&
                                transaction.sourceWalletId != null)
                              _DetailRow(
                                label: context.tr.detailDestinationWallet,
                                value: resolveWalletName(
                                  transaction.destinationWalletId,
                                ),
                              ),
                            if (transaction.recipientDisplayName != null)
                              _DetailRow(
                                label: context.tr.recipient,
                                value: transaction.recipientDisplayName!,
                              ),
                            if (transaction.senderDisplayName != null &&
                                transaction.sourceWalletId == null)
                              _DetailRow(
                                label: context.tr.detailSender,
                                value: transaction.senderDisplayName!,
                              ),
                            _DetailRow(
                              label: context.tr.amount,
                              value:
                                  '${AmountFormatter.format(transaction.sourceAmount)} ${transaction.sourceCurrency.name.toUpperCase()}',
                            ),
                            if (transaction.destinationCurrency != null &&
                                transaction.destinationAmount != null)
                              _DetailRow(
                                label: context.tr.detailReceived,
                                value:
                                    '${AmountFormatter.format(transaction.destinationAmount!)} ${transaction.destinationCurrency!.name.toUpperCase()}',
                              ),
                            if ((transaction.exchangeRate ?? '').isNotEmpty)
                              _DetailRow(
                                label: context.tr.exchangeRate,
                                value: transaction.exchangeRate!,
                              ),
                            if (transaction.transferRecordId != null)
                              _DetailRow(
                                label: context.tr.detailTransferId,
                                value: transaction.transferRecordId!,
                              ),
                            if (transaction.debtSettlementId != null)
                              _DetailRow(
                                label: context.tr.detailSettlementId,
                                value: transaction.debtSettlementId!,
                              ),
                            if ((transaction.note ?? '').isNotEmpty)
                              _DetailRow(
                                label: context.tr.detailNotes,
                                value: transaction.note!,
                              ),
                            _DetailRow(
                              label: context.tr.detailAttachment,
                              value:
                                  transaction.attachmentLabel ??
                                  context.tr.none,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),
    );
  }

  String _typeLabel(BuildContext context, LedgerTransaction transaction) {
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
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool stack = constraints.maxWidth < 420;

          if (stack) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(label),
                const SizedBox(height: AppSpacing.xs),
                Text(value, style: context.bodyLarge),
              ],
            );
          }

          return Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Flexible(
                flex: 3,
                child: Padding(
                  padding: const EdgeInsets.only(right: AppSpacing.md),
                  child: Text(label),
                ),
              ),
              Expanded(flex: 5, child: Text(value, style: context.bodyLarge)),
            ],
          );
        },
      ),
    );
  }
}
