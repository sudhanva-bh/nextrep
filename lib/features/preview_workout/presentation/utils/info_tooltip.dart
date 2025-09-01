import 'package:flutter/material.dart';

class InfoTooltip extends StatelessWidget {
  const InfoTooltip({super.key, required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final tooltipKey = GlobalKey<TooltipState>();

    return Tooltip(
      key: tooltipKey,
      message: message,
      triggerMode: TooltipTriggerMode.manual, // manual control
      child: GestureDetector(
        onTap: () {
          final dynamic tooltip = tooltipKey.currentState;
          tooltip?.ensureTooltipVisible(); // show on tap
        },
        child: const Icon(Icons.info_outline, size: 20, color: Colors.grey),
      ),
    );
  }
}
