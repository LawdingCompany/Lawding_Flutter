import 'package:flutter/material.dart';

/// UI 관련 헬퍼 함수들
class UiHelpers {
  /// SnackBar를 표시하는 헬퍼 함수
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
  }) {
    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        duration: duration,
      ),
    );
  }
}
