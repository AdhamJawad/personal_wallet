// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'transfer_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_TransferSummary _$TransferSummaryFromJson(Map<String, dynamic> json) =>
    _TransferSummary(
      transfer: UserTransfer.fromJson(json['transfer'] as Map<String, dynamic>),
      isIncoming: json['isIncoming'] as bool,
      isDebtSettlement: json['isDebtSettlement'] as bool,
      counterpartyDisplayName: json['counterpartyDisplayName'] as String,
    );

Map<String, dynamic> _$TransferSummaryToJson(_TransferSummary instance) =>
    <String, dynamic>{
      'transfer': instance.transfer,
      'isIncoming': instance.isIncoming,
      'isDebtSettlement': instance.isDebtSettlement,
      'counterpartyDisplayName': instance.counterpartyDisplayName,
    };
