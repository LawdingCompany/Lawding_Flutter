import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../../domain/entities/help_content.dart';

/// 순차적으로 하이라이트되는 텍스트 위젯
class AnimatedHighlightText extends StatefulWidget {
  final String text;
  final List<HighlightInfo> highlights;
  final int startDelay; // 밀리초 단위
  final int highlightInterval; // 각 하이라이트 간격 (밀리초)
  final TextStyle? baseStyle;

  const AnimatedHighlightText({
    super.key,
    required this.text,
    required this.highlights,
    this.startDelay = 0,
    this.highlightInterval = 450,
    this.baseStyle,
  });

  @override
  State<AnimatedHighlightText> createState() => _AnimatedHighlightTextState();
}

class _AnimatedHighlightTextState extends State<AnimatedHighlightText> {
  final List<_HighlightRange> _activeHighlights = [];
  int _currentHighlightIndex = 0;

  @override
  void initState() {
    super.initState();
    _startHighlightAnimation();
  }

  void _startHighlightAnimation() async {
    if (widget.highlights.isEmpty) return;

    // 초기 딜레이
    await Future.delayed(Duration(milliseconds: widget.startDelay));

    // 순차적으로 하이라이트 추가
    for (int i = 0; i < widget.highlights.length; i++) {
      if (!mounted) return;

      final highlight = widget.highlights[i];
      final ranges = _findKeywordRanges(widget.text, highlight.keyword);

      for (final range in ranges) {
        if (!mounted) return;
        setState(() {
          _activeHighlights.add(_HighlightRange(
            start: range.start,
            end: range.end,
            colorIndex: highlight.colorIndex,
          ));
          _currentHighlightIndex++;
        });

        await Future.delayed(Duration(milliseconds: widget.highlightInterval));
      }
    }
  }

  /// 키워드를 공백/개행 무시하고 찾기
  List<({int start, int end})> _findKeywordRanges(String text, String keyword) {
    final List<({int start, int end})> ranges = [];

    // 키워드의 토큰들 추출 (공백/개행으로 분리)
    final keywordTokens = keyword
        .split(RegExp(r'\s+'))
        .where((t) => t.isNotEmpty)
        .toList();

    if (keywordTokens.isEmpty) return ranges;

    // 텍스트를 순회하며 토큰 매칭
    int textPos = 0;
    while (textPos < text.length) {
      int matchStart = textPos;
      int matchEnd = textPos;
      int tokenIndex = 0;

      // 첫 번째 토큰 찾기
      while (matchEnd < text.length && tokenIndex < keywordTokens.length) {
        // 공백/개행 건너뛰기
        while (matchEnd < text.length && _isWhitespace(text[matchEnd])) {
          matchEnd++;
        }

        if (matchEnd >= text.length) break;

        // 현재 토큰과 매칭 시도
        final token = keywordTokens[tokenIndex];
        if (matchEnd + token.length <= text.length &&
            text.substring(matchEnd, matchEnd + token.length) == token) {
          if (tokenIndex == 0) {
            matchStart = matchEnd; // 첫 토큰의 시작 위치 기록
          }
          matchEnd += token.length;
          tokenIndex++;
        } else {
          break; // 매칭 실패
        }
      }

      // 모든 토큰이 매칭되었으면 범위 추가
      if (tokenIndex == keywordTokens.length) {
        ranges.add((start: matchStart, end: matchEnd));
        textPos = matchEnd;
      } else {
        textPos++;
      }
    }

    return ranges;
  }

  bool _isWhitespace(String char) {
    return char == ' ' || char == '\n' || char == '\t' || char == '\r';
  }

  @override
  Widget build(BuildContext context) {
    final baseStyle = widget.baseStyle ??
        pretendard(
          weight: 400,
          size: 17,
          color: AppColors.secondaryTextColor,
        );

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 250),
      child: RichText(
        key: ValueKey(_currentHighlightIndex),
        text: TextSpan(
          style: baseStyle,
          children: _buildTextSpans(baseStyle),
        ),
      ),
    );
  }

  List<InlineSpan> _buildTextSpans(TextStyle baseStyle) {
    if (_activeHighlights.isEmpty) {
      return [TextSpan(text: widget.text, style: baseStyle)];
    }

    // 하이라이트 범위를 정렬
    final sortedHighlights = List<_HighlightRange>.from(_activeHighlights)
      ..sort((a, b) => a.start.compareTo(b.start));

    final List<InlineSpan> spans = [];
    int currentPos = 0;

    for (final highlight in sortedHighlights) {
      // 하이라이트 전 일반 텍스트
      if (currentPos < highlight.start) {
        spans.add(TextSpan(
          text: widget.text.substring(currentPos, highlight.start),
          style: baseStyle,
        ));
      }

      // 하이라이트 텍스트
      spans.add(TextSpan(
        text: widget.text.substring(highlight.start, highlight.end),
        style: baseStyle.copyWith(
          backgroundColor: _getHighlightColor(highlight.colorIndex),
          color: AppColors.primaryTextColor,
        ),
      ));

      currentPos = highlight.end;
    }

    // 마지막 남은 텍스트
    if (currentPos < widget.text.length) {
      spans.add(TextSpan(
        text: widget.text.substring(currentPos),
        style: baseStyle,
      ));
    }

    return spans;
  }

  Color _getHighlightColor(int index) {
    const colors = [
      Color(0xFFFFFA99), // yellow highlighter
    ];
    return colors[index % colors.length];
  }
}

class _HighlightRange {
  final int start;
  final int end;
  final int colorIndex;

  _HighlightRange({
    required this.start,
    required this.end,
    required this.colorIndex,
  });
}
