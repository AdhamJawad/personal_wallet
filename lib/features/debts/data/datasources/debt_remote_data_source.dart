import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/debt_settlement.dart';
import '../../domain/models/debt_summary.dart';

abstract interface class DebtRemoteDataSource implements RemoteDataSource {
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
