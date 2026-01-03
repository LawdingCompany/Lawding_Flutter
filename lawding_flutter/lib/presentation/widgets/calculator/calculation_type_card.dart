import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../common/badge_label.dart';
import '../common/card_container.dart';
import '../common/custom_segmented_control.dart';
import '../common/date_button.dart';
import '../common/help_button.dart';
import '../common/primary_button.dart';

class CalculationTypeCard extends StatefulWidget {
  final int selectedTypeIndex;
  final ValueChanged<int> onTypeChanged;
  final DateTime? hireDate;
  final DateTime? referenceDate;
  final int fiscalYearStartMonth; // 1-12
  final ValueChanged<int> onFiscalYearStartMonthChanged;
  final VoidCallback onHireDateTap;
  final VoidCallback onReferenceDateTap;
  final VoidCallback? onHelpTap;

  const CalculationTypeCard({
    super.key,
    required this.selectedTypeIndex,
    required this.onTypeChanged,
    this.hireDate,
    this.referenceDate,
    required this.fiscalYearStartMonth,
    required this.onFiscalYearStartMonthChanged,
    required this.onHireDateTap,
    required this.onReferenceDateTap,
    this.onHelpTap,
  });

  @override
  State<CalculationTypeCard> createState() => _CalculationTypeCardState();
}

class _CalculationTypeCardState extends State<CalculationTypeCard> {
  String _getMonthDayText(int month) {
    return '$month월 1일';
  }

  void _showMonthPicker(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _MonthPickerSheet(
        initialMonth: widget.fiscalYearStartMonth,
        onMonthSelected: widget.onFiscalYearStartMonthChanged,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isFiscalYear = widget.selectedTypeIndex == 1;

    return CardContainer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text('산정 방식', style: pretendard(weight: 700, size: 20)),
              const SizedBox(width: 8),
              HelpButton(onTap: widget.onHelpTap),
            ],
          ),
          const SizedBox(height: 3),
          const BadgeLabel(text: '필수사항', isRequired: true),
          const SizedBox(height: 18),
          CustomSegmentedControl(
            items: const ['입사일', '회계연도'],
            selectedIndex: widget.selectedTypeIndex,
            onChanged: widget.onTypeChanged,
          ),
          const SizedBox(height: 12),
          _buildDateRow('입사일', widget.hireDate, widget.onHireDateTap),
          const SizedBox(height: 12),
          _buildDateRow('계산 기준일', widget.referenceDate, widget.onReferenceDateTap),
          // 회계연도 시작일 필드 (애니메이션)
          AnimatedSize(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            child: isFiscalYear
                ? Column(
                    children: [
                      const SizedBox(height: 12),
                      _buildMonthRow(
                        '회계연도 시작일',
                        widget.fiscalYearStartMonth,
                        () => _showMonthPicker(context),
                      ),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

  Widget _buildDateRow(String label, DateTime? date, VoidCallback onTap) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: pretendard(weight: 500, size: 15)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: DateButton(
            placeholder: 'YYYY.MM.DD',
            selectedDate: date,
            onTap: onTap,
          ),
        ),
      ],
    );
  }

  Widget _buildMonthRow(String label, int month, VoidCallback onTap) {
    return Row(
      children: [
        SizedBox(
          width: 100,
          child: Text(label, style: pretendard(weight: 500, size: 15)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              height: 44,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: hex('#FBFBFB'),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  Image.asset(
                    'assets/icons/calendar.png',
                    width: 16,
                    height: 16,
                    color: AppColors.primaryTextColor,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _getMonthDayText(month),
                      style: pretendard(weight: 500, size: 15, color: AppColors.primaryTextColor),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _MonthPickerSheet extends StatefulWidget {
  final int initialMonth;
  final ValueChanged<int> onMonthSelected;

  const _MonthPickerSheet({
    required this.initialMonth,
    required this.onMonthSelected,
  });

  @override
  State<_MonthPickerSheet> createState() => _MonthPickerSheetState();
}

class _MonthPickerSheetState extends State<_MonthPickerSheet> {
  late int selectedMonth;

  @override
  void initState() {
    super.initState();
    selectedMonth = widget.initialMonth;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 310,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: hex('#E0E0E0'),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 18),
          Expanded(
            child: CupertinoPicker(
              scrollController: FixedExtentScrollController(
                initialItem: selectedMonth - 1,
              ),
              itemExtent: 40,
              onSelectedItemChanged: (index) {
                HapticFeedback.selectionClick();
                setState(() {
                  selectedMonth = index + 1;
                });
              },
              children: List.generate(12, (index) {
                return Center(
                  child: Text(
                    '${index + 1}월',
                    style: pretendard(weight: 500, size: 23),
                  ),
                );
              }),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: PrimaryButton(
              text: '확인',
              onPressed: () {
                widget.onMonthSelected(selectedMonth);
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
    );
  }
}
