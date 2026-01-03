import 'package:flutter/material.dart';
import '../../core/app_text_styles.dart';
import '../common/badge_label.dart';
import '../common/card_container.dart';
import '../common/chevron_button.dart';
import '../common/help_button.dart';
import 'period_list_item.dart';

class PeriodListCard extends StatelessWidget {
  final String title;
  final List<PeriodItem> items;
  final VoidCallback onAddTap;
  final ValueChanged<int> onDeleteItem;
  final VoidCallback? onHelpTap;

  const PeriodListCard({
    super.key,
    required this.title,
    required this.items,
    required this.onAddTap,
    required this.onDeleteItem,
    this.onHelpTap,
  });

  @override
  Widget build(BuildContext context) {
    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(title, style: pretendard(weight: 700, size: 20)),
              const SizedBox(width: 5),
              HelpButton(onTap: onHelpTap),
              const Spacer(),
              ChevronButton(
                text: '추가하기',
                onTap: onAddTap,
              ),
            ],
          ),
          const SizedBox(height: 3),
          const BadgeLabel(text: '선택사항'),
          if (items.isNotEmpty) ...[
            const SizedBox(height: 8),
            ...List.generate(items.length, (index) {
              final item = items[index];
              return Padding(
                padding: EdgeInsets.only(top: index > 0 ? 8 : 0),
                child: PeriodListItem(
                  title: item.title,
                  duration: item.duration,
                  onDelete: () => onDeleteItem(index),
                ),
              );
            }),
          ],
        ],
      ),
    );
  }
}

class PeriodItem {
  final String title;
  final String duration;

  const PeriodItem({
    required this.title,
    required this.duration,
  });
}
