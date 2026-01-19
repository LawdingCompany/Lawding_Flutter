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
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.backgroundLight,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: pretendard(
                weight: 700,
                size: 12,
              ).copyWith(color: AppColors.secondaryTextColor),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
