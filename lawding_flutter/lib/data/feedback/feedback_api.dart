import '../network/api_endpoints.dart';
import '../network/api_request.dart';
import '../network/http_methods.dart';
import 'feedback_params.dart';

class FeedbackApi {
  FeedbackApi._();

  static ApiRequest submitFeedback(FeedbackParams params) {
    return ApiRequest(
      method: HttpMethod.post,
      path: ApiEndpoints.submitFeedback,
      body: params.toJson(),
    );
  }
}
