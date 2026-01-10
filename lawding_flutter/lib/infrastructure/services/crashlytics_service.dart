import 'dart:async';

import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';

class CrashlyticsService {
  static final CrashlyticsService _instance = CrashlyticsService._internal();
  factory CrashlyticsService() => _instance;
  CrashlyticsService._internal();

  final FirebaseCrashlytics _crashlytics = FirebaseCrashlytics.instance;

  /// Crashlytics 초기화
  Future<void> initialize() async {
    // 디버그 모드에서는 수집하지 않음
    await _crashlytics.setCrashlyticsCollectionEnabled(!kDebugMode);

    // Flutter 프레임워크 에러 캐치
    FlutterError.onError = _crashlytics.recordFlutterFatalError;

    // 비동기 에러 캐치
    PlatformDispatcher.instance.onError = (error, stack) {
      _crashlytics.recordError(error, stack, fatal: true);
      return true;
    };
  }

  /// 에러 기록
  Future<void> recordError(
    dynamic exception,
    StackTrace? stack, {
    dynamic reason,
    bool fatal = false,
  }) async {
    await _crashlytics.recordError(
      exception,
      stack,
      reason: reason,
      fatal: fatal,
    );
  }

  /// 메시지 로그
  Future<void> log(String message) async {
    await _crashlytics.log(message);
  }

  /// 사용자 ID 설정
  Future<void> setUserId(String userId) async {
    await _crashlytics.setUserIdentifier(userId);
  }

  /// 커스텀 키 설정
  Future<void> setCustomKey(String key, dynamic value) async {
    await _crashlytics.setCustomKey(key, value);
  }

  /// 계산 관련 정보 설정
  Future<void> setCalculationContext({
    required String calculationType,
    String? calculationId,
    String? hireDate,
    String? referenceDate,
  }) async {
    await _crashlytics.setCustomKey('calculation_type', calculationType);
    if (calculationId != null) {
      await _crashlytics.setCustomKey('calculation_id', calculationId);
    }
    if (hireDate != null) {
      await _crashlytics.setCustomKey('hire_date', hireDate);
    }
    if (referenceDate != null) {
      await _crashlytics.setCustomKey('reference_date', referenceDate);
    }
  }

  /// API 호출 정보 설정
  Future<void> setApiContext({
    required String endpoint,
    required String method,
    int? statusCode,
  }) async {
    await _crashlytics.setCustomKey('api_endpoint', endpoint);
    await _crashlytics.setCustomKey('api_method', method);
    if (statusCode != null) {
      await _crashlytics.setCustomKey('api_status_code', statusCode);
    }
  }

  /// 화면 정보 설정
  Future<void> setScreenContext(String screenName) async {
    await _crashlytics.setCustomKey('current_screen', screenName);
  }

  /// 네트워크 에러 기록
  Future<void> recordNetworkError({
    required String endpoint,
    required String method,
    required dynamic error,
    StackTrace? stack,
    int? statusCode,
  }) async {
    await setApiContext(
      endpoint: endpoint,
      method: method,
      statusCode: statusCode,
    );
    await log('Network Error: $method $endpoint - $error');
    await recordError(error, stack, reason: 'Network Error');
  }

  /// 계산 에러 기록
  Future<void> recordCalculationError({
    required String calculationType,
    required dynamic error,
    StackTrace? stack,
    Map<String, dynamic>? additionalData,
  }) async {
    await setCustomKey('error_type', 'calculation');
    await setCustomKey('calculation_type', calculationType);

    if (additionalData != null) {
      for (var entry in additionalData.entries) {
        await setCustomKey(entry.key, entry.value);
      }
    }

    await log('Calculation Error: $calculationType - $error');
    await recordError(error, stack, reason: 'Calculation Error');
  }

  /// UI 에러 기록
  Future<void> recordUIError({
    required String screenName,
    required dynamic error,
    StackTrace? stack,
    String? action,
  }) async {
    await setCustomKey('error_type', 'ui');
    await setCustomKey('screen_name', screenName);
    if (action != null) {
      await setCustomKey('user_action', action);
    }

    await log('UI Error: $screenName - $error');
    await recordError(error, stack, reason: 'UI Error');
  }

  /// 데이터 검증 에러 기록
  Future<void> recordValidationError({
    required String field,
    required String message,
    dynamic value,
  }) async {
    await setCustomKey('error_type', 'validation');
    await setCustomKey('validation_field', field);
    await setCustomKey('validation_message', message);
    if (value != null) {
      await setCustomKey('validation_value', value.toString());
    }

    await log('Validation Error: $field - $message');
  }

  /// 테스트 크래시 발생 (디버그 전용)
  void testCrash() {
    if (kDebugMode) {
      _crashlytics.crash();
    }
  }

  /// 강제로 크래시 리포트 전송
  Future<void> sendUnsentReports() async {
    await _crashlytics.sendUnsentReports();
  }

  /// 크래시 리포트 삭제
  Future<void> deleteUnsentReports() async {
    await _crashlytics.deleteUnsentReports();
  }

  /// 크래시 발생 여부 확인
  Future<bool> didCrashOnPreviousExecution() async {
    return await _crashlytics.didCrashOnPreviousExecution();
  }
}
