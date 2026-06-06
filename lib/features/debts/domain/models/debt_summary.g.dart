// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtSummary _$DebtSummaryFromJson(Map<String, dynamic> json) => _DebtSummary(
  debt: Debt.fromJson(json['debt'] as Map<String, dynamic>),
  contact: Contact.fromJson(json['contact'] as Map<String, dynamic>),
  repayments: (json['repayments'] as List<dynamic>)
      .map((e) => DebtRepayment.fromJson(e as Map<String, dynamic>))
      .toList(),
  settlements:
      (json['settlements'] as List<dynamic>?)
          ?.map((e) => SettlementSummary.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const <SettlementSummary>[],
  repaidAmount: json['repaidAmount'] as String,
  remainingAmount: json['remainingAmount'] as String,
  isCompleted: json['isCompleted'] as bool,
  currency: $enumDecode(_$CurrencyEnumMap, json['currency']),
);

Map<String, dynamic> _$DebtSummaryToJson(_DebtSummary instance) =>
    <String, dynamic>{
      'debt': instance.debt,
      'contact': instance.contact,
      'repayments': instance.repayments,
      'settlements': instance.settlements,
      'repaidAmount': instance.repaidAmount,
      'remainingAmount': instance.remainingAmount,
      'isCompleted': instance.isCompleted,
      'currency': _$CurrencyEnumMap[instance.currency]!,
    };

const _$CurrencyEnumMap = {Currency.usd: 'usd', Currency.syp: 'syp'};
