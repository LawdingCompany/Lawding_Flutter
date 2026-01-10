# Firebase Analytics & Crashlytics 사용 가이드

## 개요

이 문서는 앱에서 Firebase Analytics와 Crashlytics를 사용하는 방법을 설명합니다.

## 서비스 위치

- `lib/infrastructure/services/analytics_service.dart`
- `lib/infrastructure/services/crashlytics_service.dart`

## Analytics 사용법

### 기본 사용

```dart
final analytics = AnalyticsService();

// 화면 조회 이벤트
await analytics.logScreenView('calculator_screen');

// 커스텀 이벤트
await analytics.logCalculationStarted('HIRE_DATE_BASED');
```

### 주요 이벤트 목록

#### 앱 생애주기 이벤트
- `logAppLaunched()` - 앱 시작
- `logSplashCompleted(duration)` - 스플래시 완료

#### 계산 관련 이벤트
- `logCalculationTypeSelected(type)` - 계산 타입 선택
- `logHireDateSelected(date)` - 입사일 선택
- `logReferenceDateSelected(date)` - 기준일 선택
- `logFiscalYearStartMonthSelected(month)` - 회계연도 시작월 선택
- `logCalculationStarted(type)` - 계산 시작
- `logCalculationCompleted(...)` - 계산 완료
- `logCalculationFailed(...)` - 계산 실패

#### 특이사항 기간 이벤트
- `logNonWorkingPeriodAdded(type)` - 특이사항 기간 추가
- `logNonWorkingPeriodRemoved(type)` - 특이사항 기간 삭제

#### 회사 휴무일 이벤트
- `logCompanyHolidayAdded(name)` - 회사 휴무일 추가
- `logCompanyHolidayRemoved(name)` - 회사 휴무일 삭제

#### 계산 상세 이벤트
- `logCalculationDetailViewed(leaveType)` - 계산 기준 설명 보기
- `logDetailSegmentChanged(segmentType)` - 월차/비례연차 세그먼트 변경

#### 도움말 이벤트
- `logHelpButtonClicked(helpType)` - 도움말 버튼 클릭
- `logHelpSheetExpanded(helpType)` - 도움말 시트 확장

#### 피드백 이벤트
- `logFeedbackScreenOpened(calculationId)` - 피드백 화면 열기
- `logFeedbackTypeSelected(type)` - 피드백 타입 선택
- `logFeedbackSubmitStarted(...)` - 피드백 제출 시작
- `logFeedbackSubmitted(...)` - 피드백 제출 성공
- `logFeedbackSubmitFailed(...)` - 피드백 제출 실패

#### 웹뷰 이벤트
- `logWebViewOpened(url, title)` - 웹뷰 열기
- `logExternalLinkClicked(linkType, url)` - 외부 링크 클릭

#### 약관 이벤트
- `logTermsAgreed()` - 약관 동의
- `logPrivacyPolicyViewed()` - 개인정보처리방침 보기

### 사용자 속성 설정

```dart
// 사용자 속성 설정
await analytics.setUserProperty('user_type', 'premium');

// 사용자 ID 설정
await analytics.setUserId('user_12345');
```

## Crashlytics 사용법

### 기본 에러 기록

```dart
final crashlytics = CrashlyticsService();

try {
  // 위험한 작업
} catch (e, stack) {
  await crashlytics.recordError(e, stack, fatal: false);
}
```

### 컨텍스트 정보 설정

```dart
// 계산 컨텍스트 설정
await crashlytics.setCalculationContext(
  calculationType: 'HIRE_DATE_BASED',
  calculationId: 'calc_123',
  hireDate: '2023-01-01',
  referenceDate: '2024-01-01',
);

// API 컨텍스트 설정
await crashlytics.setApiContext(
  endpoint: '/api/calculate',
  method: 'POST',
  statusCode: 200,
);

// 화면 컨텍스트 설정
await crashlytics.setScreenContext('calculator_screen');
```

### 특정 에러 타입 기록

#### 네트워크 에러
```dart
await crashlytics.recordNetworkError(
  endpoint: '/api/calculate',
  method: 'POST',
  error: error,
  stack: stackTrace,
  statusCode: 500,
);
```

