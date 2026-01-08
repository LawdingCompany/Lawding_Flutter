import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/ui_helpers.dart';
import '../../widgets/common/card_container.dart';
import '../../widgets/common/submit_button.dart';
import 'feedback_view_model.dart';

class FeedbackScreen extends ConsumerStatefulWidget {
  final String? calculationId;

  const FeedbackScreen({super.key, this.calculationId});

  @override
  ConsumerState<FeedbackScreen> createState() => _FeedbackScreenState();
}

class _FeedbackScreenState extends ConsumerState<FeedbackScreen> {
  int _selectedTypeIndex = 0;
  final TextEditingController _contentController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  final List<String> _feedbackTypes = ['오류 제보', '서비스 문의', '개선 요청', '기타'];

  @override
  void initState() {
    super.initState();
    if (widget.calculationId != null) {
      Future.microtask(() {
        ref.read(feedbackViewModelProvider.notifier).setCalculationId(widget.calculationId);
      });
    }
  }

  @override
  void dispose() {
    _contentController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Alignment _getAlignment(int index) {
    // 4개 항목: 0, 1, 2, 3
    // Alignment.x 값: -1.0 (왼쪽) ~ 1.0 (오른쪽)
    final double xPosition = -1.0 + (index * 2.0 / (_feedbackTypes.length - 1));
    return Alignment(xPosition, 0);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: hex('#FBFBFB'),
      appBar: AppBar(
        backgroundColor: hex('#FBFBFB'),
        surfaceTintColor: hex('#FBFBFB'),
        elevation: 0,
        scrolledUnderElevation: 0,
        leadingWidth: 90,
        leading: GestureDetector(
          onTap: () => Navigator.pop(context),
          behavior: HitTestBehavior.opaque,
          child: Row(
            children: [
              const SizedBox(width: 20),
              const Icon(
                Icons.arrow_back_ios,
                size: 18,
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
        ),
        title: Text(
          '피드백',
          style: pretendard(weight: 700, size: 20, color: AppColors.brandColor),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CardContainer(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '유형',
                    style: pretendard(
                      weight: 700,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 34,
                    decoration: BoxDecoration(
                      color: hex('#F5F5F5'),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: hex('#E1E1E1'), width: 2),
                    ),
                    child: Stack(
                      children: [
                        // 선택된 배경 애니메이션
                        AnimatedAlign(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeInOut,
                          alignment: _getAlignment(_selectedTypeIndex),
                          child: FractionallySizedBox(
                            widthFactor: 1 / _feedbackTypes.length,
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                          ),
                        ),
                        // 구분선들
                        Row(
                          children: List.generate(
                            _feedbackTypes.length * 2 - 1,
                            (index) {
                              if (index.isOdd) {
                                return Container(
                                  width: 1,
                                  height: 18,
                                  margin: const EdgeInsets.symmetric(
                                    vertical: 8,
                                  ),
                                  color: hex('#E1E1E1'),
                                );
                              }
                              return const Expanded(child: SizedBox.shrink());
                            },
                          ),
                        ),
                        // 텍스트들
                        Row(
                          children: List.generate(_feedbackTypes.length, (
                            index,
                          ) {
                            final isSelected = index == _selectedTypeIndex;
                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    _selectedTypeIndex = index;
                                  });
                                  ref.read(feedbackViewModelProvider.notifier).setFeedbackType(index);
                                },
                                behavior: HitTestBehavior.opaque,
                                child: Center(
                                  child: AnimatedDefaultTextStyle(
                                    duration: const Duration(milliseconds: 200),
                                    style: pretendard(
                                      weight: 700,
                                      size: 12,
                                      color: isSelected
                                          ? AppColors.primaryTextColor
                                          : hex('#DADADA'),
                                    ),
                                    child: Text(_feedbackTypes[index]),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '내용',
                    style: pretendard(
                      weight: 700,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 240,
                    padding: const EdgeInsets.all(13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: hex('#E1E1E1')),
                    ),
                    child: TextField(
                      controller: _contentController,
                      onChanged: (value) {
                        ref.read(feedbackViewModelProvider.notifier).setContent(value);
                      },
                      maxLines: null,
                      expands: true,
                      textAlignVertical: TextAlignVertical.top,
                      style: pretendard(
                        weight: 500,
                        size: 15,
                        color: AppColors.primaryTextColor,
                      ),
                      decoration: InputDecoration(
                        hintText: '소중한 의견을 남겨주세요.(최소 5자)',
                        hintStyle: pretendard(
                          weight: 500,
                          size: 15,
                          color: hex('#999999'),
                        ),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    '답변 받을 이메일',
                    style: pretendard(
                      weight: 700,
                      size: 20,
                      color: AppColors.primaryTextColor,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Container(
                    height: 35,
                    padding: const EdgeInsets.symmetric(horizontal: 13),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: hex('#E1E1E1')),
                    ),
                    child: Center(
                      child: TextField(
                        controller: _emailController,
                        onChanged: (value) {
                          ref.read(feedbackViewModelProvider.notifier).setEmail(value);
                        },
                        keyboardType: TextInputType.emailAddress,
                        textAlignVertical: TextAlignVertical.center,
                        style: pretendard(
                          weight: 500,
                          size: 14,
                          color: AppColors.primaryTextColor,
                        ),
                        decoration: InputDecoration(
                          hintText: '(예) example@email.com',
                          hintStyle: pretendard(
                            weight: 400,
                            size: 14,
                            color: hex('#999999'),
                          ),
                          isCollapsed: true,
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 33),
                  Consumer(
                    builder: (context, ref, child) {
                      final state = ref.watch(feedbackViewModelProvider);
                      return GestureDetector(
                        onTap: () {
                          ref.read(feedbackViewModelProvider.notifier).setIncludeCalculationData(!state.includeCalculationData);
                        },
                        child: Row(
                          children: [
                            Text(
                              '계산 정보 함께 보내기',
                              style: pretendard(
                                weight: 700,
                                size: 20,
                                color: AppColors.primaryTextColor,
                              ),
                            ),
                            const Spacer(),
                            Switch(
                              value: state.includeCalculationData,
                              onChanged: (value) {
                                ref.read(feedbackViewModelProvider.notifier).setIncludeCalculationData(value);
                              },
                              activeThumbColor: AppColors.brandColor,
                              activeTrackColor: hex('#CFE6FF'),
                              inactiveThumbColor: hex('#D9D9D9'),
                              inactiveTrackColor: hex('#F6F6F6'),
                              trackOutlineColor: WidgetStateProperty.all(
                                hex('#E1E1E1'),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 23),
            Text(
              '여러분의 소중한 의견에 정성스럽게 답변드리겠습니다',
              style: pretendard(weight: 500, size: 12, color: hex('#999999')),
            ),
            const SizedBox(height: 32),
            Consumer(
              builder: (context, ref, child) {
                final state = ref.watch(feedbackViewModelProvider);
                return SubmitButton(
                  text: '보내기',
                  isLoading: state.isLoading,
                  onPressed: () => _submitFeedback(ref),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _submitFeedback(WidgetRef ref) async {
    final viewModel = ref.read(feedbackViewModelProvider.notifier);

    final validationError = viewModel.validateFeedback();
    if (validationError != null) {
      UiHelpers.showSnackBar(context, validationError);
      return;
    }

    await viewModel.submitFeedback();

    if (!mounted) return;

    final state = ref.read(feedbackViewModelProvider);

    if (state.isSubmitted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            '소중한 의견 감사합니다.',
            style: pretendard(weight: 500, size: 14),
          ),
          backgroundColor: AppColors.brandColor,
        ),
      );
      Navigator.pop(context);
    } else if (state.error != null) {
      UiHelpers.showSnackBar(context, state.error!);
    }
  }
}
