import 'package:flutter/material.dart';
import '../../core/app_colors.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback? onTap;

  const HelpButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 20,
        height: 20,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: hex('#999999'), width: 1.5),
        ),
        child: Center(
          child: Text(
            '?',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: hex('#999999'),
            ),
          ),
        ),
      ),
    );
  }
}
