import '../../domain/models/app_user.dart';

class MockAuthAccount {
  const MockAuthAccount({required this.user});

  factory MockAuthAccount.fromJson(Map<String, dynamic> json) {
    return MockAuthAccount(
      user: AppUser.fromJson(json['user'] as Map<String, dynamic>),
    );
  }

  final AppUser user;

  MockAuthAccount copyWith({AppUser? user}) {
    return MockAuthAccount(user: user ?? this.user);
  }

  Map<String, dynamic> toJson() => <String, dynamic>{'user': user.toJson()};
}
