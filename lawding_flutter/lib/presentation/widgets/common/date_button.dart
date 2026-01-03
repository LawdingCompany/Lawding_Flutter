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
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        decoration: BoxDecoration(
          color: hex('#FBFBFB'),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/calendar.png',
              width: 16,
              height: 16,
              color: hasDate ? AppColors.primaryTextColor : hex('#CCCCCC'),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                hasDate ? _formatDate(selectedDate!) : placeholder,
                style: pretendard(weight: 500, size: 15).copyWith(
                  color: hasDate ? AppColors.primaryTextColor : hex('#CCCCCC'),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
