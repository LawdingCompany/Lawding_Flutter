import 'package:flutter/material.dart';

import '../../core/design_system.dart';

class AddButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AddButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 8),
          child: Text(
            text,
            style: pretendard(
              weight: 700,
              size: 12,
              color: AppColors.secondaryTextColor,
            ),
          ),
        ),
      ),
    );
  }
}
