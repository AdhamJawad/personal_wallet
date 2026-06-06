import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';
import '../../../../shared/domain/enums/currency.dart';
import '../../../../shared/domain/enums/transaction_type.dart';
import 'transaction_reference.dart';

part 'ledger_transaction.freezed.dart';
part 'ledger_transaction.g.dart';

@freezed
abstract class LedgerTransaction with _$LedgerTransaction {
  const factory LedgerTransaction({
    required String id,
    required TransactionReference reference,
    required TransactionType type,
    required String initiatedByUserId,
    String? senderDisplayName,
    String? recipientUserId,
    String? recipientDisplayName,
    String? sourceWalletId,
    String? destinationWalletId,
    required Currency sourceCurrency,
    Currency? destinationCurrency,
    required String sourceAmount,
    String? destinationAmount,
    String? exchangeRate,
    String? note,
    String? attachmentLabel,
    String? transferRecordId,
    String? debtSettlementId,
    String? relatedTransactionId,
    @DateTimeConverter() required DateTime createdAt,
  }) = _LedgerTransaction;

  factory LedgerTransaction.fromJson(Map<String, dynamic> json) =>
      _$LedgerTransactionFromJson(json);
}
