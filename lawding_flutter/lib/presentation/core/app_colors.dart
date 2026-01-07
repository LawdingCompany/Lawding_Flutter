import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand Color
  static const Color brandColor = Color(0xFF0057B8);

  // Primary Text Color
  static const Color primaryTextColor = Color(0xFF111111);

  // Secondary Text Color
  static const Color secondaryTextColor = Color(0xFF666666);
}

/// Hex 문자열을 Color로 변환
///
/// Example:
/// ```dart
/// Container(color: hex('#FBFBFB'))
/// Text('Hello', style: TextStyle(color: hex('#999999')))
/// ```
Color hex(String hexString) {
  final buffer = StringBuffer();
  if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
  buffer.write(hexString.replaceFirst('#', ''));
  return Color(int.parse(buffer.toString(), radix: 16));
}
