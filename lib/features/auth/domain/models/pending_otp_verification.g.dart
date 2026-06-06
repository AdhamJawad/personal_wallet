// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pending_otp_verification.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_PendingOtpVerification _$PendingOtpVerificationFromJson(
  Map<String, dynamic> json,
) => _PendingOtpVerification(
  verificationId: json['verificationId'] as String,
  fullName: json['fullName'] as String,
  phoneNumber: json['phoneNumber'] as String,
  password: json['password'] as String,
  createdAt: const DateTimeConverter().fromJson(json['createdAt'] as String),
);

Map<String, dynamic> _$PendingOtpVerificationToJson(
  _PendingOtpVerification instance,
) => <String, dynamic>{
  'verificationId': instance.verificationId,
  'fullName': instance.fullName,
  'phoneNumber': instance.phoneNumber,
  'password': instance.password,
  'createdAt': const DateTimeConverter().toJson(instance.createdAt),
};
