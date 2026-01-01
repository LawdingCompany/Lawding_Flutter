import 'http_methods.dart';

class ApiRequest {
  final HttpMethod method;
  final String path;
  final Map<String, dynamic>? headers;
  final Map<String, dynamic>? queryParameters;
  final dynamic body;

  const ApiRequest({
    required this.method,
    required this.path,
    this.headers,
    this.queryParameters,
    this.body,
  });
}
