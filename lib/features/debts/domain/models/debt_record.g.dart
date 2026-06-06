// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtRecord _$DebtRecordFromJson(Map<String, dynamic> json) => _DebtRecord(
  id: json['id'] as String,
  lenderPartyId: json['lenderPartyId'] as String,
  borrowerPartyId: json['borrowerPartyId'] as String,
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  principalAmount: json['principalAmount'] as String,
  repaidAmount: json['repaidAmount'] as String,
  status: $enumDecode(_$DebtStatusEnumMap, json['status']),
  note: json['note'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
);

Map<String, dynamic> _$DebtRecordToJson(_DebtRecord instance) =>
    <String, dynamic>{
      'id': instance.id,
      'lenderPartyId': instance.lenderPartyId,
      'borrowerPartyId': instance.borrowerPartyId,
      'currency': _$CurrencyEnumMap[instance.currency]!,
      'principalAmount': instance.principalAmount,
      'repaidAmount': instance.repaidAmount,
      'status': _$DebtStatusEnumMap[instance.status]!,
      'note': instance.note,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
      'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
    };

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};

const _$DebtStatusEnumMap = {
  DebtStatus.open: 'open',
  DebtStatus.settled: 'settled',
  DebtStatus.disputed: 'disputed',
};
