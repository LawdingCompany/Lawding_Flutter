import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../widgets/calculator/calculation_type_card.dart';
import '../../widgets/calculator/period_list_card.dart';
import '../../widgets/common/primary_button.dart';
import '../../widgets/common/terms_agreement_text.dart';
import 'calculator_view_model.dart';

class CalculatorScreen extends ConsumerWidget {
  const CalculatorScreen({super.key});

  String _formatDate(DateTime date) {
    return '${date.year}.${date.month.toString().padLeft(2, '0')}.${date.day.toString().padLeft(2, '0')}';
  }

  String _formatPeriod(DateTime start, DateTime end) {
    return '${_formatDate(start)} ~ ${_formatDate(end)} · ${end.difference(start).inDays + 1}일';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(calculatorViewModelProvider.notifier);
    final state = ref.watch(calculatorViewModelProvider);

    return Scaffold(
      backgroundColor: hex('#FBFBFB'),
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(56),
        child: AppBar(
          backgroundColor: hex('#FBFBFB'),
          surfaceTintColor: hex('#FBFBFB'),
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          leadingWidth: 150,
          leading: Padding(
            padding: const EdgeInsets.only(left: 20),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'LawDing',
                style: pretendard(weight: 700, size: 20, color: AppColors.brandColor),
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            CalculationTypeCard(
              selectedTypeIndex:
                  state.calculationType.code == 1 ? 0 : 1,
              onTypeChanged: viewModel.setCalculationType,
              hireDate: state.hireDate,
              referenceDate: state.referenceDate,
              fiscalYearStartMonth: state.fiscalYearStartMonth,
              onFiscalYearStartMonthChanged: viewModel.setFiscalYearStartMonth,
              onHireDateTap: () => _showDatePicker(
                context,
                state.hireDate,
                viewModel.setHireDate,
              ),
              onReferenceDateTap: () => _showDatePicker(
                context,
                state.referenceDate,
                viewModel.setReferenceDate,
              ),
              onHelpTap: () {
                // TODO: Show help dialog
              },
            ),
            const SizedBox(height: 20),
            PeriodListCard(
              title: '특이 사항이 있는 기간',
              items: state.nonWorkingPeriods
                  .map((p) => PeriodItem(
                        title: p.type.displayName,
                        duration: _formatPeriod(p.startDate, p.endDate),
                      ))
                  .toList(),
              onAddTap: () {
                // TODO: Navigate to add period screen
              },
              onDeleteItem: viewModel.removeNonWorkingPeriod,
              onHelpTap: () {
                // TODO: Show help dialog
              },
            ),
            const SizedBox(height: 20),
            PeriodListCard(
              title: '공휴일 외 회사휴일',
              items: state.companyHolidays
                  .map((date) => PeriodItem(
                        title: '회사휴일',
                        duration: _formatDate(date),
                      ))
                  .toList(),
              onAddTap: () {
                // TODO: Navigate to add holiday screen
              },
              onDeleteItem: viewModel.removeCompanyHoliday,
              onHelpTap: () {
                // TODO: Show help dialog
              },
            ),
            const SizedBox(height: 20),
            TermsAgreementText(
              onTermsTap: () {
                // TODO: Show terms of service
              },
            ),
            const SizedBox(height: 20),
            PrimaryButton(
              text: '계산하기',
              isLoading: state.isLoading,
              onPressed: () async {
                await viewModel.calculate();
                if (state.result != null) {
                  // TODO: Navigate to result screen
                } else if (state.error != null) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(state.error!)),
                    );
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showDatePicker(
    BuildContext context,
    DateTime? initialDate,
    Function(DateTime) onDateSelected,
  ) async {
    final picked = await _showIOSStyleDatePicker(
      context,
      initialDate ?? DateTime.now(),
    );

    if (picked != null) {
      onDateSelected(picked);
    }
  }

  Future<DateTime?> _showIOSStyleDatePicker(
    BuildContext context,
    DateTime initialDate,
  ) {
    return showModalBottomSheet<DateTime>(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => _DatePickerSheet(initialDate: initialDate),
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
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: years.indexOf(selectedYear),
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        selectedYear = years[index];
                        if (selectedDay > days.length) {
                          selectedDay = days.last;
                        }
                      });
                    },
                    children: years.map((year) {
                      return Center(
                        child: Text(
                          '$year년',
                          style: pretendard(weight: 500, size: 23),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedMonth - 1,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        selectedMonth = months[index];
                        if (selectedDay > days.length) {
                          selectedDay = days.last;
                        }
                      });
                    },
                    children: months.map((month) {
                      return Center(
                        child: Text(
                          '$month월',
                          style: pretendard(weight: 500, size: 23),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Expanded(
                  child: CupertinoPicker(
                    scrollController: FixedExtentScrollController(
                      initialItem: selectedDay - 1,
                    ),
                    itemExtent: 40,
                    onSelectedItemChanged: (index) {
                      HapticFeedback.selectionClick();
                      setState(() {
                        selectedDay = days[index];
                      });
                    },
                    children: days.map((day) {
                      return Center(
                        child: Text(
                          '$day일',
                          style: pretendard(weight: 500, size: 23),
                        ),
                      );
                    }).toList(),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 30),
            child: PrimaryButton(
              text: '확인',
              onPressed: () {
                final selectedDate = DateTime(
                  selectedYear,
                  selectedMonth,
                  selectedDay,
                );
                Navigator.pop(context, selectedDate);
              },
            ),
          ),
        ],
      ),
    );
  }
}
