class AppUser {
  const AppUser({
    required this.userId,
    required this.phoneNumber,
    required this.displayName,
    this.emailAddress,
    this.profileImageUri,
    required this.isVerified,
    required this.personalQrToken,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      userId: (json['userId'] ?? json['id']) as String,
      phoneNumber: json['phoneNumber'] as String,
      displayName: json['displayName'] as String,
      emailAddress: _normalizeOptionalString(json['emailAddress'] as String?),
      profileImageUri: _normalizeOptionalString(
        json['profileImageUri'] as String?,
      ),
      isVerified: (json['isVerified'] as bool?) ?? false,
      personalQrToken: json['personalQrToken'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );
  }

  final String userId;
  final String phoneNumber;
  final String displayName;
  final String? emailAddress;
  final String? profileImageUri;
  final bool isVerified;
  final String personalQrToken;
  final DateTime createdAt;
  final DateTime updatedAt;

  String get id => userId;

  AppUser copyWith({
    String? userId,
    String? phoneNumber,
    String? displayName,
    String? emailAddress,
    bool clearEmailAddress = false,
    String? profileImageUri,
    bool clearProfileImageUri = false,
    bool? isVerified,
    String? personalQrToken,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return AppUser(
      userId: userId ?? this.userId,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      displayName: displayName ?? this.displayName,
      emailAddress: clearEmailAddress
          ? null
          : emailAddress ?? this.emailAddress,
      profileImageUri: clearProfileImageUri
          ? null
          : profileImageUri ?? this.profileImageUri,
      isVerified: isVerified ?? this.isVerified,
      personalQrToken: personalQrToken ?? this.personalQrToken,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'userId': userId,
    'phoneNumber': phoneNumber,
    'displayName': displayName,
    'emailAddress': emailAddress,
    'profileImageUri': profileImageUri,
    'isVerified': isVerified,
    'personalQrToken': personalQrToken,
    'createdAt': createdAt.toIso8601String(),
    'updatedAt': updatedAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AppUser &&
            other.userId == userId &&
            other.phoneNumber == phoneNumber &&
            other.displayName == displayName &&
            other.emailAddress == emailAddress &&
            other.profileImageUri == profileImageUri &&
            other.isVerified == isVerified &&
            other.personalQrToken == personalQrToken &&
            other.createdAt == createdAt &&
            other.updatedAt == updatedAt;
  }

  @override
  int get hashCode => Object.hash(
    userId,
    phoneNumber,
    displayName,
    emailAddress,
    profileImageUri,
    isVerified,
    personalQrToken,
    createdAt,
    updatedAt,
  );
}

String? _normalizeOptionalString(String? value) {
  final String? trimmed = value?.trim();
  return (trimmed == null || trimmed.isEmpty) ? null : trimmed;
}
