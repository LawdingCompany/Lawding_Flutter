import '../core/result.dart';
import '../entities/annual_leave.dart';
import '../entities/non_working_period.dart';
import '../repositories/annual_leave_repository.dart';
import '../../data/network/network_error.dart';

/// 연차 계산 UseCase
/// 비즈니스 로직을 캡슐화하고 Presentation Layer와 소통
class CalculateAnnualLeaveUseCase {
  final AnnualLeaveRepository _repository;

  CalculateAnnualLeaveUseCase(this._repository);

  /// 연차 계산 실행
  Future<Result<AnnualLeave, NetworkError>> execute({
    required CalculationType calculationType,
    required DateTime hireDate,
    required DateTime referenceDate,
    String? fiscalYear,
    List<NonWorkingPeriod>? nonWorkingPeriods,
    List<DateTime>? companyHolidays,
  }) async {
    // 비즈니스 검증 로직
    if (referenceDate.isBefore(hireDate)) {
      return const Failure(
        ServerError(
          message: '기준일은 입사일보다 이후여야 합니다',
          statusCode: 400,
        ),
      );
    }

    // Repository를 통해 데이터 조회
    return await _repository.calculateAnnualLeave(
      calculationType: calculationType,
      hireDate: hireDate,
      referenceDate: referenceDate,
      fiscalYear: fiscalYear,
      nonWorkingPeriods: nonWorkingPeriods ?? [],
      companyHolidays: companyHolidays ?? [],
    );
  }
}
