// Location: src/features/dashboard/presentation/screens/dashboard_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../controllers/dashboard_controller.dart';
import '../widgets/dashboardWidgets/dashboard_constants.dart';
import '../widgets/dashboardWidgets/dashboard_layout.dart';

/// =========================================================================
/// DASHBOARD SCREEN — POS main screen. Split layout, no overlays for the
/// core cart/catalog flow. Built for a TOUCHSCREEN terminal, not a mouse-
/// driven desktop app — every tappable control on this screen is sized
/// and spaced for a fingertip, not a cursor. See TOUCH TARGETS below.
///
/// CATALOG SHEET (right-side overlay): tapping a category opens
/// `CatalogSheet` (see `widgets/dashboardWidgets/catalog_sheet.dart`) — a
/// panel that slides in from the right edge and covers exactly the area
/// the top bar + category rail's product grid used to occupy (the whole
/// right panel on wide layouts, the catalog portion of the stack on
/// narrow ones). It carries its own compact category strip up top (so
/// switching categories mid-browse doesn't require closing first —
/// tapping another category just swaps the sheet's contents, no close/
/// reopen transition) plus a search field that filters the grid within
/// whichever category is open. Dismiss by tapping the scrim, tapping the
/// cart panel, or dragging the sheet back toward the right edge past the
/// halfway point. Left side (cart) is completely unaffected by anything
/// on the right, which was the one hard constraint from the brief — the
/// sheet only ever overlays the right panel's own bounds, never the
/// cart's.
///
/// TOUCH TARGETS: every tappable element on this screen — buttons,
/// stepper +/-, remove icons, category tiles, product cards, top bar
/// actions, "Others" panel tiles — has a minimum 56x56 hit area, with
/// primary actions (Charge, category tiles, product cards, top bar
/// buttons) at 64px+. This is deliberately above the ~44-48px mouse/phone
/// convention: a fixed counter terminal gets tapped by an adult finger,
/// often quickly, sometimes at an angle. Spacing between adjacent
/// tappables is kept generous for the same reason — a slightly-off tap
/// should never land on the wrong control. If you're editing any file
/// under `widgets/dashboardWidgets/`, treat 56px (`minTapTarget`, see
/// `dashboard_constants.dart`) as a hard floor for anything with an
/// `onTap`/`onPressed`, not a suggestion.
///
/// TOP BAR: persistent operational row above the category rail —
/// Start/End shift (mutually exclusive toggle), Cash drop, Reprint,
/// Settings, and "Others" (opens a 13-item grid of secondary actions:
/// discounts, payment methods, void sale, etc — see
/// `widgets/dashboardWidgets/others_sheet.dart`). "Others" uses a bottom
/// sheet deliberately (unlike the category flow) since these are one-off,
/// low-frequency actions, not a rapid-repeat loop — the transition cost
/// that ruled out a sheet for categories doesn't apply here.
///
/// NO PRODUCT IMAGES: product cards are text/label-forward (name + price
/// only, no image placeholder) per direction — bigger, clearer labels
/// instead of image real estate that isn't populated yet anyway.
///
/// LAYOUT: left panel = cart (fixed width, always visible, own scroll).
/// Right panel = top bar + category rail (always visible) above a
/// product grid (scrolls independently, swaps per category, no overlay).
/// Below the wide breakpoint, stacks vertically — a real touchscreen POS
/// terminal is realistically always landscape/tablet-sized, so the
/// narrow layout is a fallback, not the primary target. See
/// `widgets/dashboardWidgets/dashboard_layout.dart` for both variants.
///
/// PLACEHOLDER DATA: category/product/other-action content comes from
/// `DashboardController`'s hardcoded catalog — see that file's doc
/// comment. Only the data source is fake; the layout/interaction is real.
///
/// FILE MAP: this screen file only owns the top-level Scaffold and the
/// wide/narrow breakpoint decision. Everything else lives under
/// `widgets/dashboardWidgets/`:
///   - dashboard_constants.dart  — shared tap-target sizes, sheet timing
///   - dashboard_layout.dart     — WideLayout / NarrowLayout, sheet stack
///   - cart_panel.dart           — left panel: header, lines, footer
///   - catalog_panel.dart        — right panel: category rail
///   - catalog_sheet.dart        — sliding product-browse overlay
///   - product_grid.dart         — product grid + card (lives in the sheet)
///   - top_bar.dart              — shift/cash drop/reprint/settings/others
///   - others_sheet.dart         — 13-item secondary actions bottom sheet
/// =========================================================================

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final isWide = MediaQuery.sizeOf(context).width >= splitLayoutBreakpoint;

    return Scaffold(
      backgroundColor: colors.background,
      body: SafeArea(child: isWide ? const WideLayout() : const NarrowLayout()),
    );
  }
}
