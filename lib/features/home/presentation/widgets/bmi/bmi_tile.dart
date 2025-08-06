import 'package:flutter/material.dart';
import 'package:nextrep/core/theme/app_palette.dart';

class BmiTile extends StatefulWidget {
  const BmiTile({
    required this.parameterName,
    required this.parameter,
    required this.icon,
    super.key,
  });

  final IconData icon;
  final String parameterName;
  final double? parameter;

  @override
  State<BmiTile> createState() => _BmiTileState();
}

class _BmiTileState extends State<BmiTile> {

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent, // ensures ripple is visible
      child: Padding(
        padding: const EdgeInsets.all(1),
        child: Row(
          children: [
            Icon(widget.icon),
            const SizedBox(width: 5),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.parameterName,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      (widget.parameter?.toStringAsFixed(1)) ?? "Not set",
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: AppPalette.onSurface.withAlpha(191),
                      ),
                    ),
                    const SizedBox(width: 3),
                    Icon(
                      Icons.edit,
                      size: 10,
                      color: AppPalette.onSurface.withAlpha(191),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
