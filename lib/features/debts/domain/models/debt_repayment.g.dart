// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_repayment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_DebtRepayment _$DebtRepaymentFromJson(Map<String, dynamic> json) =>
    _DebtRepayment(
      id: json['id'] as String,
      debtId: json['debtId'] as String,
      amount: json['amount'] as String,
      note: json['note'] as String?,
      createdAt: const DateTimeConverter().fromJson(
        json['createdAt'] as String,
      ),
    );

Map<String, dynamic> _$DebtRepaymentToJson(_DebtRepayment instance) =>
    <String, dynamic>{
      'id': instance.id,
      'debtId': instance.debtId,
      'amount': instance.amount,
      'note': instance.note,
      'createdAt': const DateTimeConverter().toJson(instance.createdAt),
    };
