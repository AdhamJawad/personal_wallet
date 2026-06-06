abstract interface class ApiClient {
  Future<ApiResponse> delete(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> get(
    String path, {
    Map<String, String>? headers,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> patch(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> post(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParameters,
  });
  Future<ApiResponse> put(
    String path, {
    Map<String, String>? headers,
    Object? body,
    Map<String, dynamic>? queryParameters,
  });
}

class ApiResponse {
  const ApiResponse({
    required this.statusCode,
    this.data,
    this.headers = const <String, String>{},
  });

  final int statusCode;
  final Object? data;
  final Map<String, String> headers;

  bool get isSuccessful => statusCode >= 200 && statusCode < 300;
}
