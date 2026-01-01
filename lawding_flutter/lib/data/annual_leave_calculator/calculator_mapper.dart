import '../../domain/entities/annual_leave.dart';
import '../../domain/entities/non_working_period.dart';
import '../../domain/repositories/annual_leave_repository.dart';
import 'calculator_params.dart';
import 'calculator_response.dart';

/// CalculatorResponse를 AnnualLeave Entity로 변환
extension CalculatorResponseMapper on CalculatorResponse {
  AnnualLeave toDomain() {
    return AnnualLeave(
      totalDays: totalAnnualLeaves,
      usedDays: usedAnnualLeaves,
      remainingDays: remainingAnnualLeaves,
      calculationId: calculationId,
      hireDate: DateTime.parse(hireDate),
      referenceDate: DateTime.parse(referenceDate),
    );
  }
}

/// Domain Entity를 CalculatorCalculateParams로 변환
extension AnnualLeaveCalculationMapper on CalculationType {
  CalculatorCalculateParams toParams({
    required DateTime hireDate,
    required DateTime referenceDate,
    required List<NonWorkingPeriod> nonWorkingPeriods,
    required List<DateTime> companyHolidays,
  }) {
    return CalculatorCalculateParams(
      calculationType: code,
      hireDate: _formatDate(hireDate),
      referenceDate: _formatDate(referenceDate),
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
      type: type.code,
      startDate: _formatDate(startDate),
      endDate: _formatDate(endDate),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }
}
