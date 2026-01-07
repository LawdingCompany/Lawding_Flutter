import '../../domain/entities/help_content.dart';

/// 도움말 콘텐츠 라이브러리
class QuickHelpLibrary {
  /// 종류별 도움말 섹션 가져오기
  static List<HelpSection> getSections(QuickHelpKind kind) {
    switch (kind) {
      case QuickHelpKind.calculationType:
        return _calculationTypeSections;
      case QuickHelpKind.detailPeriods:
        return _detailPeriodsSections;
      case QuickHelpKind.companyHolidays:
        return _companyHolidaysSections;
    }
  }

  /// 종류별 하이라이트 키워드 가져오기
  static List<HighlightInfo> getHighlights(QuickHelpKind kind) {
    switch (kind) {
      case QuickHelpKind.calculationType:
        return _calculationTypeHighlights;
      case QuickHelpKind.detailPeriods:
        return _detailPeriodsHighlights;
      case QuickHelpKind.companyHolidays:
        return _companyHolidaysHighlights;
    }
  }

  // ========== 산정 방식 ==========
  static const _calculationTypeSections = [
    HelpSection(
      title: '입사일 VS. 회계연도',
      description: '''회사가 입사일을 기준으로
1년마다 연차를 산정하면 입사일을 선택하고
통상 매년 1월 1일(또는 특정일)마다
1년단위로 연차휴가를 지급하면
회계연도를 선택하면 돼요''',
    ),
    HelpSection(
      title: '회계연도 연차계산법이란?',
      description: '''원칙적으로 연차유급휴가는 입사일 기준으로 산정해야해요.
하지만 편의를 위해 회계연도 기준을 연차를 계산하는것을 허용하고 있어요.
모든 직원의 입사일이 다르니, 연차발생일도 달라져 관리가 힘들기 때문이죠.''',
    ),
  ];

  static const _calculationTypeHighlights = [
    HighlightInfo(keyword: '1년마다 연차를 산정하면 입사일을 선택', colorIndex: 0),
    HighlightInfo(keyword: '1년단위로 연차휴가를 지급하면 회계연도를 선택', colorIndex: 0),
    HighlightInfo(keyword: '편의를 위해 회계연도 기준을 연차를 계산하는것을 허용', colorIndex: 0),
  ];

  // ========== 특이사항 기간 ==========
  static const _detailPeriodsSections = [
    HelpSection(
      title: '특이사항이 있는 기간은 무엇인가요?',
      description: '''해당 기간은 재직 중 일시적으로 근로 제공이 중단되었거나, 특별한 사정으로 인하여 정상적으로 근로하지 못한 기간을 의미해요.
유형에 따라
출근간주 / 결근처리 / 소정근로제외로 반영되며, 이에 따라 연차휴가 발생일수가 달라져요.

• 입력 범위 : 입사일 ~ 산정 기준일 사이
• 서로 기간이 겹치지 않게 등록이 가능
• 주말/공휴일은 자동 반영''',
    ),
  ];

  static const _detailPeriodsHighlights = [
    HighlightInfo(keyword: '정상적으로 근로하지 못한 기간을 의미', colorIndex: 0),
    HighlightInfo(keyword: '이에 따라 연차휴가 발생일수가 달라져요', colorIndex: 0),
  ];

  // ========== 회사 휴일 ==========
  static const _companyHolidaysSections = [
    HelpSection(
      title: '공휴일 외 회사휴일이 무엇인가요?',
      description: '''공식 휴일 외 회사 지정 특별휴일은
회사창립기념일, 단체협약상 유·무급휴일, 노조 창립기념일 등
법정공휴일을 제외하고 회사 내부 규정에 따라 부여되는 휴일을 의미합니다.''',
    ),
  ];

  static const _companyHolidaysHighlights = [
    HighlightInfo(keyword: '법정공휴일을 제외', colorIndex: 0),
    HighlightInfo(keyword: '내부 규정에 따라 부여되는 휴일', colorIndex: 0),
  ];
}
