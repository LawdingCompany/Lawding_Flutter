import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class BadgeLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const BadgeLabel({
    super.key,
    required this.text,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isRequired ? hex('#CFE6FF') : hex('#F6F6F6'),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: pretendard(size: 9, weight: 500).copyWith(
          color: isRequired ? AppColors.brandColor : hex('#BEC1C8'),
        ),
      ),
    );
  }
}
