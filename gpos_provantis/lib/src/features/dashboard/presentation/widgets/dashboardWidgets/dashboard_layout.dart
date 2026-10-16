import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'barcode_scan_bar.dart';
import 'cart_panel.dart';
import 'catalog_panel.dart';
import 'catalog_sheet.dart';
import 'phone_cart_bar.dart';

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

/// Portrait phone layout. The catalog gets the whole screen, and the cart
/// collapses into a bar docked at the bottom that opens the full cart as a
/// sheet. The product sheet slides over the catalog only, so the cart bar
/// stays visible while items are being added.
class PhoneLayout extends StatelessWidget {
  const PhoneLayout({super.key, this.hideCartBar = false});

  /// True while the on-screen keyboard is up (the barcode field), so the
  /// bar doesn't eat the little room that is left above the keyboard.
  final bool hideCartBar;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Expanded(child: _CatalogPanelWithSheet()),
        if (!hideCartBar) const PhoneCartBar(),
      ],
    );
  }
}

/// A solid line between the cart and everything on the catalog side
/// (top bar, actions, categories).
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
