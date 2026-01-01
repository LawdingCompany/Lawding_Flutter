import 'package:flutter_test/flutter_test.dart';
import 'package:lawding_flutter/data/annual_leave_calculator/calculator_params.dart';
import 'package:lawding_flutter/data/annual_leave_calculator/calculator_repository.dart';
import 'package:lawding_flutter/data/annual_leave_calculator/calculator_response.dart';
import 'package:lawding_flutter/data/network/dio_client.dart';
import 'package:lawding_flutter/data/network/network_error.dart';

import '../../helpers/mock_dio_helper.dart';

void main() {
  group('CalculatorRepository Tests', () {
    late MockDioHelper mockDioHelper;
    late DioClient dioClient;
    late CalculatorRepository repository;

    setUp(() {
      // 각 테스트 전에 Mock Dio와 Repository 초기화
      mockDioHelper = MockDioHelper(baseUrl: 'https://api.test.com');
      // Mock Dio를 DioClient에 주입
      dioClient = DioClient(
        baseUrl: 'https://api.test.com',
        dio: mockDioHelper.dio,
      );
      repository = CalculatorRepository(dioClient);
    });

    test('연차 계산 성공 - 정상적인 응답을 받으면 CalculatorResponse를 반환한다', () async {
      // Given: 테스트용 파라미터 준비
      final params = CalculatorCalculateParams(
        calculationType: 1,
        hireDate: '2023-01-01',
        referenceDate: '2024-01-01',
        nonWorkingPeriods: [],
        companyHolidays: [],
      );

      // Given: Mock 응답 데이터 설정
      final mockResponseData = {
        'totalAnnualLeaves': 15,
        'usedAnnualLeaves': 5,
        'remainingAnnualLeaves': 10,
        'calculationId': 'calc-123',
        'hireDate': '2023-01-01',
        'referenceDate': '2024-01-01',
      };

      mockDioHelper.mockPost(
        path: '/annual-leaves/calculate',
        responseData: mockResponseData,
        statusCode: 200,
      );

      // When: 연차 계산 API 호출
      final result = await repository.calculate(params);

      // Then: 올바른 CalculatorResponse 객체가 반환되는지 확인
      expect(result, isA<CalculatorResponse>());
      expect(result.totalAnnualLeaves, 15);
      expect(result.usedAnnualLeaves, 5);
      expect(result.remainingAnnualLeaves, 10);
      expect(result.calculationId, 'calc-123');
      expect(result.hireDate, '2023-01-01');
      expect(result.referenceDate, '2024-01-01');
    });

    test('연차 계산 실패 - 서버 에러 시 ServerError를 던진다', () async {
      // Given: 테스트용 파라미터 준비
      final params = CalculatorCalculateParams(
        calculationType: 1,
        hireDate: '2023-01-01',
        referenceDate: '2024-01-01',
        nonWorkingPeriods: [],
        companyHolidays: [],
      );

      // Given: 500 에러 응답 설정
      mockDioHelper.mockError(
        path: '/annual-leaves/calculate',
        method: 'POST',
        statusCode: 500,
        errorMessage: 'Internal Server Error',
      );

      // When & Then: ServerError가 발생하는지 확인
      expect(
        () => repository.calculate(params),
        throwsA(isA<ServerError>()),
      );
    });

    test('연차 계산 실패 - 401 에러 시 UnauthorizedError를 던진다', () async {
      // Given: 테스트용 파라미터 준비
      final params = CalculatorCalculateParams(
        calculationType: 1,
        hireDate: '2023-01-01',
        referenceDate: '2024-01-01',
        nonWorkingPeriods: [],
        companyHolidays: [],
      );

      // Given: 401 에러 응답 설정
      mockDioHelper.mockError(
        path: '/annual-leaves/calculate',
        method: 'POST',
        statusCode: 401,
        errorMessage: 'Unauthorized',
      );

      // When & Then: UnauthorizedError가 발생하는지 확인
      expect(
        () => repository.calculate(params),
        throwsA(isA<UnauthorizedError>()),
      );
    });

    test('연차 계산 실패 - 타임아웃 시 TimeoutError를 던진다', () async {
      // Given: 테스트용 파라미터 준비
      final params = CalculatorCalculateParams(
        calculationType: 1,
        hireDate: '2023-01-01',
        referenceDate: '2024-01-01',
        nonWorkingPeriods: [],
        companyHolidays: [],
      );

      // Given: 타임아웃 에러 설정
      mockDioHelper.mockTimeout(
        path: '/annual-leaves/calculate',
        method: 'POST',
      );

      // When & Then: TimeoutError가 발생하는지 확인
      expect(
        () => repository.calculate(params),
        throwsA(isA<TimeoutError>()),
      );
    });

    test('연차 계산 성공 - 비근무 기간이 있는 경우', () async {
      // Given: 비근무 기간이 포함된 파라미터
      final params = CalculatorCalculateParams(
        calculationType: 1,
        hireDate: '2023-01-01',
        referenceDate: '2024-01-01',
        nonWorkingPeriods: [
          const NonWorkingPeriod(
            type: 1,
            startDate: '2023-06-01',
            endDate: '2023-08-31',
          ),
        ],
        companyHolidays: ['2023-12-25'],
      );

      // Given: Mock 응답 데이터
      final mockResponseData = {
        'totalAnnualLeaves': 12,
        'usedAnnualLeaves': 3,
        'remainingAnnualLeaves': 9,
        'calculationId': 'calc-456',
        'hireDate': '2023-01-01',
        'referenceDate': '2024-01-01',
      };

      mockDioHelper.mockPost(
        path: '/annual-leaves/calculate',
        responseData: mockResponseData,
        statusCode: 200,
      );

      // When: 연차 계산 API 호출
      final result = await repository.calculate(params);

      // Then: 올바른 응답이 반환되는지 확인
      expect(result.totalAnnualLeaves, 12);
      expect(result.remainingAnnualLeaves, 9);
    });
  });
}
