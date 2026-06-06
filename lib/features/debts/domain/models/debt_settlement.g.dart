// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_settlement.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtSettlement _$DebtSettlementFromJson(Map<String, dynamic> json) =>
    _DebtSettlement(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      ownerUserId: json['ownerUserId'] as String,
      transferId: json['transferId'] as String,
      ledgerTransactionId: json['ledgerTransactionId'] as String,
      transferReference: json['transferReference'] as String,
      currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
      amount: json['amount'] as String,
      note: json['note'] as String?,
      createdAt: const DateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
    );

Map<String, dynamic> _$DebtSettlementToJson(_DebtSettlement instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debtId': instance.debtId,
      'ownerUserId': instance.ownerUserId,
      'transferId': instance.transferId,
      'ledgerTransactionId': instance.ledgerTransactionId,
      'transferReference': instance.transferReference,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'amount': instance.amount,
      'note': instance.note,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
