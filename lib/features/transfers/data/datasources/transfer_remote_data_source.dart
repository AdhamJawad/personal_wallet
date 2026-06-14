import '../../../../core/network/remote_data_source.dart';
import '../../../debts/domain/models/settlement_summary.dart';
import '../../domain/models/transfer_summary.dart';

abstract interface class TransferRemoteDataSource implements RemoteDataSource {
  Future<TransferSummary> createTransfer({
    required String ownerUserId,
    required String senderDisplayName,
    required String senderWalletId,
    required String recipientUserId,
    required String recipientDisplayName,
    required String currencyCode,
    required int amountMinor,
    String? note,
  });
  Future<SettlementSummary> createDebtSettlement({
    required String ownerUserId,
    required String senderDisplayName,
    required String debtId,
    required String senderWalletId,
    required String recipientUserId,
    required String recipientDisplayName,
    required String currencyCode,
    required int amountMinor,
    String? note,
  });
  Future<List<TransferSummary>> fetchTransfers(String ownerUserId);
  Future<TransferSummary?> getTransferById({
    required String ownerUserId,
    required String transferId,
  });
}
