# Analytics & Crashlytics 통합 예시

이 문서는 각 ViewModel에서 Analytics와 Crashlytics를 어떻게 통합할지 예시를 제공합니다.

## CalculatorViewModel 통합 예시

```dart
import '../../../infrastructure/services/analytics_service.dart';
import '../../../infrastructure/services/crashlytics_service.dart';

@riverpod
class CalculatorViewModel extends _$CalculatorViewModel {
  final _analytics = AnalyticsService();
  final _crashlytics = CrashlyticsService();

  void setCalculationType(int index) {
    final type = index == 0 ? CalculationType.standard : CalculationType.proRated;
    state = state.copyWith(calculationType: type);

    // Analytics 이벤트 기록
    _analytics.logCalculationTypeSelected(type.displayName);
  }

  void setHireDate(DateTime date) {
    state = state.copyWith(hireDate: date);

    // Analytics 이벤트 기록
    _analytics.logHireDateSelected(DateFormatter.toApiFormat(date));
  }

  void setReferenceDate(DateTime date) {
    state = state.copyWith(referenceDate: date);

    // Analytics 이벤트 기록
    _analytics.logReferenceDateSelected(DateFormatter.toApiFormat(date));
  }

  void setFiscalYearStartMonth(int month) {
    state = state.copyWith(fiscalYearStartMonth: month);

    // Analytics 이벤트 기록
    _analytics.logFiscalYearStartMonthSelected(month);
  }

  String? addNonWorkingPeriodFromMap(Map<String, dynamic> data) {
    try {
      final startDate = DateTime.parse(data['startDate'] as String);
      final endDate = DateTime.parse(data['endDate'] as String);
      final type = data['type'] as int;
      final displayName = data['displayName'] as String;

      final validationError = validateNonWorkingPeriod(
        startDate: startDate,
        endDate: endDate,
      );

      if (validationError != null) {
        // 검증 에러 기록
        _crashlytics.recordValidationError(
          field: 'non_working_period',
          message: validationError,
          value: data,
        );
        return validationError;
      }

      final period = NonWorkingPeriod(
        type: type,
        startDate: startDate,
        endDate: endDate,
        displayName: displayName,
      );

      final updated = [...state.nonWorkingPeriods, period];
      state = state.copyWith(nonWorkingPeriods: updated);

      // Analytics 이벤트 기록
      _analytics.logNonWorkingPeriodAdded(displayName);

      return null;
    } catch (e, stack) {
      // 에러 기록
      _crashlytics.recordError(
        e,
        stack,
        reason: 'Failed to add non-working period',
      );
      return '데이터 처리 중 오류가 발생했습니다.';
    }
  }

  void removeNonWorkingPeriod(int index) {
    final removed = state.nonWorkingPeriods[index];
    final updated = List<NonWorkingPeriod>.from(state.nonWorkingPeriods)
      ..removeAt(index);
    state = state.copyWith(nonWorkingPeriods: updated);

    // Analytics 이벤트 기록
    _analytics.logNonWorkingPeriodRemoved(removed.displayName);
  }

  String? addCompanyHolidayFromMap(Map<String, dynamic> data) {
    try {
      final date = DateTime.parse(data['date'] as String);
      final displayName = data['displayName'] as String;

      final validationError = validateCompanyHoliday(date: date);

      if (validationError != null) {
        // 검증 에러 기록
        _crashlytics.recordValidationError(
          field: 'company_holiday',
          message: validationError,
          value: data,
        );
        return validationError;
      }

      final holiday = CompanyHoliday(
        date: date,
        displayName: displayName,
      );

      final updated = [...state.companyHolidays, holiday];
      state = state.copyWith(companyHolidays: updated);

      // Analytics 이벤트 기록
      _analytics.logCompanyHolidayAdded(displayName);

      return null;
    } catch (e, stack) {
      // 에러 기록
      _crashlytics.recordError(
        e,
        stack,
        reason: 'Failed to add company holiday',
      );
      return '데이터 처리 중 오류가 발생했습니다.';
    }
  }

  void removeCompanyHoliday(int index) {
    final removed = state.companyHolidays[index];
    final updated = List<CompanyHoliday>.from(state.companyHolidays)
      ..removeAt(index);
    state = state.copyWith(companyHolidays: updated);

    // Analytics 이벤트 기록
    _analytics.logCompanyHolidayRemoved(removed.displayName);
  }

  Future<AnnualLeave?> calculate() async {
    final repository = ref.read(annualLeaveRepositoryProvider);

    try {
      // 계산 시작 이벤트
      await _analytics.logCalculationStarted(state.calculationType.displayName);

      // Crashlytics 컨텍스트 설정
      await _crashlytics.setCalculationContext(
        calculationType: state.calculationType.displayName,
        hireDate: state.hireDate != null
          ? DateFormatter.toApiFormat(state.hireDate!)
          : null,
        referenceDate: state.referenceDate != null
          ? DateFormatter.toApiFormat(state.referenceDate!)
          : null,
      );

      state = state.copyWith(isLoading: true);

      final result = await repository.calculate(
        calculationType: state.calculationType.code,
        hireDate: DateFormatter.toApiFormat(state.hireDate!),
        referenceDate: DateFormatter.toApiFormat(state.referenceDate!),
        fiscalYearStartMonth: state.fiscalYearStartMonth,
        nonWorkingPeriods: state.nonWorkingPeriods,
        companyHolidays: state.companyHolidays,
      );

      return result.when(
        success: (annualLeave) {
          state = state.copyWith(isLoading: false);

          // 계산 완료 이벤트
          _analytics.logCalculationCompleted(
            calculationType: state.calculationType.displayName,
            leaveType: annualLeave.leaveType,
            totalDays: annualLeave.totalDays,
            serviceYears: annualLeave.serviceYears ?? 0,
          );

          return annualLeave;
        },
        failure: (error) {
          state = state.copyWith(isLoading: false);

          // 네트워크 에러 기록
          if (error is NetworkError) {
            _crashlytics.recordNetworkError(
              endpoint: '/api/calculate',
              method: 'POST',
              error: error,
              statusCode: error.statusCode,
            );
          } else {
            _crashlytics.recordCalculationError(
              calculationType: state.calculationType.displayName,
              error: error,
            );
          }

          // 계산 실패 이벤트
          _analytics.logCalculationFailed(
            calculationType: state.calculationType.displayName,
            errorMessage: error.toString(),
          );

          return null;
        },
      );
    } catch (e, stack) {
      state = state.copyWith(isLoading: false);

      // 예상치 못한 에러 기록
      _crashlytics.recordCalculationError(
        calculationType: state.calculationType.displayName,
        error: e,
        stack: stack,
      );

      _analytics.logCalculationFailed(
        calculationType: state.calculationType.displayName,
        errorMessage: e.toString(),
      );

      return null;
    }
  }
}
```

