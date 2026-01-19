import 'package:flutter/material.dart';

import '../../core/design_system.dart';

class BadgeLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const BadgeLabel({super.key, required this.text, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: isRequired ? AppColors.brandLight : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        style: isRequired
            ? pretendard(weight: 700, size: 9, color: AppColors.brandColor)
            : pretendard(
                weight: 500,
                size: 9,
                color: AppColors.secondaryTextColor,
              ),
      ),
    );
  }
}
