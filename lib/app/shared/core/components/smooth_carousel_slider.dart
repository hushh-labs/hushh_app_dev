import 'package:flutter/material.dart';

class SmoothCarouselSlider extends StatefulWidget {
  const SmoothCarouselSlider({
    Key? key,
    required this.initialSelectedIndex,
    required this.itemCount,
    required this.itemExtent,
    required this.onSelectedItemChanged,
    required this.unSelectedWidget,
    required this.selectedWidget,
    this.backgroundColor,
    this.scale = 1.2,
    this.yOffset = 30,
  }) : super(key: key);

  ///Number of Items in list
  final int itemCount;

  /// Size of each child in the main axis. Must not be null and must be
  /// positive.
  final double itemExtent;

  ///The index of initial selected Item
  final int initialSelectedIndex;

  /// On optional listener that's called when the selected item changes.
  final void Function(int)? onSelectedItemChanged;

  /// unselected widget
  final Widget Function(int index) unSelectedWidget;

  ///Selected widget
  final Widget Function(int index) selectedWidget;

  ///background color
  final Color? backgroundColor;

  ///scale applied to selected item
  final double scale;

  /// the Y offset of unSelected widget
  final double yOffset;

  @override
  State<SmoothCarouselSlider> createState() => _SmoothCarouselSliderState();
}

class _SmoothCarouselSliderState extends State<SmoothCarouselSlider> {
  final _scrollController = FixedExtentScrollController();
  late int _selectedindex;

  /// To create the illusion of infinite scrolling, increase the size of the list.
  int get _virtualItemCount => widget.itemCount * 10000;

  /// Helper to map virtual index to the real index in the original list
  int _realIndex(int virtualIndex) => virtualIndex % widget.itemCount;

  void _scrollToIndex(int index) {
    _scrollController.jumpTo(widget.itemExtent * index.toDouble());
  }

  void _setSelectedIndex(int index) {
    setState(() {
      _selectedindex = _realIndex(index);
    });
  }

  @override
  void initState() {
    super.initState();
    final initialIndex = widget.initialSelectedIndex + _virtualItemCount ~/ 2;
    _setSelectedIndex(initialIndex);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollToIndex(initialIndex);
    });
  }

  @override
  Widget build(BuildContext context) {
    return RotatedBox(
      quarterTurns: -1,
      child: ListWheelScrollView.useDelegate(
        physics: const FixedExtentScrollPhysics(),
        controller: _scrollController,
        itemExtent: widget.itemExtent,
        diameterRatio: 100,
        onSelectedItemChanged: (value) {
          _setSelectedIndex(value);
          if (widget.onSelectedItemChanged != null) {
            widget.onSelectedItemChanged!(_realIndex(value));
          }
        },
        childDelegate: ListWheelChildBuilderDelegate(
          builder: (context, index) {
            final realIndex = _realIndex(index);
            final isSelected = realIndex == _selectedindex;

            return RotatedBox(
              quarterTurns: 1,
              child: Transform.scale(
                scale: isSelected ? widget.scale : 1,
                child: Transform.translate(
                  offset: Offset(
                    0,
                    isSelected
                        ? 0
                        : widget.yOffset *
                        (realIndex - _selectedindex).abs().toDouble(),
                  ),
                  child: isSelected
                      ? widget.selectedWidget(realIndex)
                      : widget.unSelectedWidget(realIndex),
                ),
              ),
            );
          },
          childCount: _virtualItemCount,
        ),
      ),
    );
  }
}
