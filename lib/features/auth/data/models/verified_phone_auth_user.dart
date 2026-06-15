class VerifiedPhoneAuthUser {
  const VerifiedPhoneAuthUser({
    required this.uid,
    required this.phoneNumber,
    this.displayName,
    this.emailAddress,
    this.profileImageUri,
    required this.isNewUser,
  });

  final String uid;
  final String phoneNumber;
  final String? displayName;
  final String? emailAddress;
  final String? profileImageUri;
  final bool isNewUser;
}
