// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/dashboard_layout.dart
import 'package:flutter/material.dart';

import 'cart_panel.dart';
import 'catalog_panel.dart';
import 'catalog_sheet.dart';

/// --- Wide: cart left, top bar + category rail + product grid right --------

class WideLayout extends StatelessWidget {
  const WideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 2, child: CartPanel()),
        // The sheet needs to know its own bounds to slide within exactly
        // the catalog panel's footprint (never over the cart) — Stack
        // inside this Expanded gives it that, rather than a Stack around
        // the whole Row which would let it slide over the cart too.
        Expanded(flex: 3, child: _CatalogPanelWithSheet()),
      ],
    );
  }
}

/// --- Narrow: stacked fallback for phone-sized screens ----------------------

class NarrowLayout extends StatelessWidget {
  const NarrowLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      children: [
        Expanded(flex: 2, child: CartPanel()),
        Expanded(flex: 3, child: _CatalogPanelWithSheet()),
      ],
    );
  }
}

/// Wraps the always-visible catalog panel (top bar + category rail) and
/// the sliding sheet in a single Stack, so the sheet is clipped to and
/// positioned within exactly this panel's bounds — on wide layouts
/// that's the whole right side; on narrow layouts it's the lower portion
/// of the stacked column. Either way, the cart panel never gets a sheet
/// slid over it.
class _CatalogPanelWithSheet extends StatelessWidget {
  const _CatalogPanelWithSheet();

  @override
  Widget build(BuildContext context) {
    return const Stack(
      fit: StackFit.expand,
      children: [CatalogPanel(), CatalogSheet()],
    );
  }
}
