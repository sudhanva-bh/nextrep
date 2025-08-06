import 'package:flutter/material.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/scroll_tile.dart';

class Scroller extends StatelessWidget {
  const Scroller({
    super.key,
    required this.controller,
    required this.onItemChanged,
    required this.selectedIndex,
    required this.childCount,
    required this.width,
  });

  final FixedExtentScrollController controller;
  final ValueChanged<int> onItemChanged;
  final int selectedIndex;
  final int childCount;
  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 520,
      child: ListWheelScrollView.useDelegate(
        controller: controller,
        itemExtent: 50,
        perspective: 0.005,
        diameterRatio: 100,
        physics: const FixedExtentScrollPhysics(),
        onSelectedItemChanged: onItemChanged,
        childDelegate: ListWheelChildBuilderDelegate(
          childCount: childCount,
          builder: (context, index) {
            return ScrollTile(
              text: (index).toString(),
              isSelected: selectedIndex == index,
              onClicked: () => controller.animateToItem(
                index,
                duration: Duration(milliseconds: 400),
                curve: Curves.easeOut,
              ),
            );
          },
        ),
      ),
    );
  }
}
