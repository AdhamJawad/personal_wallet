// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_draft.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferDraft _$TransferDraftFromJson(Map<String, dynamic> json) =>
    _TransferDraft(
      senderWalletId: json['senderWalletId'] as String,
      senderWalletName: json['senderWalletName'] as String,
      recipientUserId: json['recipientUserId'] as String,
      recipientDisplayName: json['recipientDisplayName'] as String,
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
      amount: json['amount'] as String,
      note: json['note'] as String?,
    );

Map<String, dynamic> _$TransferDraftToJson(_TransferDraft instance) =>
    <String, dynamic>{
      'senderWalletId': instance.senderWalletId,
      'senderWalletName': instance.senderWalletName,
      'recipientUserId': instance.recipientUserId,
      'recipientDisplayName': instance.recipientDisplayName,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'amount': instance.amount,
      'note': instance.note,
    };

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
