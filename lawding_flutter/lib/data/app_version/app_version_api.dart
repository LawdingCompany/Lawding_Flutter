import '../network/api_endpoints.dart';
import '../network/api_request.dart';
import '../network/http_methods.dart';

class AppVersionApi {
  AppVersionApi._();

  /// 앱 버전 체크 API
  /// GET /v1/app/version-check?platform=[ios]&client-version=[1.0.0]
  static ApiRequest checkVersion({
    required String platform,
    required String clientVersion,
  }) {
    return ApiRequest(
      method: HttpMethod.get,
      path: ApiEndpoints.checkVersion,
      queryParameters: {
        'platform': platform,
        'client-version': clientVersion,
      },
    );
  }
}
