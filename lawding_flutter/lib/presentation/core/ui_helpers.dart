import 'package:flutter/material.dart';

import '../widgets/common/toast_message.dart';

/// UI 관련 헬퍼 함수들
class UiHelpers {
  /// 토스트 메시지를 표시하는 헬퍼 함수
  /// 기존 SnackBar 대신 커스텀 토스트 사용
  static void showSnackBar(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 2),
    bool isError = false,
  }) {
    if (!context.mounted) return;
    ToastManager().show(context, message, isError: isError);
  }

  /// 토스트 메시지 표시 (명시적 메서드명)
  static void showToast(
    BuildContext context,
    String message, {
    bool isError = false,
  }) {
    if (!context.mounted) return;
    ToastManager().show(context, message, isError: isError);
  }

  /// 에러 토스트 메시지 표시
  static void showError(BuildContext context, String message) {
    if (!context.mounted) return;
    ToastManager().show(context, message, isError: true);
  }
}
