import 'package:flutter/material.dart';

import 'cart_panel.dart';
import 'catalog_panel.dart';
import 'catalog_sheet.dart';

class WideLayout extends StatelessWidget {
  const WideLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(flex: 2, child: CartPanel()),

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
        Expanded(flex: 3, child: _CatalogPanelWithSheet()),
      ],
    );
  }
}

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
