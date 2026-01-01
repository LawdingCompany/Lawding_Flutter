import '../network/dio_client.dart';
import 'feedback_api.dart';
import 'feedback_params.dart';

/// Data Layer Repository (테스트용)
/// Domain Layer와 분리된 순수 Data 처리
class FeedbackRepository {
  final DioClient _client;

  FeedbackRepository(this._client);

  /// 피드백 제출 API 호출
  Future<void> submitFeedback(FeedbackParams params) async {
    final request = FeedbackApi.submitFeedback(params);
    await _client.request(request);
  }
}
