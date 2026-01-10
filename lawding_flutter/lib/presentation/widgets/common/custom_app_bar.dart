import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final List<Widget>? actions;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.actions,
  });

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    final canPop = Navigator.of(context).canPop();
    final routeDepth = ModalRoute.of(context)?.settings.name != null ? 2 : 1;
    final shouldShowBackButton = canPop || routeDepth >= 2;

    return AppBar(
      backgroundColor: backgroundColor ?? hex('#FBFBFB'),
      surfaceTintColor: backgroundColor ?? hex('#FBFBFB'),
      elevation: 0,
      scrolledUnderElevation: 0,
      leadingWidth: shouldShowBackButton ? 90 : null,
      leading: shouldShowBackButton
          ? GestureDetector(
              onTap: () => Navigator.pop(context),
              behavior: HitTestBehavior.opaque,
              child: Row(
                children: [
                  const SizedBox(width: 20),
                  Image.asset(
                    'assets/icons/back.png',
                    width: 18,
                    height: 18,
                    color: AppColors.brandColor,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '뒤로',
                    style: pretendard(
                      weight: 700,
                      size: 20,
                      color: AppColors.brandColor,
                    ),
                  ),
                ],
              ),
            )
          : null,
      title: Text(
        title,
        style: pretendard(weight: 700, size: 20, color: AppColors.brandColor),
      ),
      centerTitle: true,
      actions: actions,
    );
  }
}
