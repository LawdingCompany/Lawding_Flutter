import 'package:flutter/material.dart';

import '../../infrastructure/services/app_version_service.dart';
import '../core/app_colors.dart';

/// 강제 업데이트 다이얼로그
class ForceUpdateDialog extends StatelessWidget {
  final String updateMessage;

  const ForceUpdateDialog({
    super.key,
    required this.updateMessage,
  });

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false, // 뒤로가기 버튼 비활성화
      child: AlertDialog(
        title: const Text(
          '업데이트 필요',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        content: Text(updateMessage, style: const TextStyle(fontSize: 16)),
        actions: [
          ElevatedButton(
            onPressed: () async {
              final appVersionService = AppVersionService();
              await appVersionService.openAppStore();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.brandColor,
              foregroundColor: Colors.white,
              minimumSize: const Size(double.infinity, 48),
            ),
            child: const Text(
              '업데이트',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  /// 다이얼로그 표시
  static Future<void> show(
    BuildContext context, {
    required String updateMessage,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: false, // 바깥 영역 터치 불가
      builder: (context) => ForceUpdateDialog(
        updateMessage: updateMessage,
      ),
    );
  }
}
