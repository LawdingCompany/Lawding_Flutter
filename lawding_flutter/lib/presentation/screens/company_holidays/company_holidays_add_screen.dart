import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../domain/entities/company_holiday_type.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../widgets/common/badge_label.dart';
import '../../widgets/common/card_container.dart';
import '../../widgets/common/date_button.dart';
import '../../widgets/common/dropdown_button.dart';
import '../../widgets/common/help_button.dart';
import '../../widgets/common/submit_button.dart';

class CompanyHolidaysAddScreen extends StatefulWidget {
  const CompanyHolidaysAddScreen({super.key});

  @override
  State<CompanyHolidaysAddScreen> createState() =>
      _CompanyHolidaysAddScreenState();
}

class _CompanyHolidaysAddScreenState extends State<CompanyHolidaysAddScreen> {
  CompanyHolidayType? selectedType;
  DateTime? selectedDate;

  Future<void> _showDatePicker(BuildContext context) async {
    final picked = await showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _DatePickerSheet(
        initialDate: selectedDate ?? DateTime.now(),
      ),
    );

    if (picked != null) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  String _formatDateToString(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  void _handleAddHoliday() {
    if (selectedType == null || selectedDate == null) {
      print('❌ 모든 필드를 채워주세요');
      return;
    }

    final data = {
      'date': _formatDateToString(selectedDate!),
      'displayName': selectedType!.displayName,
    };

    print('✅ 회사휴일 데이터 전송: $data');

    // Return data to previous screen
    Navigator.pop(context, data);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#FBFBFB'),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: hex('#FBFBFB'),
          surfaceTintColor: hex('#FBFBFB'),
          elevation: 0,
          scrolledUnderElevation: 0,
          centerTitle: true,
          leading: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(width: 20),
                  Icon(
                    Icons.chevron_left,
                    size: 23,
                    color: AppColors.brandColor,
                  ),
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
            ),
          ),
          leadingWidth: 80,
          title: Text(
            '선택사항',
            style: pretendard(weight: 700, size: 20, color: AppColors.brandColor),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text('공휴일 외 회사휴일',
                          style: pretendard(weight: 700, size: 20)),
                      const SizedBox(width: 8),
                      HelpButton(onTap: () {
                        // TODO: Show help dialog
                      }),
                    ],
                  ),
                  const SizedBox(height: 3),
                  const BadgeLabel(
                      text: '회사휴일은 최대 3개까지 입력 가능', isRequired: false),
                  const SizedBox(height: 18),
                  _buildReasonRow(),
                  const SizedBox(height: 12),
                  _buildDateRow(),
                ],
              ),
            ),
            const SizedBox(height: 20),
            SubmitButton(
              text: '추가하기',
              onPressed: _handleAddHoliday,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReasonRow() {
    return Row(
      children: [
        Text('사유', style: pretendard(weight: 700, size: 15)),
        const Spacer(),
        CustomDropdownButton<CompanyHolidayType>(
          selectedValue: selectedType?.displayName,
          items: CompanyHolidayType.values,
          itemBuilder: (type) => type.displayName,
          onChanged: (type) {
            setState(() {
              selectedType = type;
            });
          },
          placeholder: '선택',
        ),
      ],
    );
  }

  Widget _buildDateRow() {
    return Row(
      children: [
        Text('날짜', style: pretendard(weight: 700, size: 15)),
        const Spacer(),
        DateButton(
          placeholder: 'YYYY.MM.DD',
          selectedDate: selectedDate,
          onTap: () => _showDatePicker(context),
        ),
      ],
    );
  }
}

class _DatePickerSheet extends StatefulWidget {
  final DateTime initialDate;

  const _DatePickerSheet({required this.initialDate});

  @override
  State<_DatePickerSheet> createState() => _DatePickerSheetState();
}

class _DatePickerSheetState extends State<_DatePickerSheet> {
  late int selectedYear;
  late int selectedMonth;
  late int selectedDay;

  final List<int> years = List.generate(56, (i) => 1980 + i); // 1980-2035
  final List<int> months = List.generate(12, (i) => i + 1);

  @override
  void initState() {
    super.initState();
    selectedYear = widget.initialDate.year;
    selectedMonth = widget.initialDate.month;
    selectedDay = widget.initialDate.day;
  }

  List<int> get days {
    final daysInMonth = DateTime(selectedYear, selectedMonth + 1, 0).day;
    return List.generate(daysInMonth, (i) => i + 1);
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
            child: Row(
              children: [
                _buildPicker(years, selectedYear, (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    selectedYear = value;
                    if (selectedDay > days.length) {
                      selectedDay = days.length;
                    }
                  });
                }, '년'),
                _buildPicker(months, selectedMonth, (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    selectedMonth = value;
                    if (selectedDay > days.length) {
                      selectedDay = days.length;
                    }
                  });
                }, '월'),
                _buildPicker(days, selectedDay, (value) {
                  HapticFeedback.selectionClick();
                  setState(() {
                    selectedDay = value;
                  });
                }, '일'),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: SubmitButton(
              text: '확인',
              onPressed: () {
                Navigator.pop(
                  context,
                  DateTime(selectedYear, selectedMonth, selectedDay),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPicker(
    List<int> items,
    int selectedValue,
    ValueChanged<int> onChanged,
    String suffix,
  ) {
    return Expanded(
      child: CupertinoPicker(
        scrollController: FixedExtentScrollController(
          initialItem: items.indexOf(selectedValue),
        ),
        itemExtent: 40,
        onSelectedItemChanged: (index) => onChanged(items[index]),
        children: items.map((item) {
          return Center(
            child: Text(
              '$item$suffix',
              style: pretendard(weight: 500, size: 23),
            ),
          );
        }).toList(),
      ),
    );
  }
}
