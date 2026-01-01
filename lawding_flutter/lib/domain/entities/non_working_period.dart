/// 비근무 기간 타입
enum NonWorkingPeriodType {
  militaryService(1, '군복무'),
  maternityLeave(2, '출산휴가'),
  parentalLeave(3, '육아휴직'),
  unpaidLeave(4, '무급휴직'),
  other(99, '기타');

  final int code;
  final String displayName;

  const NonWorkingPeriodType(this.code, this.displayName);

  static NonWorkingPeriodType fromCode(int code) {
    return values.firstWhere(
      (type) => type.code == code,
      orElse: () => NonWorkingPeriodType.other,
    );
  }
}

/// 비근무 기간 정보
class NonWorkingPeriod {
  /// 비근무 기간 타입
  final NonWorkingPeriodType type;

  /// 시작일
  final DateTime startDate;

  /// 종료일
  final DateTime endDate;

  const NonWorkingPeriod({
    required this.type,
    required this.startDate,
    required this.endDate,
  });

  /// 기간 (일수)
  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  /// 유효한 기간인지 확인
  bool get isValid => !endDate.isBefore(startDate);

  @override
  String toString() {
    return 'NonWorkingPeriod(type: ${type.displayName}, duration: $durationInDays days)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NonWorkingPeriod &&
        other.type == type &&
        other.startDate == startDate &&
        other.endDate == endDate;
  }

  @override
  int get hashCode {
    return Object.hash(type, startDate, endDate);
  }
}
