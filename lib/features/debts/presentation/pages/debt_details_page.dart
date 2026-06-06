import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../core/design_system/widgets/pw_button.dart';
import '../../../../core/design_system/widgets/pw_scaffold.dart';
import '../../../../core/design_system/widgets/pw_section_card.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_text_styles.dart';
import '../../../../core/utils/amount_formatter.dart';
import '../../../../core/utils/date_formatter.dart';
import '../providers/debt_providers.dart';

class DebtDetailsPage extends ConsumerStatefulWidget {
  const DebtDetailsPage({required this.debtId, super.key});

  final String debtId;

  @override
  ConsumerState<DebtDetailsPage> createState() => _DebtDetailsPageState();
}

class _DebtDetailsPageState extends ConsumerState<DebtDetailsPage> {
  @override
  void initState() {
    super.initState();
    Future<void>.microtask(() {
      ref.read(debtControllerProvider.notifier).loadDebt(widget.debtId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final debtState = ref.watch(debtControllerProvider);
    final summary = debtState.selectedDebt;

    return PwScaffold(
      title: 'Debt Details',
      body: debtState.isLoading && summary == null
          ? const Center(child: CircularProgressIndicator())
          : summary == null
          ? const Center(child: Text('Debt not found.'))
          : ListView(
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(summary.contact.name, style: context.titleLarge),
                          const SizedBox(height: AppSpacing.xs),
                          Text(
                            summary.debt.isOwedToMe
                                ? 'This contact owes you'
                                : 'You owe this contact',
                          ),
                        ],
                      ),
                    ),
                    Wrap(
                      spacing: AppSpacing.sm,
                      runSpacing: AppSpacing.sm,
                      children: <Widget>[
                        PwButton.secondary(
                          label: 'Record repayment',
                          onPressed: () => context.push(
                            AppRoutes.debtRepaymentLocation(summary.debt.id),
                          ),
                        ),
                        if (summary.contact.linkedUserId != null &&
                            !summary.isCompleted)
                          PwButton.primary(
                            label: 'Settle with transfer',
                            onPressed: () => context.push(
                              AppRoutes.debtSettlementLocation(summary.debt.id),
                            ),
                          ),
                        PwButton.secondary(
                          label: 'Attachments',
                          onPressed: () => context.push(
                            '${AppRoutes.attachmentViewerPath}?entityType=debt&entityId=${Uri.encodeComponent(summary.debt.id)}&label=${Uri.encodeComponent(summary.contact.name)}',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: AppSpacing.lg),
                PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Debt Summary', style: context.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        _DebtMetricRow(
                          label: 'Original amount',
                          value:
                              '${AmountFormatter.format(summary.debt.originalAmount)} ${summary.currency.name.toUpperCase()}',
                        ),
                        _DebtMetricRow(
                          label: 'Recovered amount',
                          value:
                              '${AmountFormatter.format(summary.repaidAmount)} ${summary.currency.name.toUpperCase()}',
                        ),
                        _DebtMetricRow(
                          label: 'Remaining amount',
                          value:
                              '${AmountFormatter.format(summary.remainingAmount)} ${summary.currency.name.toUpperCase()}',
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: AppSpacing.lg),
                PwSectionCard(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.xl),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Timeline', style: context.titleMedium),
                        const SizedBox(height: AppSpacing.md),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text('Debt Created'),
                          subtitle: Text(summary.debt.note ?? 'Initial debt'),
                          trailing: Text(
                            DateFormatter.short(summary.debt.createdAt),
                          ),
                        ),
                        ...summary.repayments.map((repayment) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            title: Text(
                              'Repayment ${AmountFormatter.format(repayment.amount)} ${summary.currency.name.toUpperCase()}',
                            ),
                            subtitle: Text(repayment.note ?? 'Manual repayment'),
                            trailing: Text(
                              DateFormatter.short(repayment.createdAt),
                            ),
                          );
                        }),
                        ...summary.settlements.map((settlement) {
                          return ListTile(
                            contentPadding: EdgeInsets.zero,
                            onTap: () => context.push(
                              '${AppRoutes.attachmentViewerPath}?entityType=debtSettlement&entityId=${Uri.encodeComponent(settlement.settlement.id)}&label=${Uri.encodeComponent(settlement.transferReference)}',
                            ),
                            title: Text(
                              'Settlement ${AmountFormatter.format(settlement.settlement.amount)} ${summary.currency.name.toUpperCase()}',
                            ),
                            subtitle: Text(
                              '${settlement.counterpartyDisplayName} | ${settlement.transferReference}',
                            ),
                            trailing: Text(
                              DateFormatter.short(
                                settlement.settlement.createdAt,
                              ),
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}

class _DebtMetricRow extends StatelessWidget {
  const _DebtMetricRow({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.md),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label)),
          Text(value, style: context.bodyLarge),
        ],
      ),
    );
  }
}
