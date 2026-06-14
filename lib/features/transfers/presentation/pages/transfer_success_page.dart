import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../providers/transfer_providers.dart';
import '../widgets/transfer_page_shell.dart';

class TransferSuccessPage extends ConsumerWidget {
  const TransferSuccessPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transfer = ref
        .watch(transferControllerProvider)
        .lastCompletedTransfer;
    final notifier = ref.read(transferControllerProvider.notifier);

    void goToDashboard() {
      notifier.clearCompletionState();
      context.go(AppRoutes.dashboardPath);
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
        goToDashboard();
      },
      child: transfer == null
          ? TransferPageShell(
              title: 'Transfer Complete',
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const Text('No completed transfer is available.'),
                  const SizedBox(height: AppSpacing.lg),
                  PwButton.primary(
                    label: 'Back to dashboard',
                    onPressed: goToDashboard,
                  ),
                ],
              ),
            )
          : TransferPageShell(
              title: 'Transfer Complete',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text('Transfer recorded', style: context.titleLarge),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    transfer.transfer.reference.value,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    '${AmountFormatter.format(transfer.transfer.amount)} ${transfer.transfer.currency.name.toUpperCase()} sent to ${transfer.counterpartyDisplayName}.',
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Text(transfer.transfer.note ?? 'No note attached.'),
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
                          label: 'Dashboard',
                          onPressed: goToDashboard,
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
