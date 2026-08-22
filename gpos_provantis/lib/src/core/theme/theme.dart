/// =========================================================================
/// THEME BARREL — import this single file to get the whole theme system.
///
/// Usage anywhere in the app:
///
///   import 'package:pos_v2/src/core/theme/theme.dart';
///
/// That single import gives you:
///   - `AppPalette`               (raw swatches — rarely needed directly)
///   - `AppColors` + `.light`/`.dark` (semantic color roles)
///   - `context.colors`, `context.isDarkMode` (BuildContext extension)
///   - `AppTheme.light` / `AppTheme.dark`      (ready-made ThemeData)
///   - `AppTypography.display` / `.ui`         (Fraunces + Public Sans)
///   - `themeModeControllerProvider`           (Riverpod theme mode state)
///
/// NOTE: `example_usage.dart` is intentionally NOT exported here — it's
/// reference/sample code, not part of the theme system's public API.
/// =========================================================================

export 'app_colors.dart';
export 'app_colors_extension.dart';
export 'app_theme.dart';
export 'app_typography.dart';
export 'theme_mode_provider.dart';
