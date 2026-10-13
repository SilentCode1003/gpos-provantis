import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'barcode_scan_bar.dart';
import 'cart_panel.dart';
import 'catalog_panel.dart';
import 'catalog_sheet.dart';

/// Thickness of the line separating the cart from the catalog side.
const double _panelDividerThickness = 2;

class WideLayout extends StatelessWidget {
  const WideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 2, child: CartPanel()),

        _PanelDivider(axis: Axis.vertical),

        Expanded(flex: 3, child: _CatalogPanelWithSheet()),
      ],
    );
  }
}

class NarrowLayout extends StatelessWidget {
  const NarrowLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 2, child: CartPanel()),

        _PanelDivider(axis: Axis.horizontal),

        Expanded(flex: 3, child: _CatalogPanelWithSheet()),
      ],
    );
  }
}

/// A solid line between the cart and everything on the catalog side
/// (top bar, actions, categories). [axis] is the direction the line runs:
/// vertical for the side-by-side layout, horizontal for the stacked one.
class _PanelDivider extends StatelessWidget {
  const _PanelDivider({required this.axis});

  final Axis axis;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final isVertical = axis == Axis.vertical;

    return Container(
      width: isVertical ? _panelDividerThickness : null,
      height: isVertical ? null : _panelDividerThickness,
      color: colors.border,
    );
  }
}

class _CatalogPanelWithSheet extends StatelessWidget {
  const _CatalogPanelWithSheet();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [
        CatalogPanel(),
        Positioned(left: 16, right: 16, bottom: 16, child: BarcodeScanBar()),
        CatalogSheet(),
      ],
    );
  }
}
