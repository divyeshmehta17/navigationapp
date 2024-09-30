import 'package:flutter/material.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class SlidingUpPanelWidget extends StatelessWidget {
  final PanelController panelController;
  final double minHeight;
  final double maxHeight;
  final Widget Function(BuildContext) panelContentBuilder;

  const SlidingUpPanelWidget({
    super.key,
    required this.panelController,
    required this.minHeight,
    required this.maxHeight,
    required this.panelContentBuilder,
  });

  @override
  Widget build(BuildContext context) {
    return SlidingUpPanel(
      borderRadius: const BorderRadius.only(
        topLeft: Radius.circular(16.0),
        topRight: Radius.circular(16.0),
      ),
      minHeight: minHeight,
      maxHeight: maxHeight,
      controller: panelController,
      panelBuilder: (scrollController) => panelContentBuilder(context),
    );
  }
}
