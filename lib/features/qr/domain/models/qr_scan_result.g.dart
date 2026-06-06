// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'qr_scan_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_QrScanResult _$QrScanResultFromJson(Map<String, dynamic> json) =>
    _QrScanResult(
      identity: QrIdentity.fromJson(json['identity'] as Map<String, dynamic>),
      isSelf: json['isSelf'] as bool,
      isKnownContact: json['isKnownContact'] as bool,
      existingContactId: json['existingContactId'] as String?,
    );

Map<String, dynamic> _$QrScanResultToJson(_QrScanResult instance) =>
    <String, dynamic>{
      'identity': instance.identity,
      'isSelf': instance.isSelf,
      'isKnownContact': instance.isKnownContact,
      'existingContactId': instance.existingContactId,
    };
