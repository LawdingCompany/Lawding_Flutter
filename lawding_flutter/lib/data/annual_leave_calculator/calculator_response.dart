class Ratio {
  final int numerator;
  final int denominator;
  final double rate;

  const Ratio({
    required this.numerator,
    required this.denominator,
    required this.rate,
  });

  factory Ratio.fromJson(Map<String, dynamic> json) {
    return Ratio(
      numerator: json['numerator'] as int,
      denominator: json['denominator'] as int,
      rate: (json['rate'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'numerator': numerator,
      'denominator': denominator,
      'rate': rate,
    };
  }
}

class Period {
  final String startDate;
  final String endDate;

  const Period({
    required this.startDate,
    required this.endDate,
  });

  factory Period.fromJson(Map<String, dynamic> json) {
    return Period(
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class Record {
  final Period period;
  final double monthlyLeave;

  const Record({
    required this.period,
    required this.monthlyLeave,
  });

  factory Record.fromJson(Map<String, dynamic> json) {
    return Record(
      period: Period.fromJson(json['period'] as Map<String, dynamic>),
      monthlyLeave: (json['monthlyLeave'] as num).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'period': period.toJson(),
      'monthlyLeave': monthlyLeave,
    };
  }
}

class NonWorkingPeriodResponse {
  final int type;
  final String startDate;
  final String endDate;

  const NonWorkingPeriodResponse({
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  factory NonWorkingPeriodResponse.fromJson(Map<String, dynamic> json) {
    return NonWorkingPeriodResponse(
      type: json['type'] as int,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type,
      'startDate': startDate,
      'endDate': endDate,
    };
  }
}

class MonthlyDetail {
  final Period accrualPeriod;
  final Period availablePeriod;
  final Ratio? attendanceRate;
  final Ratio? prescribedWorkingRatio;
  final int serviceYears;
  final double totalLeaveDays;
  final List<Record> records;

  const MonthlyDetail({
    required this.accrualPeriod,
    required this.availablePeriod,
    this.attendanceRate,
    this.prescribedWorkingRatio,
    required this.serviceYears,
    required this.totalLeaveDays,
    required this.records,
  });

  factory MonthlyDetail.fromJson(Map<String, dynamic> json) {
    return MonthlyDetail(
      accrualPeriod: Period.fromJson(json['accrualPeriod'] as Map<String, dynamic>),
      availablePeriod: Period.fromJson(json['availablePeriod'] as Map<String, dynamic>),
      attendanceRate: json['attendanceRate'] != null
          ? Ratio.fromJson(json['attendanceRate'] as Map<String, dynamic>)
          : null,
      prescribedWorkingRatio: json['prescribedWorkingRatio'] != null
          ? Ratio.fromJson(json['prescribedWorkingRatio'] as Map<String, dynamic>)
          : null,
      serviceYears: json['serviceYears'] as int,
      totalLeaveDays: (json['totalLeaveDays'] as num).toDouble(),
      records: (json['records'] as List)
          .map((e) => Record.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accrualPeriod': accrualPeriod.toJson(),
      'availablePeriod': availablePeriod.toJson(),
      'attendanceRate': attendanceRate?.toJson(),
      'prescribedWorkingRatio': prescribedWorkingRatio?.toJson(),
      'serviceYears': serviceYears,
      'totalLeaveDays': totalLeaveDays,
      'records': records.map((e) => e.toJson()).toList(),
    };
  }
}

class ProratedDetail {
  final Period accrualPeriod;
  final Period availablePeriod;
  final Ratio? attendanceRate;
  final Ratio? prescribedWorkingRatio;
  final int? serviceYears;
  final double totalLeaveDays;
  final double? prescribedWorkingRatioForProrated;
  final List<Record>? records;

  const ProratedDetail({
    required this.accrualPeriod,
    required this.availablePeriod,
    this.attendanceRate,
    this.prescribedWorkingRatio,
    this.serviceYears,
    required this.totalLeaveDays,
    this.prescribedWorkingRatioForProrated,
    this.records,
  });

  factory ProratedDetail.fromJson(Map<String, dynamic> json) {
    return ProratedDetail(
      accrualPeriod: Period.fromJson(json['accrualPeriod'] as Map<String, dynamic>),
      availablePeriod: Period.fromJson(json['availablePeriod'] as Map<String, dynamic>),
      attendanceRate: json['attendanceRate'] != null
          ? Ratio.fromJson(json['attendanceRate'] as Map<String, dynamic>)
          : null,
      prescribedWorkingRatio: json['prescribedWorkingRatio'] != null
          ? Ratio.fromJson(json['prescribedWorkingRatio'] as Map<String, dynamic>)
          : null,
      serviceYears: json['serviceYears'] as int?,
      totalLeaveDays: (json['totalLeaveDays'] as num).toDouble(),
      prescribedWorkingRatioForProrated: json['prescribedWorkingRatioForProrated'] != null
          ? (json['prescribedWorkingRatioForProrated'] as num).toDouble()
          : null,
      records: json['records'] != null
          ? (json['records'] as List)
              .map((e) => Record.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accrualPeriod': accrualPeriod.toJson(),
      'availablePeriod': availablePeriod.toJson(),
      'attendanceRate': attendanceRate?.toJson(),
      'prescribedWorkingRatio': prescribedWorkingRatio?.toJson(),
      'serviceYears': serviceYears,
      'totalLeaveDays': totalLeaveDays,
      'prescribedWorkingRatioForProrated': prescribedWorkingRatioForProrated,
      'records': records?.map((e) => e.toJson()).toList(),
    };
  }
}

class CalculationDetail {
  final Period? accrualPeriod;
  final Period? availablePeriod;
  final Ratio? attendanceRate;
  final Ratio? prescribedWorkingRatio;
  final int serviceYears;
  final double totalLeaveDays;
  final int? baseAnnualLeave;
  final int? additionalLeave;
  final List<Record>? records;
  final MonthlyDetail? monthlyDetail;
  final ProratedDetail? proratedDetail;

  const CalculationDetail({
    this.accrualPeriod,
    this.availablePeriod,
    this.attendanceRate,
    this.prescribedWorkingRatio,
    required this.serviceYears,
    required this.totalLeaveDays,
    this.baseAnnualLeave,
    this.additionalLeave,
    this.records,
    this.monthlyDetail,
    this.proratedDetail,
  });

  factory CalculationDetail.fromJson(Map<String, dynamic> json) {
    return CalculationDetail(
      accrualPeriod: json['accrualPeriod'] != null
          ? Period.fromJson(json['accrualPeriod'] as Map<String, dynamic>)
          : null,
      availablePeriod: json['availablePeriod'] != null
          ? Period.fromJson(json['availablePeriod'] as Map<String, dynamic>)
          : null,
      attendanceRate: json['attendanceRate'] != null
          ? Ratio.fromJson(json['attendanceRate'] as Map<String, dynamic>)
          : null,
      prescribedWorkingRatio: json['prescribedWorkingRatio'] != null
          ? Ratio.fromJson(json['prescribedWorkingRatio'] as Map<String, dynamic>)
          : null,
      serviceYears: json['serviceYears'] as int,
      totalLeaveDays: (json['totalLeaveDays'] as num).toDouble(),
      baseAnnualLeave: json['baseAnnualLeave'] as int?,
      additionalLeave: json['additionalLeave'] as int?,
      records: json['records'] != null
          ? (json['records'] as List)
              .map((e) => Record.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      monthlyDetail: json['monthlyDetail'] != null
          ? MonthlyDetail.fromJson(json['monthlyDetail'] as Map<String, dynamic>)
          : null,
      proratedDetail: json['proratedDetail'] != null
          ? ProratedDetail.fromJson(json['proratedDetail'] as Map<String, dynamic>)
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accrualPeriod': accrualPeriod?.toJson(),
      'availablePeriod': availablePeriod?.toJson(),
      'attendanceRate': attendanceRate?.toJson(),
      'prescribedWorkingRatio': prescribedWorkingRatio?.toJson(),
      'serviceYears': serviceYears,
      'totalLeaveDays': totalLeaveDays,
      'baseAnnualLeave': baseAnnualLeave,
      'additionalLeave': additionalLeave,
      'records': records?.map((e) => e.toJson()).toList(),
      'monthlyDetail': monthlyDetail?.toJson(),
      'proratedDetail': proratedDetail?.toJson(),
    };
  }
}

enum LeaveType {
  monthly('MONTHLY'),
  annual('ANNUAL'),
  prorated('PRORATED'),
  monthlyAndProrated('MONTHLY_AND_PRORATED');

  final String value;
  const LeaveType(this.value);

  factory LeaveType.fromString(String value) {
    return LeaveType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => LeaveType.annual,
    );
  }
}

class CalculatorResponse {
  final String calculationId;
  final String calculationType;
  final String? fiscalYear;
  final String hireDate;
  final String referenceDate;
  final List<NonWorkingPeriodResponse>? nonWorkingPeriod;
  final List<String>? companyHolidays;
  final LeaveType leaveType;
  final CalculationDetail calculationDetail;
  final List<String> explanations;
  final List<String>? nonWorkingExplanations;

  const CalculatorResponse({
    required this.calculationId,
    required this.calculationType,
    this.fiscalYear,
    required this.hireDate,
    required this.referenceDate,
    this.nonWorkingPeriod,
    this.companyHolidays,
    required this.leaveType,
    required this.calculationDetail,
    required this.explanations,
    this.nonWorkingExplanations,
  });

  factory CalculatorResponse.fromJson(Map<String, dynamic> json) {
    return CalculatorResponse(
      calculationId: json['calculationId'] as String,
      calculationType: json['calculationType'] as String,
      fiscalYear: json['fiscalYear'] as String?,
      hireDate: json['hireDate'] as String,
      referenceDate: json['referenceDate'] as String,
      nonWorkingPeriod: json['nonWorkingPeriod'] != null
          ? (json['nonWorkingPeriod'] as List)
              .map((e) => NonWorkingPeriodResponse.fromJson(e as Map<String, dynamic>))
              .toList()
          : null,
      companyHolidays: json['companyHolidays'] != null
          ? (json['companyHolidays'] as List).map((e) => e as String).toList()
          : null,
      leaveType: LeaveType.fromString(json['leaveType'] as String),
      calculationDetail: CalculationDetail.fromJson(json['calculationDetail'] as Map<String, dynamic>),
      explanations: (json['explanations'] as List).map((e) => e as String).toList(),
      nonWorkingExplanations: json['nonWorkingExplanations'] != null
          ? (json['nonWorkingExplanations'] as List).map((e) => e as String).toList()
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'calculationId': calculationId,
      'calculationType': calculationType,
      'fiscalYear': fiscalYear,
      'hireDate': hireDate,
      'referenceDate': referenceDate,
      'nonWorkingPeriod': nonWorkingPeriod?.map((e) => e.toJson()).toList(),
      'companyHolidays': companyHolidays,
      'leaveType': leaveType.value,
      'calculationDetail': calculationDetail.toJson(),
      'explanations': explanations,
      'nonWorkingExplanations': nonWorkingExplanations,
    };
  }
}
