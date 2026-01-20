import 'package:flutter/material.dart';

import '../../core/design_system.dart';

class BadgeLabel extends StatelessWidget {
  final String text;
  final bool isRequired;

  const BadgeLabel({super.key, required this.text, this.isRequired = false});

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: isRequired ? AppColors.brandLight : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: Text(
          text,
          style: pretendard(
            weight: isRequired ? 700 : 500,
            size: 9,
            color: isRequired
                ? AppColors.brandColor
                : AppColors.secondaryTextColor,
          ),
        ),
      ),
    );
  }
}
