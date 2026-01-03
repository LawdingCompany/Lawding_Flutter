/// 연차 정보를 나타내는 Domain Entity
class AnnualLeave {
  /// 계산 고유 ID
  final String calculationId;

  /// 계산 방식 (standard/prorated)
  final String calculationType;

  /// 회계연도
  final String? fiscalYear;

  /// 입사일
  final DateTime hireDate;

  /// 기준일
  final DateTime referenceDate;

  /// 휴직 기간
  final List<NonWorkingPeriodEntity>? nonWorkingPeriods;

  /// 회사 휴무일
  final List<DateTime>? companyHolidays;

  /// 연차 유형
  final String leaveType;

  /// 근속 연수
  final int serviceYears;

  /// 총 연차 일수
  final double totalDays;

  /// 기본 연차
  final int? baseAnnualLeave;

  /// 가산 연차
  final int? additionalLeave;

  /// 출근율
  final double? attendanceRate;

  /// 설명
  final List<String> explanations;

  /// 휴직 관련 설명
  final List<String>? nonWorkingExplanations;

  const AnnualLeave({
    required this.calculationId,
    required this.calculationType,
    this.fiscalYear,
    required this.hireDate,
    required this.referenceDate,
    this.nonWorkingPeriods,
    this.companyHolidays,
    required this.leaveType,
    required this.serviceYears,
    required this.totalDays,
    this.baseAnnualLeave,
    this.additionalLeave,
    this.attendanceRate,
    required this.explanations,
    this.nonWorkingExplanations,
  });

  /// 남은 연차 일수 (사용하지 않은 연차, 현재는 totalDays와 동일)
  int get remainingDays => totalDays.toInt();

  /// 연차가 남아있는지 여부
  bool get hasRemainingDays => totalDays > 0;

  @override
  String toString() {
    return 'AnnualLeave(id: $calculationId, type: $calculationType, total: $totalDays, service: $serviceYears년)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnnualLeave && other.calculationId == calculationId;
  }

  @override
  int get hashCode {
    return calculationId.hashCode;
  }
}

/// 휴직 기간 엔티티 (간단한 버전)
class NonWorkingPeriodEntity {
  final int type;
  final DateTime startDate;
  final DateTime endDate;

  const NonWorkingPeriodEntity({
    required this.type,
    required this.startDate,
    required this.endDate,
  });
}
