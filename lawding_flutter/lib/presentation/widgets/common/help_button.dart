import 'package:flutter/material.dart';

import '../../core/design_system.dart';

class HelpButton extends StatelessWidget {
  final VoidCallback? onTap;

  const HelpButton({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Image.asset(
        'assets/icons/questionmark.png',
        width: 16,
        height: 16,
        color: AppColors.secondaryTextColor,
      ),
    );
  }
}
