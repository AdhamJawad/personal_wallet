// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ledger_transaction.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_LedgerTransaction _$LedgerTransactionFromJson(Map<String, dynamic> json) =>
    _LedgerTransaction(
      id: json['id'] as String,
      reference: TransactionReference.fromJson(
        json['reference'] as Map<String, dynamic>,
      ),
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      initiatedByUserId: json['initiatedByUserId'] as String,
      senderDisplayName: json['senderDisplayName'] as String?,
      recipientUserId: json['recipientUserId'] as String?,
      recipientDisplayName: json['recipientDisplayName'] as String?,
      sourceWalletId: json['sourceWalletId'] as String?,
      destinationWalletId: json['destinationWalletId'] as String?,
      sourceCurrency: $enumDecode(_$CurrencyEnumMap, json['sourceCurrency']),
      destinationCurrency: $enumDecodeNullable(
        _$CurrencyEnumMap,
        json['destinationCurrency'],
      ),
      sourceAmount: json['sourceAmount'] as String,
      destinationAmount: json['destinationAmount'] as String?,
      exchangeRate: json['exchangeRate'] as String?,
      note: json['note'] as String?,
      attachmentLabel: json['attachmentLabel'] as String?,
      transferRecordId: json['transferRecordId'] as String?,
      debtSettlementId: json['debtSettlementId'] as String?,
      relatedTransactionId: json['relatedTransactionId'] as String?,
      createdAt: const DateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
    );

Map<String, dynamic> _$LedgerTransactionToJson(_LedgerTransaction instance) =>
    <String, dynamic>{
      'id': instance.id,
      'reference': instance.reference,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'initiatedByUserId': instance.initiatedByUserId,
      'senderDisplayName': instance.senderDisplayName,
      'recipientUserId': instance.recipientUserId,
      'recipientDisplayName': instance.recipientDisplayName,
      'sourceWalletId': instance.sourceWalletId,
      'destinationWalletId': instance.destinationWalletId,
      'sourceCurrency': _$CurrencyEnumMap[instance.sourceCurrency]!,
      'destinationCurrency': _$CurrencyEnumMap[instance.destinationCurrency],
      'sourceAmount': instance.sourceAmount,
      'destinationAmount': instance.destinationAmount,
      'exchangeRate': instance.exchangeRate,
      'note': instance.note,
      'attachmentLabel': instance.attachmentLabel,
      'transferRecordId': instance.transferRecordId,
      'debtSettlementId': instance.debtSettlementId,
      'relatedTransactionId': instance.relatedTransactionId,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };

const _$TransactionTypeEnumMap = {
  TransactionType.deposit: 'deposit',
  TransactionType.withdraw: 'withdraw',
  TransactionType.transfer: 'transfer',
  TransactionType.exchange: 'exchange',
  TransactionType.reversal: 'reversal',
  TransactionType.correction: 'correction',
};

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
