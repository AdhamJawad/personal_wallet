// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'money.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Money _$MoneyFromJson(Map<String, dynamic> json) => _Money(
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  amount: json['amount'] as String,
);

Map<String, dynamic> _$MoneyToJson(_Money instance) => <String, dynamic>{
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'amount': instance.amount,
};

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
