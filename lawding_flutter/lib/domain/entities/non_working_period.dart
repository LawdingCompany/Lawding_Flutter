/// 비근무 기간 정보
class NonWorkingPeriod {
  /// 서버로 전송할 타입 코드 (1, 2, 3)
  final int type;

  /// 시작일
  final DateTime startDate;

  /// 종료일
  final DateTime endDate;

  /// 사용자에게 표시할 이름 (선택한 NonWorkingType의 displayName)
  final String displayName;

  const NonWorkingPeriod({
    required this.type,
    required this.startDate,
    required this.endDate,
    required this.displayName,
  });

  /// 기간 (일수)
  int get durationInDays {
    return endDate.difference(startDate).inDays + 1;
  }

  /// 유효한 기간인지 확인
  bool get isValid => !endDate.isBefore(startDate);

  @override
  String toString() {
    return 'NonWorkingPeriod(displayName: $displayName, type: $type, duration: $durationInDays days)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is NonWorkingPeriod &&
        other.type == type &&
        other.startDate == startDate &&
        other.endDate == endDate &&
        other.displayName == displayName;
  }

  @override
  int get hashCode {
    return Object.hash(type, startDate, endDate, displayName);
  }
}
