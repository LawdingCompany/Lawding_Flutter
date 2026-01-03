import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../data/network/network_error.dart';
import '../../../domain/core/result.dart';
import '../../../domain/entities/annual_leave.dart';
import '../../../domain/entities/non_working_period.dart';
import '../../../domain/repositories/annual_leave_repository.dart';
import '../../providers/providers.dart';

part 'calculator_view_model.g.dart';

@riverpod
class CalculatorViewModel extends _$CalculatorViewModel {
  @override
  CalculatorState build() {
    return CalculatorState();
  }

  void setCalculationType(int index) {
    state = state.copyWith(
      calculationType: index == 0 ? CalculationType.standard : CalculationType.proRated,
    );
  }

  void setHireDate(DateTime date) {
    state = state.copyWith(hireDate: date);
  }

  void setReferenceDate(DateTime date) {
    state = state.copyWith(referenceDate: date);
  }

  void setFiscalYearStartMonth(int month) {
    // 회계연도 시작 월 저장
    state = state.copyWith(fiscalYearStartMonth: month);
  }

  void addNonWorkingPeriod(NonWorkingPeriod period) {
    final updated = [...state.nonWorkingPeriods, period];
    state = state.copyWith(nonWorkingPeriods: updated);
  }

  void removeNonWorkingPeriod(int index) {
    final updated = List<NonWorkingPeriod>.from(state.nonWorkingPeriods)
      ..removeAt(index);
    state = state.copyWith(nonWorkingPeriods: updated);
  }

  void addCompanyHoliday(DateTime date) {
    final updated = [...state.companyHolidays, date];
    state = state.copyWith(companyHolidays: updated);
  }

  void removeCompanyHoliday(int index) {
    final updated = List<DateTime>.from(state.companyHolidays)..removeAt(index);
    state = state.copyWith(companyHolidays: updated);
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatMonthDay(int month) {
    return '${month.toString().padLeft(2, '0')}-01';
  }

  Future<void> calculate() async {
    final hireDate = state.hireDate;
    final referenceDate = state.referenceDate;

    if (hireDate == null || referenceDate == null) {
      state = state.copyWith(
        error: '입사일과 계산 기준일을 모두 선택해주세요.',
      );
      return;
    }

    // fiscalYear 계산
    final fiscalYear = state.calculationType == CalculationType.proRated
        ? _formatMonthDay(state.fiscalYearStartMonth)
        : null;

    // === API 요청 파라미터 출력 (JSON 형태) ===
    print('');
    print('╔════════════════════════════════════════════════════════════╗');
    print('║               API Request Parameters                       ║');
    print('╚════════════════════════════════════════════════════════════╝');
    print('{');
    print('  "calculationType": ${state.calculationType.code},');
    if (fiscalYear != null) {
      print('  "fiscalYear": "$fiscalYear",');
    }
    print('  "hireDate": "${_formatDate(hireDate)}",');
    print('  "referenceDate": "${_formatDate(referenceDate)}",');

    if (state.nonWorkingPeriods.isEmpty) {
      print('  "nonWorkingPeriods": [],');
    } else {
      print('  "nonWorkingPeriods": [');
      for (var i = 0; i < state.nonWorkingPeriods.length; i++) {
        final period = state.nonWorkingPeriods[i];
        final isLast = i == state.nonWorkingPeriods.length - 1;
        print('    {');
        print('      "type": ${period.type.code},');
        print('      "startDate": "${_formatDate(period.startDate)}",');
        print('      "endDate": "${_formatDate(period.endDate)}"');
        print('    }${isLast ? '' : ','}');
      }
      print('  ],');
    }

    if (state.companyHolidays.isEmpty) {
      print('  "companyHolidays": []');
    } else {
      print('  "companyHolidays": [');
      for (var i = 0; i < state.companyHolidays.length; i++) {
        final isLast = i == state.companyHolidays.length - 1;
        print('    "${_formatDate(state.companyHolidays[i])}"${isLast ? '' : ','}');
      }
      print('  ]');
    }
    print('}');
    print('════════════════════════════════════════════════════════════');
    print('');

    state = state.copyWith(isLoading: true, error: null);

    final useCase = ref.read(calculateAnnualLeaveUseCaseProvider);
    final result = await useCase.execute(
      calculationType: state.calculationType,
      hireDate: hireDate,
      referenceDate: referenceDate,
      fiscalYear: fiscalYear,
      nonWorkingPeriods: state.nonWorkingPeriods,
      companyHolidays: state.companyHolidays,
    );

    switch (result) {
      case Success(:final value):
        print('=== API 응답 성공 ===');
        print('계산 ID: ${value.calculationId}');
        print('계산 방식: ${value.calculationType}');
        print('연차 유형: ${value.leaveType}');
        print('총 연차 개수: ${value.totalDays}일');
        print('근속 연수: ${value.serviceYears}년');
        print('출근율: ${value.attendanceRate != null ? "${value.attendanceRate}%" : "N/A"}');
        print('기본 연차: ${value.baseAnnualLeave ?? "N/A"}');
        print('가산 연차: ${value.additionalLeave ?? "N/A"}');
        print('설명: ${value.explanations.join(", ")}');
        print('==================');

        state = state.copyWith(
          isLoading: false,
          result: value,
        );
      case Failure(:final error):
        print('=== API 응답 실패 ===');
        print('에러 타입: ${error.runtimeType}');

        final errorMessage = switch (error) {
          ServerError(:final message) => message,
          UnauthorizedError() => '인증이 필요합니다',
          TimeoutError() => '요청 시간이 초과되었습니다',
          NetworkConnectionError() => '네트워크 연결을 확인해주세요',
          _ => '알 수 없는 오류가 발생했습니다',
        };

        print('에러 메시지: $errorMessage');
        print('==================');

        state = state.copyWith(
          isLoading: false,
          error: errorMessage,
        );
    }
  }
}

class CalculatorState {
  final CalculationType calculationType;
  final DateTime? hireDate;
  final DateTime? referenceDate;
  final int fiscalYearStartMonth; // 회계연도 시작 월 (1-12)
  final List<NonWorkingPeriod> nonWorkingPeriods;
  final List<DateTime> companyHolidays;
  final bool isLoading;
  final AnnualLeave? result;
  final String? error;

  CalculatorState({
    this.calculationType = CalculationType.standard,
    this.hireDate,
    this.referenceDate,
    this.fiscalYearStartMonth = 1, // 기본값 1월
    this.nonWorkingPeriods = const [],
    this.companyHolidays = const [],
    this.isLoading = false,
    this.result,
    this.error,
  });

  CalculatorState copyWith({
    CalculationType? calculationType,
    DateTime? hireDate,
    DateTime? referenceDate,
    int? fiscalYearStartMonth,
    List<NonWorkingPeriod>? nonWorkingPeriods,
    List<DateTime>? companyHolidays,
    bool? isLoading,
    AnnualLeave? result,
    String? error,
  }) {
    return CalculatorState(
      calculationType: calculationType ?? this.calculationType,
      hireDate: hireDate ?? this.hireDate,
      referenceDate: referenceDate ?? this.referenceDate,
      fiscalYearStartMonth: fiscalYearStartMonth ?? this.fiscalYearStartMonth,
      nonWorkingPeriods: nonWorkingPeriods ?? this.nonWorkingPeriods,
      companyHolidays: companyHolidays ?? this.companyHolidays,
      isLoading: isLoading ?? this.isLoading,
      result: result ?? this.result,
      error: error,
    );
  }
}
