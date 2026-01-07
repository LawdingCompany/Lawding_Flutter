/// 도움말 섹션 모델
class HelpSection {
  final String title;
  final String description;

  const HelpSection({required this.title, required this.description});
}

/// 도움말 종류
enum QuickHelpKind { calculationType, detailPeriods, companyHolidays }

/// 하이라이트 정보
class HighlightInfo {
  final String keyword;
  final int colorIndex;

  const HighlightInfo({required this.keyword, required this.colorIndex});
}
