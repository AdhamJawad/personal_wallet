// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_settlement_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtSettlementDraft _$DebtSettlementDraftFromJson(Map<String, dynamic> json) =>
    _DebtSettlementDraft(
      debtId: json['debtId'] as String,
      debtContactName: json['debtContactName'] as String,
      senderWalletId: json['senderWalletId'] as String,
      senderWalletName: json['senderWalletName'] as String,
      recipientUserId: json['recipientUserId'] as String,
      recipientDisplayName: json['recipientDisplayName'] as String,
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
      amount: json['amount'] as String,
      remainingAmountBeforeSettlement:
          json['remainingAmountBeforeSettlement'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$DebtSettlementDraftToJson(
  _DebtSettlementDraft instance,
) => <String, dynamic>{
  'debtId': instance.debtId,
  'debtContactName': instance.debtContactName,
  'senderWalletId': instance.senderWalletId,
  'senderWalletName': instance.senderWalletName,
  'recipientUserId': instance.recipientUserId,
  'recipientDisplayName': instance.recipientDisplayName,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'amount': instance.amount,
  'remainingAmountBeforeSettlement': instance.remainingAmountBeforeSettlement,
  'note': instance.note,
};

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
