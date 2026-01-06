/// 날짜 포맷팅 유틸리티
class DateFormatter {
  /// DateTime을 'YYYY.MM.DD' 형식으로 변환 (UI 표시용)
  static String toDisplayFormat(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  /// DateTime을 'YYYY-MM-DD' 형식으로 변환 (API 전송용)
  static String toApiFormat(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  /// 기간을 표시 형식으로 변환
  static String toPeriodFormat(DateTime start, DateTime end) {
    return '${toDisplayFormat(start)} ~ ${toDisplayFormat(end)} · ${end.difference(start).inDays + 1}일';
  }

  /// 월을 'MM-01' 형식으로 변환
  static String toMonthDayFormat(int month) {
    return '${month.toString().padLeft(2, '0')}-01';
  }
}
