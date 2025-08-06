import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';
import 'package:nextrep/features/metrics/presentation/widget_helpers/scroller.dart';

class CmHeightWidget extends StatefulWidget {
  const CmHeightWidget({
    super.key,
    this.initialValueCm = 171,
    this.initialValueCmDecimal = 0,
    required this.updateHeight,
  });

  final int initialValueCm;
  final int initialValueCmDecimal;

  final Function(double height) updateHeight;

  @override
  State<CmHeightWidget> createState() => _CmHeightWidgetState();
}

class _CmHeightWidgetState extends State<CmHeightWidget> {
  late final FixedExtentScrollController _controllerCm;
  late final FixedExtentScrollController _controllerCmDecimal;

  int selectedIndexCM = 0;
  int selectedIndexCMDecimal = 0;

  double calculateHeight(int cm, int mm) {
    return cm + (mm / 10);
  }

  @override
  void initState() {
    super.initState();

    _controllerCm = FixedExtentScrollController();
    _controllerCmDecimal = FixedExtentScrollController();

    selectedIndexCM = widget.initialValueCm;
    selectedIndexCMDecimal = widget.initialValueCmDecimal;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _controllerCm.jumpToItem(widget.initialValueCm);
      _controllerCmDecimal.jumpToItem(widget.initialValueCmDecimal);
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
              selectedIndex: selectedIndexCM,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexCM = index;
                });
                widget.updateHeight(
                  calculateHeight(
                    _controllerCm.selectedItem,
                    _controllerCmDecimal.selectedItem,
                  ),
                );
              },
              childCount: 360,
              width: 85,
              controller: _controllerCm,
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
              selectedIndex: selectedIndexCMDecimal,
              onItemChanged: (index) {
                setState(() {
                  selectedIndexCMDecimal = index;
                });
                widget.updateHeight(
                  calculateHeight(
                    _controllerCm.selectedItem,
                    _controllerCmDecimal.selectedItem,
                  ),
                );
              },
              childCount: 10,
              width: 38,
              controller: _controllerCmDecimal,
            ),
            SizedBox(width: 5),
            Text(
              "cm",
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
