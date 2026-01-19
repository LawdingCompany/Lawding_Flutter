import 'dart:async';

import 'package:flutter/material.dart';

import '../../core/design_system.dart';

/// 커스텀 토스트 메시지 매니저
/// 싱글톤 패턴으로 중복 토스트 방지
class ToastManager {
  static final ToastManager _instance = ToastManager._internal();
  factory ToastManager() => _instance;
  ToastManager._internal();

  OverlayEntry? _currentEntry;
  Timer? _dismissTimer;

  /// 토스트 메시지 표시
  /// [context] BuildContext
  /// [message] 표시할 메시지
  /// [isError] 에러 스타일 여부 (기본: false)
  void show(BuildContext context, String message, {bool isError = false}) {
    // 기존 토스트가 있으면 즉시 제거
    _dismiss();

    final overlay = Overlay.of(context);
    _currentEntry = _createOverlayEntry(context, message, isError: isError);
    overlay.insert(_currentEntry!);

    _dismissTimer = Timer(const Duration(milliseconds: 1500), _dismiss);
  }

  OverlayEntry _createOverlayEntry(
    BuildContext context,
    String message, {
    required bool isError,
  }) {
    return OverlayEntry(
      builder: (context) => Positioned(
        bottom: MediaQuery.of(context).padding.bottom + 80,
        left: 40,
        right: 40,
        child: Material(
          color: Colors.transparent,
          child: _ToastWidget(
            message: message,
            isError: isError,
            onDismiss: _dismiss,
          ),
        ),
      ),
    );
  }

  void _dismiss() {
    _dismissTimer?.cancel();
    _dismissTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
  }
}

class _ToastWidget extends StatefulWidget {
  final String message;
  final bool isError;
  final VoidCallback onDismiss;

  const _ToastWidget({
    required this.message,
    required this.isError,
    required this.onDismiss,
  });

  @override
  State<_ToastWidget> createState() => _ToastWidgetState();
}

class _ToastWidgetState extends State<_ToastWidget>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
      reverseCurve: Curves.easeIn,
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOut));

    _controller.forward();

    // 1.9초 후 fadeOut 시작
    Future.delayed(const Duration(milliseconds: 1900), () {
      if (mounted) {
        _controller.reverse();
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
        opacity: _fadeAnimation,
        child: Center(
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: widget.isError
                  ? const Color(0xE6D32F2F) // 에러: 빨간색 90%
                  : const Color(0x8F000000), // 기본: 검정 56%
              borderRadius: BorderRadius.circular(10),
              boxShadow: const [
                BoxShadow(
                  color: AppColors.shadow,
                  blurRadius: 8,
                  offset: Offset(0, 2),
                ),
              ],
            ),
            child: Text(
              widget.message,
              textAlign: TextAlign.center,
              style: pretendard(weight: 500, size: 14, color: Colors.white),
            ),
          ),
        ),
      ),
    );
  }
}
