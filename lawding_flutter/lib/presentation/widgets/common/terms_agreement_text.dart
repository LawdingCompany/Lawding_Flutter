import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

import '../../core/design_system.dart';

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
          style: pretendard(
            size: 12,
            weight: 500,
            color: AppColors.secondaryTextColor,
          ),
          children: [
            const TextSpan(text: '계산하기 버튼을 통해 앱 '),
            TextSpan(
              text: '이용약관',
              style: pretendard(
                size: 12,
                weight: 700,
                color: AppColors.brandColor,
              ).copyWith(decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()..onTap = onTermsTap,
            ),
            const TextSpan(text: '에 동의한 것으로 간주됩니다.'),
          ],
        ),
      ),
    );
  }
}
