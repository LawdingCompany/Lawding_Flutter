import '../../domain/entities/annual_leave.dart';
import '../../domain/entities/non_working_period.dart';
import '../../domain/repositories/annual_leave_repository.dart';
import 'calculator_params.dart';
import 'calculator_response.dart';

/// CalculatorResponse를 AnnualLeave Entity로 변환
extension CalculatorResponseMapper on CalculatorResponse {
  AnnualLeave toDomain() {
    return AnnualLeave(
      calculationId: calculationId,
      calculationType: calculationType,
      fiscalYear: fiscalYear,
      hireDate: DateTime.parse(hireDate),
      referenceDate: DateTime.parse(referenceDate),
      nonWorkingPeriods: nonWorkingPeriod
          ?.map((p) => NonWorkingPeriodEntity(
                type: p.type,
                startDate: DateTime.parse(p.startDate),
                endDate: DateTime.parse(p.endDate),
              ))
          .toList(),
      companyHolidays:
          companyHolidays?.map(DateTime.parse).toList(),
      leaveType: leaveType.value,
      serviceYears: calculationDetail.serviceYears,
      totalDays: calculationDetail.totalLeaveDays,
      baseAnnualLeave: calculationDetail.baseAnnualLeave,
      additionalLeave: calculationDetail.additionalLeave,
      attendanceRate: calculationDetail.attendanceRate?.rate,
      explanations: explanations,
      nonWorkingExplanations: nonWorkingExplanations,
    );
  }
}

/// Domain Entity를 CalculatorCalculateParams로 변환
extension AnnualLeaveCalculationMapper on CalculationType {
  CalculatorCalculateParams toParams({
    required DateTime hireDate,
    required DateTime referenceDate,
    String? fiscalYear,
    required List<NonWorkingPeriod> nonWorkingPeriods,
    required List<DateTime> companyHolidays,
  }) {
    return CalculatorCalculateParams(
      calculationType: code,
      hireDate: _formatDate(hireDate),
      referenceDate: _formatDate(referenceDate),
      fiscalYear: fiscalYear,
      nonWorkingPeriods: nonWorkingPeriods
          .map((period) => period.toDataModel())
          .toList(),
      companyHolidays: companyHolidays.map(_formatDate).toList(),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}

/// NonWorkingPeriod Entity를 Data Model로 변환
extension NonWorkingPeriodMapper on NonWorkingPeriod {
  NonWorkingPeriodDto toDataModel() {
    return NonWorkingPeriodDto(
      type: type,
      startDate: _formatDate(startDate),
      endDate: _formatDate(endDate),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
