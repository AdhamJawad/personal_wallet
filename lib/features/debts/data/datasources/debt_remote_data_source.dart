import '../../../../core/network/remote_data_source.dart';
import '../../domain/models/debt_summary.dart';
import '../../domain/models/settlement_summary.dart';

abstract interface class DebtRemoteDataSource implements RemoteDataSource {
  Future<DebtSummary> createDebt({
    required String ownerUserId,
    required String contactId,
    required bool isOwedToMe,
    required String currencyCode,
    required String amount,
    String? note,
  });
  Future<DebtSummary> createRepayment({
    required String ownerUserId,
    required String debtId,
    required String amount,
    String? note,
  });
  Future<SettlementSummary> createSettlement({
    required String ownerUserId,
    required String debtId,
    required String transferId,
    required String ledgerTransactionId,
    required String transferReference,
    required String amount,
    String? note,
  });
  Future<List<DebtSummary>> fetchDebts(String ownerUserId);
  Future<DebtSummary?> getDebtById({
    required String ownerUserId,
    required String debtId,
  });
}
