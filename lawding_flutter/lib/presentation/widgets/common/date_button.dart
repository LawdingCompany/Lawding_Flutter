import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class DateButton extends StatelessWidget {
  final String placeholder;
  final DateTime? selectedDate;
  final VoidCallback onTap;

  const DateButton({
    super.key,
    required this.placeholder,
    this.selectedDate,
    required this.onTap,
  });

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final hasDate = selectedDate != null;

    return GestureDetector(
      onTap: onTap,
      // 1. IntrinsicWidth 대신 SizedBox로 너비를 고정합니다.
      child: SizedBox(
        width: 150, // 초기 상태에 딱 맞는 적절한 너비를 직접 입력하세요.
        height: 44,
        child: Container(
          padding: const EdgeInsets.fromLTRB(12, 9, 15, 7),
          decoration: BoxDecoration(
            color: hex('#FBFBFB'),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center, // 2. 중앙 정렬 유지
            children: [
              Image.asset(
                'assets/icons/calendar.png',
                width: 16,
                height: 16,
                color: hasDate ? AppColors.primaryTextColor : hex('#CCCCCC'),
              ),
              const SizedBox(width: 7),
              // 3. 텍스트가 길어져도 넘치지 않게 Flexible로 감싸는 것이 안전합니다.
              Flexible(
                child: Text(
                  hasDate ? _formatDate(selectedDate!) : placeholder,
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis, // 혹시 길어지면 '...' 처리
                  style: pretendard(weight: 500, size: 15).copyWith(
                    color: hasDate
                        ? AppColors.primaryTextColor
                        : hex('#CCCCCC'),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
