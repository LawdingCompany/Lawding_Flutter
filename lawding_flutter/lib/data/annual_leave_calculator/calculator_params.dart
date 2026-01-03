class CalculatorCalculateParams {
  final int calculationType;
  final String hireDate;
  final String referenceDate;
  final String? fiscalYear; // 회계연도 (예: "2024")
  final List<NonWorkingPeriodDto> nonWorkingPeriods;
  final List<String> companyHolidays;

  const CalculatorCalculateParams({
    required this.calculationType,
    required this.hireDate,
    required this.referenceDate,
    this.fiscalYear,
    required this.nonWorkingPeriods,
    required this.companyHolidays,
  });

  Map<String, dynamic> toJson() {
    final json = {
      'calculationType': calculationType,
      'hireDate': hireDate,
      'referenceDate': referenceDate,
      'nonWorkingPeriods':
          nonWorkingPeriods.map((e) => e.toJson()).toList(),
      'companyHolidays': companyHolidays,
    };

    // fiscalYear가 null이 아닐 때만 추가
    if (fiscalYear != null) {
      json['fiscalYear'] = fiscalYear!;
    }

    return json;
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