/// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/dashboard_constants.dart
///
/// Shared layout/animation constants used across the dashboard widget
/// files. Pulled out of `dashboard_screen.dart` so every split-out widget
/// (cart, catalog panel, catalog sheet, top bar, others sheet, product
/// grid) can reference the same values instead of each file redefining
/// its own copy.

/// Breakpoint above which the dashboard uses the wide (cart | catalog)
/// split layout instead of the narrow stacked fallback.
const double splitLayoutBreakpoint = 720;

/// Hard floor for any tappable control's hit area — see TOUCH TARGETS in
/// `dashboard_screen.dart`'s doc comment. Use this (or
/// [primaryTapTarget]) instead of guessing a size.
const double minTapTarget = 56;

/// Floor for primary/high-frequency actions — category tiles, product
/// cards, top bar buttons, Charge.
const double primaryTapTarget = 64;

/// Shared by the catalog sheet and the cart panel's darkening scrim so
/// both sides of the screen animate on identical timing when the catalog
/// sheet opens — see `_CatalogSheetState` and `CartPanel`.
const Duration catalogSheetOpenDuration = Duration(milliseconds: 320);

/// Close-side counterpart to [catalogSheetOpenDuration] — a sheet should
/// leave briskly, not ease out on the same timing it arrived with.
const Duration catalogSheetCloseDuration = Duration(milliseconds: 220);
