import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/scroller.dart';

class KgsWeightWidget extends StatefulWidget {
  const KgsWeightWidget({
    super.key,
    this.initialValueKg = 171,
    this.initialValueKgDecimal = 0,
    required this.updateWeight,
  });

  final int initialValueKg;
  final int initialValueKgDecimal;

  final Function(double height) updateWeight;

  @override
  State<KgsWeightWidget> createState() => _KgsWeightWidgetState();
}

class _KgsWeightWidgetState extends State<KgsWeightWidget> {
  late final FixedExtentScrollController _controllerKgs;
  late final FixedExtentScrollController _controllerKgsDecimal;

  int selectedIndexKg = 0;
  int selectedIndexKgDecimal = 0;

  double calculateWeight(int kg, int kgDecimal) {
    return kg + (kgDecimal / 10);
  }

  @override
  void initState() {
    super.initState();

    _controllerKgs = FixedExtentScrollController();
    _controllerKgsDecimal = FixedExtentScrollController();

    selectedIndexKg = widget.initialValueKg;
    selectedIndexKgDecimal = widget.initialValueKgDecimal;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerKgs.jumpToItem(widget.initialValueKg);
      _controllerKgsDecimal.jumpToItem(widget.initialValueKgDecimal);
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
              selectedIndex: selectedIndexKg,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexKg = index;
                });
                widget.updateWeight(
                  calculateWeight(
                    _controllerKgs.selectedItem,
                    _controllerKgsDecimal.selectedItem,
                  ),
                );
              },
              childCount: 360,
              width: 85,
              controller: _controllerKgs,
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
              selectedIndex: selectedIndexKgDecimal,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexKgDecimal = index;
                });
                widget.updateWeight(
                  calculateWeight(
                    _controllerKgs.selectedItem,
                    _controllerKgsDecimal.selectedItem,
                  ),
                );
              },
              childCount: 10,
              width: 38,
              controller: _controllerKgsDecimal,
            ),
            SizedBox(width: 5),
            Text(
              "kg",
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
