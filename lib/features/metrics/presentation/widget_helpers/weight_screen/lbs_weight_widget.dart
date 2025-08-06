import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/scroller.dart';

class LbsWeightWidget extends StatefulWidget {
  const LbsWeightWidget({
    super.key,
    this.initialValueLb = 171,
    this.initialValueLbDecimal = 0,
    required this.updateWeight,
  });

  final int initialValueLb;
  final int initialValueLbDecimal;

  final Function(double height) updateWeight;

  @override
  State<LbsWeightWidget> createState() => _LbsWeightWidgetState();
}

class _LbsWeightWidgetState extends State<LbsWeightWidget> {
  late final FixedExtentScrollController _controllerLbs;
  late final FixedExtentScrollController _controllerLbsDecimal;

  int selectedIndexLb = 0;
  int selectedIndexLbDecimal = 0;

  double calculateWeight(int lb, int lbDecimal) {
    return (lb + (lbDecimal / 10)) * 0.453592;
  }

  @override
  void initState() {
    super.initState();

    _controllerLbs = FixedExtentScrollController();
    _controllerLbsDecimal = FixedExtentScrollController();

    selectedIndexLb = widget.initialValueLb;
    selectedIndexLbDecimal = widget.initialValueLbDecimal;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerLbs.jumpToItem(widget.initialValueLb);
      _controllerLbsDecimal.jumpToItem(widget.initialValueLbDecimal);
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
              selectedIndex: selectedIndexLb,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexLb = index;
                });
                widget.updateWeight(
                  calculateWeight(
                    _controllerLbs.selectedItem,
                    _controllerLbsDecimal.selectedItem,
                  ),
                );
              },
              childCount: 360,
              width: 85,
              controller: _controllerLbs,
            ),
            Text(
              ".",
              style: TextStyle(
                fontSize: 44,
                color: AppPalette.onBackground,
                fontWeight: FontWeight.bold,
              ),
            ),
            Scroller(
              selectedIndex: selectedIndexLbDecimal,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexLbDecimal = index;
                });
                widget.updateWeight(
                  calculateWeight(
                    _controllerLbs.selectedItem,
                    _controllerLbsDecimal.selectedItem,
                  ),
                );
              },
              childCount: 10,
              width: 38,
              controller: _controllerLbsDecimal,
            ),
            SizedBox(width: 5),
            Text(
              "lb",
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
