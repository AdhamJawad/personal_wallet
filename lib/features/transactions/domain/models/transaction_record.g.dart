// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionRecord _$TransactionRecordFromJson(Map<String, dynamic> json) =>
    _TransactionRecord(
      id: json['id'] as String,
      type: $enumDecode(_$TransactionTypeEnumMap, json['type']),
      initiatedByUserId: json['initiatedByUserId'] as String,
      sourceWalletId: json['sourceWalletId'] as String?,
      destinationWalletId: json['destinationWalletId'] as String?,
      sourceAmount: json['sourceAmount'] as String,
      sourceCurrency: $enumDecode(_$CurrencyEnumMap, json['sourceCurrency']),
      destinationAmount: json['destinationAmount'] as String?,
      destinationCurrency: $enumDecodeNullable(
        _$CurrencyEnumMap,
        json['destinationCurrency'],
      ),
      relatedTransactionId: json['relatedTransactionId'] as String?,
      note: json['note'] as String?,
      createdAt: const DateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
    );

Map<String, dynamic> _$TransactionRecordToJson(_TransactionRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'type': _$TransactionTypeEnumMap[instance.type]!,
      'initiatedByUserId': instance.initiatedByUserId,
      'sourceWalletId': instance.sourceWalletId,
      'destinationWalletId': instance.destinationWalletId,
      'sourceAmount': instance.sourceAmount,
      'sourceCurrency': _$CurrencyEnumMap[instance.sourceCurrency]!,
      'destinationAmount': instance.destinationAmount,
      'destinationCurrency': _$CurrencyEnumMap[instance.destinationCurrency],
      'relatedTransactionId': instance.relatedTransactionId,
      'note': instance.note,
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
