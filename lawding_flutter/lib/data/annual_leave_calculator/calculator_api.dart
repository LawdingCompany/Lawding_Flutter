import '../network/api_endpoints.dart';
import '../network/api_request.dart';
import '../network/http_methods.dart';
import 'calculator_params.dart';

class CalculatorApi {
  CalculatorApi._();

  static ApiRequest calculate(CalculatorCalculateParams params) {
    return ApiRequest(
      method: HttpMethod.post,
      path: ApiEndpoints.calculate,
      body: params.toJson(),
    );
  }
}
