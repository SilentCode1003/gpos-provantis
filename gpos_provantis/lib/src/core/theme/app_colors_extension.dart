// Location: src/core/theme/app_colors_extension.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';

/// =========================================================================
/// CONTEXT EXTENSION — the "context.dark or something similar" piece.
///
/// This resolves the *actual current* brightness (accounting for the user's
/// theme mode already having been applied by MaterialApp) and hands back
/// the right `AppColors` instance. Call from anywhere you have a
/// `BuildContext`:
///
///   Container(color: context.colors.surface)
///   Text('Total', style: TextStyle(color: context.colors.textPrimary))
///   Icon(Icons.check, color: context.colors.success)
///
/// No need to watch a provider for this — Flutter's Theme is already
/// rebuilt automatically when `MaterialApp.themeMode` changes (see
/// `theme_mode_provider.dart`), and `context.colors` just reads whichever
/// theme is currently active.
/// =========================================================================

extension AppColorsContext on BuildContext {
  /// The semantic color set for whichever brightness is currently active.
  ///
  /// Falls back to `AppColors.light` if the extension somehow isn't
  /// registered on the theme (shouldn't happen if you wire up
  /// `app_theme.dart` correctly) so this never throws in production.
  AppColors get colors =>
      Theme.of(this).extension<AppColors>() ?? AppColors.light;

  /// True if the app is *currently rendering* in dark mode — already
  /// resolved from ThemeMode.system if that's what the user picked.
  /// This is the one to use for one-off conditional logic in widgets,
  /// e.g. `context.isDarkMode ? Brightness.light : Brightness.dark` for
  /// a status bar icon color.
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
