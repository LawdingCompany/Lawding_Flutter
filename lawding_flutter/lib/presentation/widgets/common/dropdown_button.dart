import 'package:flutter/material.dart';
import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';

class CustomDropdownButton<T> extends StatefulWidget {
  final String? selectedValue;
  final List<T> items;
  final String Function(T) itemBuilder;
  final ValueChanged<T> onChanged;
  final String placeholder;

  const CustomDropdownButton({
    super.key,
    this.selectedValue,
    required this.items,
    required this.itemBuilder,
    required this.onChanged,
    this.placeholder = '선택',
  });

  @override
  State<CustomDropdownButton<T>> createState() => _CustomDropdownButtonState<T>();
}

class _CustomDropdownButtonState<T> extends State<CustomDropdownButton<T>>
    with SingleTickerProviderStateMixin {
  OverlayEntry? _overlayEntry;
  final LayerLink _layerLink = LayerLink();
  AnimationController? _animationController;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 200),
    );
  }

  void _toggleDropdown() {
    if (_overlayEntry != null) {
      _removeOverlay();
    } else {
      _showOverlay();
    }
  }

  void _showOverlay() {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _animationController!.forward();

    _overlayEntry = OverlayEntry(
      builder: (context) => GestureDetector(
        onTap: _removeOverlay,
        behavior: HitTestBehavior.translucent,
        child: Stack(
          children: [
            Positioned.fill(
              child: Container(color: Colors.transparent),
            ),
            Positioned(
              width: size.width,
              child: CompositedTransformFollower(
                link: _layerLink,
                showWhenUnlinked: false,
                offset: Offset(0, size.height + 4),
                child: AnimatedBuilder(
                  animation: _animationController!,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: 0.95 + (0.05 * _animationController!.value),
                      alignment: Alignment.topCenter,
                      child: Opacity(
                        opacity: _animationController!.value,
                        child: child,
                      ),
                    );
                  },
                  child: Material(
                    elevation: 8,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      constraints: const BoxConstraints(maxHeight: 280),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: const Color(0x1A000000),
                            blurRadius: 10,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: ListView.builder(
                        padding: EdgeInsets.zero,
                        shrinkWrap: true,
                        itemCount: widget.items.length,
                        itemBuilder: (context, index) {
                          final item = widget.items[index];
                          final itemTitle = widget.itemBuilder(item);
                          final isSelected = itemTitle == widget.selectedValue;

                          return InkWell(
                            onTap: () {
                              widget.onChanged(item);
                              _removeOverlay();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                              decoration: BoxDecoration(
                                border: index < widget.items.length - 1
                                    ? Border(
                                        bottom: BorderSide(
                                          color: hex('#F0F0F0'),
                                          width: 1,
                                        ),
                                      )
                                    : null,
                              ),
                              child: Text(
                                itemTitle,
                                style: pretendard(
                                  weight: isSelected ? 600 : 500,
                                  size: 15,
                                  color: isSelected ? AppColors.brandColor : AppColors.primaryTextColor,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() async {
    await _animationController!.reverse();
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  @override
  void dispose() {
    _animationController?.dispose();
    _overlayEntry?.remove();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: Container(
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            color: hex('#FBFBFB'),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(
                width: 144,
                child: Text(
                  widget.selectedValue ?? widget.placeholder,
                  textAlign: TextAlign.center,
                  style: pretendard(weight: 500, size: 15).copyWith(
                    color: widget.selectedValue != null
                        ? AppColors.primaryTextColor
                        : hex('#CCCCCC'),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Icon(
                Icons.keyboard_arrow_down,
                size: 20,
                color: hex('#CCCCCC'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
