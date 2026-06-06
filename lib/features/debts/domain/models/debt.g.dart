// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Debt _$DebtFromJson(Map<String, dynamic> json) => _Debt(
  id: json['id'] as String,
  ownerUserId: json['ownerUserId'] as String,
  counterpartyContactId: json['counterpartyContactId'] as String,
  isOwedToMe: json['isOwedToMe'] as bool,
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
  originalAmount: json['originalAmount'] as String,
  note: json['note'] as String?,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
  updatedAt: const DateTimeConverter().fromJson(json['updatedAt'] as String),
  completedAt: _$JsonConverterFromJson<String, DateTime>(
    json['completedAt'],
    const DateTimeConverter().fromJson,
  ),
);

Map<String, dynamic> _$DebtToJson(_Debt instance) => <String, dynamic>{
  'id': instance.id,
  'ownerUserId': instance.ownerUserId,
  'counterpartyContactId': instance.counterpartyContactId,
  'isOwedToMe': instance.isOwedToMe,
  'currency': _$CurrencyEnumMap[instance.currency]!,
  'originalAmount': instance.originalAmount,
  'note': instance.note,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
  'updatedAt': const DateTimeConverter().toJson(instance.updatedAt),
  'completedAt': _$JsonConverterToJson<String, DateTime>(
    instance.completedAt,
    const DateTimeConverter().toJson,
  ),
};

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};

Value? _$JsonConverterFromJson<Json, Value>(
  Object? json,
  Value? Function(Json json) fromJson,
) => json == null ? null : fromJson(json as Json);

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
