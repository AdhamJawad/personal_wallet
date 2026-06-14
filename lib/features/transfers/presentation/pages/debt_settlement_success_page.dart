import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../debts/presentation/providers/debt_providers.dart';
import '../providers/transfer_providers.dart';
import '../widgets/transfer_page_shell.dart';

class DebtSettlementSuccessPage extends ConsumerWidget {
  const DebtSettlementSuccessPage({required this.debtId, super.key});

  final String debtId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transferState = ref.watch(transferControllerProvider);
    final debtState = ref.watch(debtControllerProvider);
    final settlement = transferState.lastCompletedSettlement;
    final debt = debtState.selectedDebt;
    final notifier = ref.read(transferControllerProvider.notifier);

    void goToDebtDetails() {
      notifier.clearCompletionState();
      context.go(AppRoutes.debtDetailsLocation(debtId));
    }

    void goToTransactions() {
      notifier.clearCompletionState();
      context.go(AppRoutes.transactionsPath);
    }

    return PopScope<void>(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, void result) {
        if (didPop) {
          return;
        }
        goToDebtDetails();
      },
      child: settlement == null
          ? TransferPageShell(
              title: 'Debt Settlement Complete',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('No completed settlement is available.'),
                  const SizedBox(height: AppSpacing.lg),
                  PwButton.primary(
                    label: 'Back to debt details',
                    onPressed: goToDebtDetails,
                  ),
                ],
              ),
            )
          : TransferPageShell(
              title: 'Debt Settlement Complete',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Settlement linked successfully'),
                  const SizedBox(height: AppSpacing.sm),
                  Text(settlement.transferReference),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${AmountFormatter.format(settlement.settlement.amount)} ${settlement.settlement.currency.name.toUpperCase()} applied to the debt.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(
                    debt == null
                        ? 'Debt details refreshed.'
                        : 'Remaining debt: ${AmountFormatter.format(debt.remainingAmount)} ${debt.currency.name.toUpperCase()}',
                  ),
                  const SizedBox(height: AppSpacing.xl),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: PwButton.secondary(
                          label: 'View ledger',
                          onPressed: goToTransactions,
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: PwButton.primary(
                          label: 'Debt details',
                          onPressed: goToDebtDetails,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
    );
  }
}
