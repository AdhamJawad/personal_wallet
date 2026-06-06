import 'package:freezed_annotation/freezed_annotation.dart';

import 'qr_identity.dart';

part 'qr_scan_result.freezed.dart';
part 'qr_scan_result.g.dart';

@freezed
abstract class QrScanResult with _$QrScanResult {
  const factory QrScanResult({
    required QrIdentity identity,
    required bool isSelf,
    required bool isKnownContact,
    String? existingContactId,
  }) = _QrScanResult;

  factory QrScanResult.fromJson(Map<String, dynamic> json) =>
      _$QrScanResultFromJson(json);
}