#### 계산 에러
```dart
await crashlytics.recordCalculationError(
  calculationType: 'HIRE_DATE_BASED',
  error: error,
  stack: stackTrace,
  additionalData: {
    'hire_date': '2023-01-01',
    'reference_date': '2024-01-01',
  },
);
```

#### UI 에러
```dart
await crashlytics.recordUIError(
  screenName: 'calculator_screen',
  error: error,
  stack: stackTrace,
  action: 'button_click',
);
```

#### 검증 에러
```dart
await crashlytics.recordValidationError(
  field: 'hire_date',
  message: 'Invalid date format',
  value: '2023-13-01',
);
```

### 커스텀 키 설정

```dart
await crashlytics.setCustomKey('feature_flag', 'new_calculation_enabled');
await crashlytics.setCustomKey('app_language', 'ko');
```

### 로그 메시지

```dart
await crashlytics.log('User started calculation');
await crashlytics.log('API request sent: POST /api/calculate');
```

## 실제 사용 예시

### CalculatorViewModel에서 사용

```dart
class CalculatorViewModel extends StateNotifier<CalculatorState> {
  final _analytics = AnalyticsService();
  final _crashlytics = CrashlyticsService();

  Future<void> calculate() async {
    try {
      // 계산 시작 이벤트
      await _analytics.logCalculationStarted(state.calculationType.displayName);

      // 컨텍스트 설정
      await _crashlytics.setCalculationContext(
        calculationType: state.calculationType.displayName,
        hireDate: state.hireDate?.toString(),
        referenceDate: state.referenceDate?.toString(),
      );

      // API 호출
      final result = await _repository.calculate(...);

      // 계산 완료 이벤트
      await _analytics.logCalculationCompleted(
        calculationType: state.calculationType.displayName,
        leaveType: result.leaveType,
        totalDays: result.totalDays,
        serviceYears: result.serviceYears,
      );
    } catch (e, stack) {
      // 에러 기록
      await _crashlytics.recordCalculationError(
        calculationType: state.calculationType.displayName,
        error: e,
        stack: stack,
      );

      // 계산 실패 이벤트
      await _analytics.logCalculationFailed(
        calculationType: state.calculationType.displayName,
        errorMessage: e.toString(),
      );
    }
  }
}
```

### FeedbackViewModel에서 사용

```dart
class FeedbackViewModel extends StateNotifier<FeedbackState> {
  final _analytics = AnalyticsService();
  final _crashlytics = CrashlyticsService();

  Future<void> submitFeedback() async {
    try {
      // 제출 시작 이벤트
      await _analytics.logFeedbackSubmitStarted(
        feedbackType: _feedbackTypes[state.selectedTypeIndex],
        includeCalculationData: state.includeCalculationData,
      );

      // API 호출
      await _repository.submitFeedback(...);

      // 제출 성공 이벤트
      await _analytics.logFeedbackSubmitted(
        feedbackType: _feedbackTypes[state.selectedTypeIndex],
        includeCalculationData: state.includeCalculationData,
      );
    } catch (e, stack) {
      // 에러 기록
      await _crashlytics.recordNetworkError(
        endpoint: '/api/feedback',
        method: 'POST',
        error: e,
        stack: stack,
      );

      // 제출 실패 이벤트
      await _analytics.logFeedbackSubmitFailed(
        feedbackType: _feedbackTypes[state.selectedTypeIndex],
        errorMessage: e.toString(),
      );
    }
  }
}
```

## 주의사항

1. **개인정보 보호**: 사용자의 개인정보(이름, 이메일 등)를 직접 이벤트나 로그에 포함하지 마세요.
2. **디버그 모드**: Crashlytics는 디버그 모드에서 자동으로 비활성화됩니다.
3. **에러 처리**: 모든 중요한 작업은 try-catch로 감싸서 에러를 기록하세요.
4. **컨텍스트**: 에러 발생 시 추적을 쉽게 하기 위해 충분한 컨텍스트 정보를 설정하세요.

## 대시보드 확인

- **Analytics**: [Firebase Console](https://console.firebase.google.com) > Analytics
- **Crashlytics**: [Firebase Console](https://console.firebase.google.com) > Crashlytics
