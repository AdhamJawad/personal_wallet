import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../transactions/domain/models/transaction_reference.dart';

part 'user_transfer.freezed.dart';
part 'user_transfer.g.dart';

@freezed
abstract class UserTransfer with _$UserTransfer {
  const factory UserTransfer({
    required String id,
    required String ownerUserId,
    required TransactionReference reference,
    required String senderUserId,
    required String senderDisplayName,
    required String recipientUserId,
    required String recipientDisplayName,
    required String senderWalletId,
    required String recipientWalletId,
    required Currency currency,
    required String amount,
    String? note,
    required String ledgerTransactionId,
    String? mirroredLedgerTransactionId,
    String? linkedDebtSettlementId,
    @DateTimeConverter() required DateTime createdAt,
  }) = _UserTransfer;

  factory UserTransfer.fromJson(Map<String, dynamic> json) =>
      _$UserTransferFromJson(json);
}
