// Location: src/core/theme/app_typography.dart
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// =========================================================================
/// APP TYPOGRAPHY — two-face system for the POS.
///
/// The brand sells large-scale outdoor art (statuary, fountains, garden
/// stone) — a gallery/auction-house register, not a generic retail POS.
/// The person operating this screen is the cashier, not the customer, so
/// legibility and speed still come first in the actual UI chrome.
///
/// Two roles, two faces:
///   - `display` (Fraunces)   — brand moments only: screen headlines,
///                              wordmark, empty states. Warm editorial
///                              serif with an optical-size axis, so it
///                              stays intentional at both large and small
///                              sizes rather than just a shrunk display face.
///   - `ui` (Public Sans)     — everything the cashier actually operates:
///                              field labels, inputs, buttons, hints,
///                              errors, data tables. A plain, highly
///                              legible grotesque built for interface use
///                              (originated from USWDS, the U.S. design
///                              system — designed for operational clarity,
///                              not brand flair).
///
/// Loaded via `google_fonts`' default runtime fetch + cache (not bundled
/// as local assets) — simpler setup, and the fonts are cached to disk
/// after first launch so this is a one-time cost, not a per-session one.
/// First launch on a device with no connectivity will fall back to the
/// platform default font until it can fetch.
/// =========================================================================

abstract class AppTypography {
  /// Display/brand face — use sparingly, for headlines and brand moments.
  static TextStyle display({
    double fontSize = 26,
    FontWeight fontWeight = FontWeight.w600,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.fraunces(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
      fontStyle: FontStyle.normal,
    );
  }

  /// UI/functional face — everything the cashier reads or types.
  static TextStyle ui({
    double fontSize = 15,
    FontWeight fontWeight = FontWeight.w400,
    Color? color,
    double? letterSpacing,
    double? height,
  }) {
    return GoogleFonts.publicSans(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      letterSpacing: letterSpacing,
      height: height,
    );
  }

  /// Full `TextTheme` built on Public Sans, for wiring into `ThemeData` in
  /// `app_theme.dart` so every default-styled `Text` widget in the app
  /// gets the UI face without callers needing to reach for `.ui()`
  /// explicitly. Display-face headlines should still be set per-widget
  /// via `AppTypography.display(...)` since they're intentionally rare.
  static TextTheme uiTextTheme(TextTheme base) {
    return GoogleFonts.publicSansTextTheme(base);
  }
}
