import 'package:flutter/material.dart';

import '../../../domain/entities/help_content.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/quick_help_library.dart';
import 'animated_highlight_text.dart';
import 'submit_button.dart';

/// 도움말 다이얼로그
///
/// 사용법:
/// ```dart
/// QuickHelpSheet.show(
///   context,
///   kind: QuickHelpKind.calculationType,
/// );
/// ```
class QuickHelpSheet extends StatelessWidget {
  final QuickHelpKind kind;

  const QuickHelpSheet({super.key, required this.kind});

  /// 도움말 다이얼로그 표시
  static Future<void> show(
    BuildContext context, {
    required QuickHelpKind kind,
  }) {
    return showDialog(
      context: context,
      barrierDismissible: true,
      barrierColor: AppColors.overlay,
      builder: (context) => QuickHelpSheet(kind: kind),
    );
  }

  @override
  Widget build(BuildContext context) {
    final sections = QuickHelpLibrary.getSections(kind);
    final highlights = QuickHelpLibrary.getHighlights(kind);

    // 각 섹션에 해당하는 하이라이트 필터링
    final sectionHighlights = <int, List<HighlightInfo>>{};
    for (int i = 0; i < sections.length; i++) {
      final sectionText = sections[i].description;
      sectionHighlights[i] = highlights
          .where((h) => sectionText.contains(h.keyword))
          .toList();
    }

    return Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        constraints: BoxConstraints(
          maxWidth: 360,
          maxHeight: MediaQuery.of(context).size.height * 0.7,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 30),
            Flexible(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 23),
                shrinkWrap: true,
                itemCount: sections.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 20),
                itemBuilder: (context, index) {
                  final section = sections[index];
                  final sectionHighlight = sectionHighlights[index] ?? [];

                  // 이전 섹션들의 하이라이트 개수 합산 (딜레이 계산용)
                  int previousHighlightCount = 0;
                  for (int i = 0; i < index; i++) {
                    previousHighlightCount +=
                        (sectionHighlights[i] ?? []).length;
                  }

                  return _HelpSectionWidget(
                    section: section,
                    highlights: sectionHighlight,
                    startDelay: previousHighlightCount * 450,
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
              child: SubmitButton(
                text: '확인',
                onPressed: () => Navigator.pop(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 도움말 섹션 위젯
class _HelpSectionWidget extends StatelessWidget {
  final HelpSection section;
  final List<HighlightInfo> highlights;
  final int startDelay;

  const _HelpSectionWidget({
    required this.section,
    required this.highlights,
    required this.startDelay,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(section.title, style: pretendard(weight: 700, size: 20)),
        const SizedBox(height: 8),
        AnimatedHighlightText(
          text: section.description,
          highlights: highlights,
          startDelay: startDelay,
          baseStyle: pretendard(
            weight: 400,
            size: 17,
            color: AppColors.secondaryTextColor,
          ),
        ),
      ],
    );
  }
}
