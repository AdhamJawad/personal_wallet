import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../providers/debt_providers.dart';

class DebtsPage extends ConsumerWidget {
  const DebtsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final debtState = ref.watch(debtControllerProvider);
    final debts = debtState.visibleDebts;

    return PwScaffold(
      title: 'Debts',
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: SegmentedButton<bool>(
                  segments: const <ButtonSegment<bool>>[
                    ButtonSegment<bool>(value: true, label: Text('Owed To Me')),
                    ButtonSegment<bool>(value: false, label: Text('I Owe')),
                  ],
                  selected: <bool>{debtState.showOwedToMe},
                  onSelectionChanged: (Set<bool> selection) {
                    ref
                        .read(debtControllerProvider.notifier)
                        .setShowOwedToMe(selection.first);
                  },
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              PwButton.primary(
                label: 'Create debt',
                onPressed: () => context.push(AppRoutes.debtCreatePath),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.xl),
          Expanded(
            child: debtState.isLoading
                ? const Center(child: CircularProgressIndicator())
                : debts.isEmpty
                ? const Center(child: Text('No debt records found.'))
                : ListView.builder(
                    itemCount: debts.length,
                    itemBuilder: (BuildContext context, int index) {
                      final debt = debts[index];
                      return Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.md),
                        child: PwSectionCard(
                          child: ListTile(
                            onTap: () => context.push(
                              AppRoutes.debtDetailsLocation(debt.debt.id),
                            ),
                            title: Text(debt.contact.name),
                            subtitle: Text(
                              '${AmountFormatter.format(debt.debt.originalAmount)} ${debt.currency.name.toUpperCase()} • Remaining ${AmountFormatter.format(debt.remainingAmount)}',
                            ),
                            trailing: debt.isCompleted
                                ? const Chip(label: Text('Completed'))
                                : null,
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
