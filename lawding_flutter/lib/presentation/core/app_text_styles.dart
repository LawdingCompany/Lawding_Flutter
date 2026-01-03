import 'package:flutter/material.dart';

/// Pretendard 폰트를 weight와 size로 생성
///
/// Example:
/// ```dart
/// Text('Hello', style: pretendard(weight: 500, size: 23))
/// Text('World', style: pretendard(weight: 700, size: 15, color: Colors.red))
/// ```
TextStyle pretendard({
  required int weight,
  required double size,
  Color? color,
  double? height,
  double? letterSpacing,
}) {
  return TextStyle(
    fontFamily: 'Pretendard',
    fontSize: size,
    fontWeight: _getFontWeight(weight),
    color: color,
    height: height,
    letterSpacing: letterSpacing,
  );
}

/// FontWeight 매핑 (100-900)
FontWeight _getFontWeight(int weight) {
  switch (weight) {
    case 100:
      return FontWeight.w100;
    case 200:
      return FontWeight.w200;
    case 300:
      return FontWeight.w300;
    case 400:
      return FontWeight.w400;
    case 500:
      return FontWeight.w500;
    case 600:
      return FontWeight.w600;
    case 700:
      return FontWeight.w700;
    case 800:
      return FontWeight.w800;
    case 900:
      return FontWeight.w900;
    default:
      return FontWeight.w400; // 기본값
  }
}
