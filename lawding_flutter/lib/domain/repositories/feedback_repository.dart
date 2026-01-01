import '../core/result.dart';
import '../entities/feedback.dart';
import '../../data/network/network_error.dart';

/// 피드백 Repository 인터페이스
/// Data Layer와 Domain Layer를 분리하는 추상화
abstract interface class FeedbackRepository {
  /// 피드백 제출
  Future<Result<void, NetworkError>> submitFeedback(Feedback feedback);
}
