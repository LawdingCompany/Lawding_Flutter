import 'package:flutter/material.dart';

import '../../core/app_text_styles.dart';
import '../../core/color_extensions.dart';

/// 결과 화면에서 사용되는 연차 유형 배지
///
/// leaveType 값에 따라 4가지 배지 표시:
/// - MONTHLY: 월차
/// - ANNUAL: 연차
/// - PRORATED: 비례연차
/// - MONTHLY_PRORATED: 월차 + 비례연차
class ResultBadge extends StatelessWidget {
  final String leaveType;

  const ResultBadge({super.key, required this.leaveType});

  String get _badgeText {
    switch (leaveType.toUpperCase()) {
      case 'MONTHLY':
        return '월차';
      case 'ANNUAL':
        return '연차';
      case 'PRORATED':
        return '비례연차';
      case 'MONTHLY_AND_PRORATED':
        return '월차 + 비례연차';
      default:
        return '연차';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 16, // 필요하다면 유지, 하지만 패딩으로 조절하는게 더 유연합니다.
      decoration: BoxDecoration(color: HexColor.fromHex('#CFE6FF')),
      padding: const EdgeInsets.symmetric(
        horizontal: 3,
        vertical: 2,
      ), // 좌우 3, 상하 2 여백
      child: Text(
        _badgeText,
        style: pretendard(
          weight: 700,
          size: 11,
          color: HexColor.fromHex('#0057B8'),
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
