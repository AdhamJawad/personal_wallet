import 'app_user.dart';

class AuthSession {
  const AuthSession({
    required this.sessionId,
    required this.user,
    required this.biometricUnlocked,
    required this.issuedAt,
    required this.expiresAt,
  });

  factory AuthSession.fromJson(Map<String, dynamic> json) {
    return AuthSession(
      sessionId: (json['sessionId'] ?? json['id']) as String,
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
      biometricUnlocked: (json['biometricUnlocked'] as bool?) ?? false,
      issuedAt: DateTime.parse(json['issuedAt'] as String),
      expiresAt: DateTime.parse(json['expiresAt'] as String),
    );
  }

  final String sessionId;
  final AppUser user;
  final bool biometricUnlocked;
  final DateTime issuedAt;
  final DateTime expiresAt;

  String get id => sessionId;

  AuthSession copyWith({
    String? sessionId,
    AppUser? user,
    bool? biometricUnlocked,
    DateTime? issuedAt,
    DateTime? expiresAt,
  }) {
    return AuthSession(
      sessionId: sessionId ?? this.sessionId,
      user: user ?? this.user,
      biometricUnlocked: biometricUnlocked ?? this.biometricUnlocked,
      issuedAt: issuedAt ?? this.issuedAt,
      expiresAt: expiresAt ?? this.expiresAt,
    );
  }

  Map<String, dynamic> toJson() => <String, dynamic>{
    'sessionId': sessionId,
    'user': user.toJson(),
    'biometricUnlocked': biometricUnlocked,
    'issuedAt': issuedAt.toIso8601String(),
    'expiresAt': expiresAt.toIso8601String(),
  };

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is AuthSession &&
            other.sessionId == sessionId &&
            other.user == user &&
            other.biometricUnlocked == biometricUnlocked &&
            other.issuedAt == issuedAt &&
            other.expiresAt == expiresAt;
  }

  @override
  int get hashCode =>
      Object.hash(sessionId, user, biometricUnlocked, issuedAt, expiresAt);
}