## FeedbackViewModel 통합 예시

```dart
import '../../../infrastructure/services/analytics_service.dart';
import '../../../infrastructure/services/crashlytics_service.dart';

@riverpod
class FeedbackViewModel extends _$FeedbackViewModel {
  final _analytics = AnalyticsService();
  final _crashlytics = CrashlyticsService();

  @override
  FeedbackState build() {
    return FeedbackState();
  }

  void setFeedbackType(int index) {
    state = state.copyWith(selectedTypeIndex: index);

    // Analytics 이벤트 기록
    final types = ['오류 제보', '서비스 문의', '개선 요청', '기타'];
    _analytics.logFeedbackTypeSelected(types[index]);
  }

  Future<void> submitFeedback() async {
    final repository = ref.read(feedbackRepositoryProvider);
    final types = ['오류 제보', '서비스 문의', '개선 요청', '기타'];

    try {
      // 제출 시작 이벤트
      await _analytics.logFeedbackSubmitStarted(
        feedbackType: types[state.selectedTypeIndex],
        includeCalculationData: state.includeCalculationData,
      );

      // Crashlytics 컨텍스트 설정
      await _crashlytics.setScreenContext('feedback_screen');
      await _crashlytics.setCustomKey('feedback_type', types[state.selectedTypeIndex]);

      state = state.copyWith(isLoading: true);

      final result = await repository.submitFeedback(
        type: state.selectedTypeIndex,
        content: state.content,
        email: state.email,
        calculationId: state.calculationId,
        includeCalculationData: state.includeCalculationData,
      );

      result.when(
        success: (_) {
          state = state.copyWith(
            isLoading: false,
            isSubmitted: true,
          );

          // 제출 성공 이벤트
          _analytics.logFeedbackSubmitted(
            feedbackType: types[state.selectedTypeIndex],
            includeCalculationData: state.includeCalculationData,
          );
        },
        failure: (error) {
          state = state.copyWith(
            isLoading: false,
            error: error.message,
          );

          // 네트워크 에러 기록
          if (error is NetworkError) {
            _crashlytics.recordNetworkError(
              endpoint: '/api/feedback',
              method: 'POST',
              error: error,
              statusCode: error.statusCode,
            );
          } else {
            _crashlytics.recordError(error, null);
          }

          // 제출 실패 이벤트
          _analytics.logFeedbackSubmitFailed(
            feedbackType: types[state.selectedTypeIndex],
            errorMessage: error.toString(),
          );
        },
      );
    } catch (e, stack) {
      state = state.copyWith(
        isLoading: false,
        error: '알 수 없는 오류가 발생했습니다.',
      );

      // 예상치 못한 에러 기록
      _crashlytics.recordError(
        e,
        stack,
        reason: 'Feedback submission failed',
      );

      _analytics.logFeedbackSubmitFailed(
        feedbackType: types[state.selectedTypeIndex],
        errorMessage: e.toString(),
      );
    }
  }
}
```

