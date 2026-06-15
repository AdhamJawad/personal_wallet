import '../../../transactions/domain/models/transaction_reference.dart';
import 'user_transfer.dart';

class TransferSummary {
  const TransferSummary({
    required this.transfer,
    required this.ownerUserId,
    required this.isIncoming,
    required this.isDebtSettlement,
    required this.counterpartyDisplayName,
    required this.reference,
    required this.ledgerTransactionId,
  });

  final UserTransfer transfer;
  final String ownerUserId;
  final bool isIncoming;
  final bool isDebtSettlement;
  final String counterpartyDisplayName;
  final TransactionReference reference;
  final String ledgerTransactionId;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'transfer': transfer.toJson(),
    'ownerUserId': ownerUserId,
    'isIncoming': isIncoming,
    'isDebtSettlement': isDebtSettlement,
    'counterpartyDisplayName': counterpartyDisplayName,
    'reference': reference.toJson(),
    'ledgerTransactionId': ledgerTransactionId,
  };
}
