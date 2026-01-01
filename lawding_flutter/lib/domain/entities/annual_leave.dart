/// 연차 정보를 나타내는 Domain Entity
class AnnualLeave {
  /// 총 연차 일수
  final int totalDays;

  /// 사용한 연차 일수
  final int usedDays;

  /// 남은 연차 일수
  final int remainingDays;

  /// 계산 고유 ID
  final String calculationId;

  /// 입사일
  final DateTime hireDate;

  /// 기준일
  final DateTime referenceDate;

  const AnnualLeave({
    required this.totalDays,
    required this.usedDays,
    required this.remainingDays,
    required this.calculationId,
    required this.hireDate,
    required this.referenceDate,
  });

  /// 연차 사용률 (0.0 ~ 1.0)
  double get usageRate {
    if (totalDays == 0) return 0.0;
    return usedDays / totalDays;
  }

  /// 연차를 모두 사용했는지 여부
  bool get isFullyUsed => remainingDays == 0;

  /// 연차가 남아있는지 여부
  bool get hasRemainingDays => remainingDays > 0;

  @override
  String toString() {
    return 'AnnualLeave(total: $totalDays, used: $usedDays, remaining: $remainingDays)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is AnnualLeave &&
        other.totalDays == totalDays &&
        other.usedDays == usedDays &&
        other.remainingDays == remainingDays &&
        other.calculationId == calculationId &&
        other.hireDate == hireDate &&
        other.referenceDate == referenceDate;
  }

  @override
  int get hashCode {
    return Object.hash(
      totalDays,
      usedDays,
      remainingDays,
      calculationId,
      hireDate,
      referenceDate,
    );
  }
}
