import '../core/result.dart';
import '../entities/annual_leave.dart';
import '../entities/non_working_period.dart';
import '../../data/network/network_error.dart';

/// 연차 계산 타입
enum CalculationType {
  standard(1, '일반'),
  proRated(2, '비례');

  final int code;
  final String displayName;

  const CalculationType(this.code, this.displayName);
}

/// 연차 Repository 인터페이스
/// Data Layer와 Domain Layer를 분리하는 추상화
abstract interface class AnnualLeaveRepository {
  /// 연차 계산
  Future<Result<AnnualLeave, NetworkError>> calculateAnnualLeave({
    required CalculationType calculationType,
    required DateTime hireDate,
    required DateTime referenceDate,
    required List<NonWorkingPeriod> nonWorkingPeriods,
    required List<DateTime> companyHolidays,
  });
}
