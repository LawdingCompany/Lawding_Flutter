enum CompanyHolidayType {
  companyFoundationDay,
  collectiveAgreementLeave,
  laborUnionFoundationDay,
  internalPolicyHoliday,
  companyWideSummerBreak,
  discretionaryPrePostHoliday,
  other,
}

extension CompanyHolidayTypeExtension on CompanyHolidayType {
  String get displayName {
    switch (this) {
      case CompanyHolidayType.companyFoundationDay:
        return '회사 창립기념일';
      case CompanyHolidayType.collectiveAgreementLeave:
        return '단체협약상 유·무급 휴가일';
      case CompanyHolidayType.laborUnionFoundationDay:
        return '노동조합 창립기념일';
      case CompanyHolidayType.internalPolicyHoliday:
        return '사내 규정상 휴일';
      case CompanyHolidayType.companyWideSummerBreak:
        return '일괄 여름휴가 지정일';
      case CompanyHolidayType.discretionaryPrePostHoliday:
        return '명절 전후 임의휴무일';
      case CompanyHolidayType.other:
        return '기타';
    }
  }
}
