class AuthOperationResult {
  const AuthOperationResult({required this.isSuccess, required this.message});

  factory AuthOperationResult.success(String message) {
    return AuthOperationResult(isSuccess: true, message: message);
  }

  factory AuthOperationResult.failure(String message) {
    return AuthOperationResult(isSuccess: false, message: message);
  }

  final bool isSuccess;
  final String message;
}
