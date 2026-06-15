import '../../../contacts/domain/models/contact.dart';
import '../../../../shared/domain/enums/debt_status.dart';
import '../../domain/models/debt.dart';
import '../../domain/models/debt_repayment.dart';
import '../../domain/models/debt_settlement.dart';
import '../../domain/models/debt_summary.dart';
import '../../domain/models/settlement_summary.dart';

class DebtProjectionBuilder {
  const DebtProjectionBuilder();

  DebtAggregateMetrics summarize({
    required Debt debt,
    required List<DebtRepayment> repayments,
    required List<DebtSettlement> settlements,
  }) {
    final int repaymentAmountMinor = repayments.fold<int>(
      0,
      (int total, DebtRepayment repayment) => total + repayment.amountMinor,
    );
    final int settledAmountMinor = settlements.fold<int>(
      0,
      (int total, DebtSettlement settlement) => total + settlement.amountMinor,
    );
    final int resolvedAmountMinor = repaymentAmountMinor + settledAmountMinor;
    final int remainingAmountMinor =
        debt.originalAmountMinor - resolvedAmountMinor;
    final bool isAggregateCompleted = remainingAmountMinor <= 0;

    DateTime latestActivityAt = debt.updatedAt;
    for (final DebtRepayment repayment in repayments) {
      if (repayment.createdAt.isAfter(latestActivityAt)) {
        latestActivityAt = repayment.createdAt;
      }
    }
    for (final DebtSettlement settlement in settlements) {
      if (settlement.createdAt.isAfter(latestActivityAt)) {
        latestActivityAt = settlement.createdAt;
      }
    }

    final DebtStatus resolvedStatus = switch (debt.status) {
      DebtStatus.cancelled => DebtStatus.cancelled,
      DebtStatus.completed =>
        isAggregateCompleted ? DebtStatus.completed : DebtStatus.active,
      DebtStatus.active =>
        isAggregateCompleted ? DebtStatus.completed : DebtStatus.active,
    };

    final DateTime? completedAt = resolvedStatus == DebtStatus.completed
        ? debt.completedAt ??
              settlements.lastOrNull?.createdAt ??
              repayments.lastOrNull?.createdAt ??
              latestActivityAt
        : null;

    return DebtAggregateMetrics(
      repaymentAmountMinor: repaymentAmountMinor,
      settledAmountMinor: settledAmountMinor,
      resolvedAmountMinor: resolvedAmountMinor,
      remainingAmountMinor: remainingAmountMinor < 0 ? 0 : remainingAmountMinor,
      status: resolvedStatus,
      isCompleted: resolvedStatus == DebtStatus.completed,
      latestActivityAt: latestActivityAt,
      completedAt: completedAt,
    );
  }

  Debt reconcileDebt({
    required Debt debt,
    required List<DebtRepayment> repayments,
    required List<DebtSettlement> settlements,
  }) {
    final DebtAggregateMetrics metrics = summarize(
      debt: debt,
      repayments: repayments,
      settlements: settlements,
    );
    return debt.copyWith(
      status: metrics.status,
      updatedAt: metrics.latestActivityAt,
      completedAt: metrics.completedAt,
      clearCompletedAt: metrics.completedAt == null,
    );
  }

  DebtSummary buildSummary({
    required Debt debt,
    required Contact contact,
    required List<DebtRepayment> repayments,
    required List<DebtSettlement> settlements,
    required String Function(DebtSettlement settlement)
    transferReferenceResolver,
  }) {
    final Debt reconciledDebt = reconcileDebt(
      debt: debt,
      repayments: repayments,
      settlements: settlements,
    );
    final DebtAggregateMetrics metrics = summarize(
      debt: reconciledDebt,
      repayments: repayments,
      settlements: settlements,
    );

    int remainingAfterSettlement =
        reconciledDebt.originalAmountMinor - metrics.repaymentAmountMinor;
    final List<SettlementSummary> settlementSummaries = <SettlementSummary>[];
    for (final DebtSettlement settlement in settlements) {
      remainingAfterSettlement -= settlement.amountMinor;
      settlementSummaries.add(
        SettlementSummary(
          settlement: settlement,
          transferReference: transferReferenceResolver(settlement),
          counterpartyDisplayName: contact.name,
          remainingAmountAfterSettlementMinor: remainingAfterSettlement < 0
              ? 0
              : remainingAfterSettlement,
          isCompleted: remainingAfterSettlement <= 0,
        ),
      );
    }

    return DebtSummary(
      debt: reconciledDebt,
      contact: contact,
      repayments: repayments,
      settlements: settlementSummaries,
      repaymentAmountMinor: metrics.repaymentAmountMinor,
      settledAmountMinor: metrics.settledAmountMinor,
      resolvedAmountMinor: metrics.resolvedAmountMinor,
      remainingAmountMinor: metrics.remainingAmountMinor,
      isCompleted: metrics.isCompleted,
      currencyCode: reconciledDebt.currencyCode,
    );
  }
}

class DebtAggregateMetrics {
  const DebtAggregateMetrics({
    required this.repaymentAmountMinor,
    required this.settledAmountMinor,
    required this.resolvedAmountMinor,
    required this.remainingAmountMinor,
    required this.status,
    required this.isCompleted,
    required this.latestActivityAt,
    required this.completedAt,
  });

  final int repaymentAmountMinor;
  final int settledAmountMinor;
  final int resolvedAmountMinor;
  final int remainingAmountMinor;
  final DebtStatus status;
  final bool isCompleted;
  final DateTime latestActivityAt;
  final DateTime? completedAt;
}
