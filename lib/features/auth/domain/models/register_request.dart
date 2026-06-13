class RegisterRequest {
  const RegisterRequest({
    required this.fullName,
    required this.phoneNumber,
    this.emailAddress,
  });

  factory RegisterRequest.fromJson(Map<String, dynamic> json) {
    return RegisterRequest(
      fullName: json['fullName'] as String,
      phoneNumber: json['phoneNumber'] as String,
      emailAddress: json['emailAddress'] as String?,
    );
  }

  final String fullName;
  final String phoneNumber;
  final String? emailAddress;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'fullName': fullName,
    'phoneNumber': phoneNumber,
    'emailAddress': emailAddress,
  };
}
