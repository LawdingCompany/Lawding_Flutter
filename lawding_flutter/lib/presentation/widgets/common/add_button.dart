import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class AddButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const AddButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: hex('#F6F6F6'),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              text,
              style: pretendard(weight: 700, size: 12).copyWith(
                color: hex('#DADADA'),
              ),
            ),
            const SizedBox(width: 4),
          ],
        ),
      ),
    );
  }
}
