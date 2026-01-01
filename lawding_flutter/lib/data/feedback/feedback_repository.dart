import '../network/dio_client.dart';
import 'feedback_api.dart';
import 'feedback_params.dart';

class FeedbackRepository {
  final DioClient _client;

  FeedbackRepository(this._client);

  Future<void> submitFeedback(FeedbackParams params) async {
    final request = FeedbackApi.submitFeedback(params);
    await _client.request(request);
  }
}
