import 'package:flutter/material.dart';

extension HexColor on Color {
  /// #RRGGBB 또는 #AARRGGBB 형식의 Hex 문자열을 Color로 변환
  static Color fromHex(String hexString) {
    final buffer = StringBuffer();
    if (hexString.length == 6 || hexString.length == 7) buffer.write('ff');
    buffer.write(hexString.replaceFirst('#', ''));
    return Color(int.parse(buffer.toString(), radix: 16));
  }

  /// Color를 #RRGGBB 형식의 Hex 문자열로 변환
  String toHex({bool leadingHashSign = true}) {
    final a = (this.a * 255.0).round().clamp(0, 255);
    final r = (this.r * 255.0).round().clamp(0, 255);
    final g = (this.g * 255.0).round().clamp(0, 255);
    final b = (this.b * 255.0).round().clamp(0, 255);

    return '${leadingHashSign ? '#' : ''}'
        '${a.toRadixString(16).padLeft(2, '0')}'
        '${r.toRadixString(16).padLeft(2, '0')}'
        '${g.toRadixString(16).padLeft(2, '0')}'
        '${b.toRadixString(16).padLeft(2, '0')}';
  }
}
