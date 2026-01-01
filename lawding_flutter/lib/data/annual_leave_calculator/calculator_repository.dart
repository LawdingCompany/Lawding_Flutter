import '../network/dio_client.dart';
import 'calculator_api.dart';
import 'calculator_params.dart';
import 'calculator_response.dart';

class CalculatorRepository {
  final DioClient _client;

  CalculatorRepository(this._client);

  Future<CalculatorResponse> calculate(CalculatorCalculateParams params) async {
    final request = CalculatorApi.calculate(params);
    final response = await _client.request(request);
    return CalculatorResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
