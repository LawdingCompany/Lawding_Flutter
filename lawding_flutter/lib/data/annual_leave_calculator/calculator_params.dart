class CalculatorCalculateParams {
  final int calculationType;
  final String hireDate;
  final String referenceDate;
  final List<NonWorkingPeriodDto> nonWorkingPeriods;
  final List<String> companyHolidays;

  const CalculatorCalculateParams({
    required this.calculationType,
    required this.hireDate,
    required this.referenceDate,
    required this.nonWorkingPeriods,
    required this.companyHolidays,
  });

  Map<String, dynamic> toJson() {
    return {
      'calculationType': calculationType,
      'hireDate': hireDate,
      'referenceDate': referenceDate,
      'nonWorkingPeriods':
          nonWorkingPeriods.map((e) => e.toJson()).toList(),
      'companyHolidays': companyHolidays,
    };
  }
}

class NonWorkingPeriodDto {
  final int type;
  final String startDate;
  final String endDate;

  const NonWorkingPeriodDto({
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}