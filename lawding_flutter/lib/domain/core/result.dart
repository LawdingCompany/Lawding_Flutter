/// 성공 또는 실패를 나타내는 Result 타입
/// Swift의 Result\<Success, Failure\>와 유사
sealed class Result<S, F> {
  const Result();
}

/// 성공 케이스
class Success<S, F> extends Result<S, F> {
  final S value;
  const Success(this.value);
}

/// 실패 케이스
class Failure<S, F> extends Result<S, F> {
  final F error;
  const Failure(this.error);
}

/// Result 확장 메서드
extension ResultExtension<S, F> on Result<S, F> {
  /// 성공 여부 확인
  bool get isSuccess => this is Success<S, F>;

  /// 실패 여부 확인
  bool get isFailure => this is Failure<S, F>;

  /// 성공 값 가져오기 (실패 시 null)
  S? get valueOrNull => switch (this) {
        Success(value: final v) => v,
        _ => null,
      };

  /// 에러 가져오기 (성공 시 null)
  F? get errorOrNull => switch (this) {
        Failure(error: final e) => e,
        _ => null,
      };

  /// map: 성공 값 변환
  Result<T, F> map<T>(T Function(S) transform) {
    return switch (this) {
      Success(value: final v) => Success(transform(v)),
      Failure(error: final e) => Failure(e),
    };
  }

  /// flatMap: 성공 값을 다른 Result로 변환
  Result<T, F> flatMap<T>(Result<T, F> Function(S) transform) {
    return switch (this) {
      Success(value: final v) => transform(v),
      Failure(error: final e) => Failure(e),
    };
  }

  /// fold: 성공/실패 케이스 모두 처리
  T fold<T>({
    required T Function(S) onSuccess,
    required T Function(F) onFailure,
  }) {
    return switch (this) {
      Success(value: final v) => onSuccess(v),
      Failure(error: final e) => onFailure(e),
    };
  }

  /// getOrElse: 성공 값 또는 기본값 반환
  S getOrElse(S Function() defaultValue) {
    return switch (this) {
      Success(value: final v) => v,
      _ => defaultValue(),
    };
  }
}
