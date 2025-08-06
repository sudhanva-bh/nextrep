import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/scroller.dart';

class InchesHeightWidget extends StatefulWidget {
  const InchesHeightWidget({
    super.key,
    this.initialValueFeet = 5,
    this.initialValueInches = 7,
    required this.updateHeight,
  });
  final int initialValueFeet;
  final int initialValueInches;

  final Function(double height) updateHeight;

  @override
  State<InchesHeightWidget> createState() => _InchesHeightWidgetState();
}

class _InchesHeightWidgetState extends State<InchesHeightWidget> {
  late final FixedExtentScrollController _controllerFeet;

  late final FixedExtentScrollController _controllerInches;

  late int selectedIndexFeet;
  late int selectedIndexInches;

  double calculateHeight(int feet, int inches) {
    return (((feet * 12) + inches) * 2.54);
  }

  @override
  void initState() {
    super.initState();

    _controllerFeet = FixedExtentScrollController();
    _controllerInches = FixedExtentScrollController();

    selectedIndexFeet = widget.initialValueFeet;
    selectedIndexInches = widget.initialValueInches;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerFeet.jumpToItem(widget.initialValueFeet);
      _controllerInches.jumpToItem(widget.initialValueInches);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        Align(
          alignment: Alignment.center,
          child: Container(
            width: 240,
            height: 60,
            decoration: BoxDecoration(
              color: AppPalette.lightSurface,
              borderRadius: BorderRadius.circular(100),
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Scroller(
              selectedIndex: selectedIndexFeet,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexFeet = index;
                });
                widget.updateHeight(
                  calculateHeight(
                    _controllerFeet.selectedItem,
                    _controllerInches.selectedItem,
                  ),
                );
              },
              childCount: 9,
              width: 38,
              controller: _controllerFeet,
            ),
            SizedBox(width: 5),
            Text(
              "ft",
              style: TextStyle(
                fontSize: 40,
                color: AppPalette.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 5),
            Scroller(
              selectedIndex: selectedIndexInches,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexInches = index;
                });
                widget.updateHeight(
                  calculateHeight(
                    _controllerFeet.selectedItem,
                    _controllerInches.selectedItem,
                  ),
                );
              },
              childCount: 12,
              width: 70,
              controller: _controllerInches,
            ),
            SizedBox(width: 5),
            Text(
              "in",
              style: TextStyle(
                fontSize: 40,
                color: AppPalette.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }
}
