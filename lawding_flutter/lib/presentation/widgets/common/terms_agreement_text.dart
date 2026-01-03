import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class TermsAgreementText extends StatelessWidget {
  final VoidCallback onTermsTap;

  const TermsAgreementText({super.key, required this.onTermsTap});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        textAlign: TextAlign.left,
        text: TextSpan(
          style: pretendard(size: 12, weight: 500, color: hex('#BEC1C8')),
          children: [
            const TextSpan(text: '계산하기 버튼을 통해 앱 '),
            TextSpan(
              text: '이용약관',
              style: pretendard(size: 12, weight: 700, color: AppColors.brandColor),
              recognizer: TapGestureRecognizer()..onTap = onTermsTap,
            ),
            const TextSpan(text: '에 동의한 것으로 간주됩니다.'),
          ],
        ),
      ),
    );
  }
}
