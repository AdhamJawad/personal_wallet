import 'package:freezed_annotation/freezed_annotation.dart';

part 'qr_identity.freezed.dart';
part 'qr_identity.g.dart';

@freezed
abstract class QrIdentity with _$QrIdentity {
  const factory QrIdentity({
    required String userId,
    required String displayName,
    required String publicReferenceIdentifier,
    required String payload,
  }) = _QrIdentity;

  factory QrIdentity.fromJson(Map<String, dynamic> json) =>
      _$QrIdentityFromJson(json);
}
