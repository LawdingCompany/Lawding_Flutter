import 'package:flutter_test/flutter_test.dart';
import 'package:lawding_flutter/data/feedback/feedback_repository_impl.dart';
import 'package:lawding_flutter/data/network/dio_client.dart';
import 'package:lawding_flutter/data/network/network_error.dart';
import 'package:lawding_flutter/domain/core/result.dart';
import 'package:lawding_flutter/domain/entities/feedback.dart' as domain;

import '../../helpers/mock_dio_helper.dart';

void main() {
  group('FeedbackRepository Tests', () {
    late MockDioHelper mockDioHelper;
    late DioClient dioClient;
    late FeedbackRepositoryImpl repository;

    setUp(() {
      // 각 테스트 전에 Mock Dio와 Repository 초기화
      mockDioHelper = MockDioHelper(baseUrl: 'https://api.test.com');
      // Mock Dio를 DioClient에 주입
      dioClient = DioClient(
        baseUrl: 'https://api.test.com',
        dio: mockDioHelper.dio,
      );
      repository = FeedbackRepositoryImpl(dioClient);
    });

    test('피드백 제출 성공 - 에러 리포트 타입', () async {
      // Given: 에러 리포트 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.errorReport,
        content: '앱이 종료되는 문제가 있습니다',
        email: 'test@example.com',
      );

      // Given: Mock 성공 응답 설정
      mockDioHelper.mockPost(
        path: '/v1/feedback',
        responseData: {'success': true, 'message': 'Feedback submitted'},
        statusCode: 200,
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Success 결과 확인
      expect(result, isA<Success<void, NetworkError>>());
      result.fold(
        onSuccess: (_) {
          // 성공
        },
        onFailure: (error) {
          fail('Should not fail but got error: $error');
        },
      );
    });

    test('피드백 제출 성공 - 만족도 평가 타입 (별점 포함)', () async {
      // Given: 만족도 평가 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.satisfaction,
        content: '앱이 매우 유용합니다!',
        rating: 5,
        calculationId: 'calc-123',
      );

      // Given: Mock 성공 응답 설정
      mockDioHelper.mockPost(
        path: '/v1/feedback',
        responseData: {'success': true},
        statusCode: 201,
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Success 결과 확인
      expect(result, isA<Success<void, NetworkError>>());
    });

    test('피드백 제출 성공 - 개선 제안 타입', () async {
      // Given: 개선 제안 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.improvement,
        content: '다크모드를 추가해주세요',
        email: 'user@example.com',
      );

      // Given: Mock 성공 응답 설정
      mockDioHelper.mockPost(
        path: '/v1/feedback',
        responseData: {'success': true},
        statusCode: 200,
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Success 결과 확인
      expect(result, isA<Success<void, NetworkError>>());
    });

    test('피드백 제출 성공 - 질문 타입 (최소 정보만)', () async {
      // Given: 최소 정보만 포함된 질문 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.question,
        content: '연차 계산 방식이 궁금합니다',
      );

      // Given: Mock 성공 응답 설정
      mockDioHelper.mockPost(
        path: '/v1/feedback',
        responseData: {'success': true},
        statusCode: 200,
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Success 결과 확인
      expect(result, isA<Success<void, NetworkError>>());
    });

    test('피드백 제출 성공 - 기타 타입', () async {
      // Given: 기타 타입 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.other,
        content: '기타 의견입니다',
      );

      // Given: Mock 성공 응답 설정
      mockDioHelper.mockPost(
        path: '/v1/feedback',
        responseData: {'success': true},
        statusCode: 200,
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Success 결과 확인
      expect(result, isA<Success<void, NetworkError>>());
    });

    test('피드백 제출 성공 - 계산 데이터 포함', () async {
      // Given: 계산 ID가 포함된 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.errorReport,
        content: '계산 결과가 이상합니다',
        email: 'user@test.com',
        calculationId: 'calc-456',
      );

      // Given: Mock 성공 응답 설정
      mockDioHelper.mockPost(
        path: '/v1/feedback',
        responseData: {'success': true},
        statusCode: 200,
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Success 결과 확인
      expect(result, isA<Success<void, NetworkError>>());
    });

    test('피드백 제출 실패 - 서버 에러 (500)', () async {
      // Given: 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.errorReport,
        content: '에러 내용',
      );

      // Given: 500 에러 응답 설정
      mockDioHelper.mockError(
        path: '/v1/feedback',
        method: 'POST',
        statusCode: 500,
        errorMessage: 'Internal Server Error',
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Failure with ServerError
      expect(result, isA<Failure<void, NetworkError>>());
      result.fold(
        onSuccess: (_) {
          fail('Should fail with ServerError');
        },
        onFailure: (error) {
          expect(error, isA<ServerError>());
          expect((error as ServerError).statusCode, 500);
        },
      );
    });

    test('피드백 제출 실패 - 인증 에러 (401)', () async {
      // Given: 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.improvement,
        content: '개선 제안',
      );

      // Given: 401 에러 응답 설정
      mockDioHelper.mockError(
        path: '/v1/feedback',
        method: 'POST',
        statusCode: 401,
        errorMessage: 'Unauthorized',
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Failure with UnauthorizedError
      expect(result, isA<Failure<void, NetworkError>>());
      result.fold(
        onSuccess: (_) {
          fail('Should fail with UnauthorizedError');
        },
        onFailure: (error) {
          expect(error, isA<UnauthorizedError>());
        },
      );
    });

    test('피드백 제출 실패 - 타임아웃', () async {
      // Given: 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.question,
        content: '질문 내용',
      );

      // Given: 타임아웃 에러 설정
      mockDioHelper.mockTimeout(
        path: '/v1/feedback',
        method: 'POST',
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Failure with TimeoutError
      expect(result, isA<Failure<void, NetworkError>>());
      result.fold(
        onSuccess: (_) {
          fail('Should fail with TimeoutError');
        },
        onFailure: (error) {
          expect(error, isA<TimeoutError>());
        },
      );
    });

    test('피드백 제출 실패 - 잘못된 요청 (400)', () async {
      // Given: 피드백
      const feedback = domain.Feedback(
        category: domain.FeedbackCategory.satisfaction,
        rating: 3,
      );

      // Given: 400 에러 응답 설정
      mockDioHelper.mockError(
        path: '/v1/feedback',
        method: 'POST',
        statusCode: 400,
        errorMessage: 'Bad Request - Missing required field: content',
      );

      // When: 피드백 제출
      final result = await repository.submitFeedback(feedback);

      // Then: Failure with ServerError
      expect(result, isA<Failure<void, NetworkError>>());
      result.fold(
        onSuccess: (_) {
          fail('Should fail with ServerError');
        },
        onFailure: (error) {
          expect(error, isA<ServerError>());
          expect((error as ServerError).statusCode, 400);
          expect(error.message, contains('Bad Request'));
        },
      );
    });
  });
}
