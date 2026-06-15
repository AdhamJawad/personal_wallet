import '../models/debt_settlement.dart';
import '../models/debt_summary.dart';

abstract interface class DebtRepository {
  Future<DebtSummary> createDebt({
    required String ownerUserId,
    required String contactId,
    required bool isOwedToMe,
    required String currencyCode,
    required int amountMinor,
    String? note,
  });
  Future<DebtSummary> createRepayment({
    required String ownerUserId,
    required String debtId,
    required int amountMinor,
    String? note,
  });
  Future<DebtSummary> updateDebt({
    required String ownerUserId,
    required String debtId,
    required int amountMinor,
    String? note,
  });
  Future<DebtSummary> closeDebt({
    required String ownerUserId,
    required String debtId,
  });
  Future<DebtSummary> reopenDebt({
    required String ownerUserId,
    required String debtId,
  });
  Future<DebtSettlement> createSettlement({
    required String ownerUserId,
    required String debtId,
    required String transferId,
    required int amountMinor,
    String? note,
  });
  Future<List<DebtSummary>> fetchDebts(String ownerUserId);
  Future<DebtSummary?> getDebtById({
    required String ownerUserId,
    required String debtId,
  });
}
