// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settlement_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_SettlementSummary _$SettlementSummaryFromJson(Map<String, dynamic> json) =>
    _SettlementSummary(
      settlement: DebtSettlement.fromJson(
        json['settlement'] as Map<String, dynamic>,
      ),
      transferReference: json['transferReference'] as String,
      counterpartyDisplayName: json['counterpartyDisplayName'] as String,
      remainingAmountAfterSettlement:
          json['remainingAmountAfterSettlement'] as String,
      isCompleted: json['isCompleted'] as bool,
    );

Map<String, dynamic> _$SettlementSummaryToJson(_SettlementSummary instance) =>
    <String, dynamic>{
      'settlement': instance.settlement,
      'transferReference': instance.transferReference,
      'counterpartyDisplayName': instance.counterpartyDisplayName,
      'remainingAmountAfterSettlement': instance.remainingAmountAfterSettlement,
      'isCompleted': instance.isCompleted,
    };
