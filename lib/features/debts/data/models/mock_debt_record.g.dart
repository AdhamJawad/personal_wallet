// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'mock_debt_record.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MockDebtRecord _$MockDebtRecordFromJson(Map<String, dynamic> json) =>
    _MockDebtRecord(
      debt: Debt.fromJson(json['debt'] as Map<String, dynamic>),
      repayments: (json['repayments'] as List<dynamic>)
          .map((e) => DebtRepayment.fromJson(e as Map<String, dynamic>))
          .toList(),
      settlements:
          (json['settlements'] as List<dynamic>?)
              ?.map((e) => DebtSettlement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <DebtSettlement>[],
    );

Map<String, dynamic> _$MockDebtRecordToJson(_MockDebtRecord instance) =>
    <String, dynamic>{
      'debt': instance.debt,
      'repayments': instance.repayments,
      'settlements': instance.settlements,
    };
