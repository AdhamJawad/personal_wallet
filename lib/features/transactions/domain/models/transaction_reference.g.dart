// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transaction_reference.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransactionReference _$TransactionReferenceFromJson(
  Map<String, dynamic> json,
) => _TransactionReference(
  value: json['value'] as String,
  year: (json['year'] as num).toInt(),
  sequence: (json['sequence'] as num).toInt(),
);

Map<String, dynamic> _$TransactionReferenceToJson(
  _TransactionReference instance,
) => <String, dynamic>{
  'value': instance.value,
  'year': instance.year,
  'sequence': instance.sequence,
};
