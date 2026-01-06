/// 회사휴일 정보
class CompanyHoliday {
  /// 날짜
  final DateTime date;

  /// 사용자에게 표시할 이름 (선택한 CompanyHolidayType의 displayName)
  final String displayName;

  const CompanyHoliday({
    required this.date,
    required this.displayName,
  });

  @override
  String toString() {
    return 'CompanyHoliday(displayName: $displayName, date: $date)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is CompanyHoliday &&
        other.date == date &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return Object.hash(date, displayName);
  }
}
