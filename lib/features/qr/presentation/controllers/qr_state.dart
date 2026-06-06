import 'package:freezed_annotation/freezed_annotation.dart';

import '../../domain/models/qr_identity.dart';
import '../../domain/models/qr_scan_result.dart';

part 'qr_state.freezed.dart';

@freezed
abstract class QrState with _$QrState {
  const factory QrState({
    @Default(false) bool isLoading,
    QrIdentity? myIdentity,
    @Default(<QrIdentity>[]) List<QrIdentity> knownIdentities,
    QrScanResult? scanResult,
    String? errorMessage,
  }) = _QrState;
}