## Screen 레벨에서의 통합

### CalculationDetailScreen

```dart
class _CalculationDetailScreenState extends State<CalculationDetailScreen> {
  final _analytics = AnalyticsService();
  int _selectedSegmentIndex = 0;

  @override
  void initState() {
    super.initState();

    // 화면 진입 이벤트
    _analytics.logCalculationDetailViewed(widget.result.leaveType);
    _analytics.logScreenView('calculation_detail_screen');
  }

  void _onSegmentChanged(int index) {
    setState(() {
      _selectedSegmentIndex = index;
    });

    // 세그먼트 변경 이벤트
    _analytics.logDetailSegmentChanged(index == 0 ? 'monthly' : 'prorated');
  }
}
```

### WebViewScreen

```dart
class _WebViewScreenState extends State<WebViewScreen> {
  final _analytics = AnalyticsService();

  @override
  void initState() {
    super.initState();

    // 웹뷰 열기 이벤트
    _analytics.logWebViewOpened(widget.url, widget.title);
    _analytics.logScreenView('webview_screen');
  }
}
```

## QuickHelpSheet에서의 통합

```dart
class QuickHelpSheet extends StatelessWidget {
  final _analytics = AnalyticsService();

  void _onHelpButtonClicked(QuickHelpKind kind) {
    _analytics.logHelpButtonClicked(kind.name);
  }

  void _onExpanded(QuickHelpKind kind) {
    _analytics.logHelpSheetExpanded(kind.name);
  }
}
```

## 적용 우선순위

1. **필수** (계산 관련 핵심 기능)
   - CalculatorViewModel: 계산 시작/완료/실패, 입력값 변경
   - 네트워크 에러: 모든 API 호출

2. **중요** (사용자 행동 추적)
   - FeedbackViewModel: 피드백 제출
   - 화면 전환: 주요 화면 진입
   - 사용자 입력: 특이사항, 회사휴일 추가/삭제

3. **선택** (부가 기능)
   - 도움말 버튼 클릭
   - 외부 링크 클릭
   - 세그먼트 변경

## 테스트

Firebase 콘솔에서 이벤트가 제대로 기록되는지 확인하세요:
- Analytics: 실시간 이벤트는 최대 24시간 후에 표시됩니다.
- Crashlytics: 크래시 리포트는 즉시 확인 가능합니다.
