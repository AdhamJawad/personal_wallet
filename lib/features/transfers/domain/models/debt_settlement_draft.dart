import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../shared/domain/enums/currency.dart';

part 'debt_settlement_draft.freezed.dart';
part 'debt_settlement_draft.g.dart';

@freezed
abstract class DebtSettlementDraft with _$DebtSettlementDraft {
  const factory DebtSettlementDraft({
    required String debtId,
    required String debtContactName,
    required String senderWalletId,
    required String senderWalletName,
    required String recipientUserId,
    required String recipientDisplayName,
    required Currency currency,
    required String amount,
    required String remainingAmountBeforeSettlement,
    String? note,
  }) = _DebtSettlementDraft;

  factory DebtSettlementDraft.fromJson(Map<String, dynamic> json) =>
      _$DebtSettlementDraftFromJson(json);
}
