import '../core/result.dart';
import '../entities/feedback.dart';
import '../repositories/feedback_repository.dart';
import '../../data/network/network_error.dart';

/// 피드백 제출 UseCase
class SubmitFeedbackUseCase {
  final FeedbackRepository _repository;

  SubmitFeedbackUseCase(this._repository);

  /// 피드백 제출 실행
  Future<Result<void, NetworkError>> execute(Feedback feedback) async {
    // 비즈니스 검증 로직
    if (feedback.category == FeedbackCategory.satisfaction &&
        !feedback.hasValidRating) {
      return const Failure(
        ServerError(
          message: '만족도 평가는 1~5점 사이의 별점이 필요합니다',
          statusCode: 400,
        ),
      );
    }

    if (feedback.category == FeedbackCategory.errorReport &&
        !feedback.hasContent) {
      return const Failure(
        ServerError(
          message: '오류 신고는 내용이 필요합니다',
          statusCode: 400,
        ),
      );
    }

    // Repository를 통해 데이터 전송
    return await _repository.submitFeedback(feedback);
  }
}
