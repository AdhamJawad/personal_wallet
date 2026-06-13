class LoginRequest {
  const LoginRequest({required this.phoneNumber});

  factory LoginRequest.fromJson(Map<String, dynamic> json) {
    return LoginRequest(phoneNumber: json['phoneNumber'] as String);
  }

  final String phoneNumber;

  Map<String, dynamic> toJson() => <String, dynamic>{
    'phoneNumber': phoneNumber,
  };
}
