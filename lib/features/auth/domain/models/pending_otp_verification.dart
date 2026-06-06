import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/utils/date_time_converter.dart';

part 'pending_otp_verification.freezed.dart';
part 'pending_otp_verification.g.dart';

@freezed
abstract class PendingOtpVerification with _$PendingOtpVerification {
  const factory PendingOtpVerification({
    required String verificationId,
    required String fullName,
    required String phoneNumber,
    required String password,
    @DateTimeConverter() required DateTime createdAt,
  }) = _PendingOtpVerification;

  factory PendingOtpVerification.fromJson(Map<String, dynamic> json) =>
      _$PendingOtpVerificationFromJson(json);
}
