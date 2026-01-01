/// 네트워크 계층에서 발생하는 공통 에러
sealed class NetworkError implements Exception {
  const NetworkError();
}

/// URL 생성 실패
class InvalidUrlError extends NetworkError {
  const InvalidUrlError();
}

/// 타임아웃
class TimeoutError extends NetworkError {
  const TimeoutError();
}

/// 인증 실패 (401)
class UnauthorizedError extends NetworkError {
  const UnauthorizedError();
}

/// 서버 에러
class ServerError extends NetworkError {
  final int? statusCode;
  final String message;

  const ServerError({required this.message, this.statusCode});
}

/// 알 수 없는 에러
class UnknownNetworkError extends NetworkError {
  const UnknownNetworkError();
}

/// 인터넷 연결 불가 (오프라인 등)
class NetworkConnectionError extends NetworkError {
  const NetworkConnectionError();
}
