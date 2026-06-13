class PendingOtpVerification {
  const PendingOtpVerification({
    required this.verificationId,
    required this.phoneNumber,
    required this.createdAt,
    this.fullName,
    this.emailAddress,
  });

  factory PendingOtpVerification.fromJson(Map<String, dynamic> json) {
    return PendingOtpVerification(
      verificationId: json['verificationId'] as String,
      phoneNumber: json['phoneNumber'] as String,
      fullName: json['fullName'] as String?,
      emailAddress: json['emailAddress'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String).toUtc(),
    );
  }

  final String verificationId;
  final String phoneNumber;
  final String? fullName;
  final String? emailAddress;
  final DateTime createdAt;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'verificationId': verificationId,
    'phoneNumber': phoneNumber,
    'fullName': fullName,
    'emailAddress': emailAddress,
    'createdAt': createdAt.toIso8601String(),
  };
}
