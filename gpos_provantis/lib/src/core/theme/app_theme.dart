// Location: src/core/theme/app_theme.dart
import 'package:flutter/material.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// APP THEME — builds ThemeData objects with AppColors as ThemeExtension.
/// Use AppTheme.light and AppTheme.dark in MaterialApp configuration.

abstract class AppTheme {
  static ThemeData get light => _build(AppColors.light);
  static ThemeData get dark => _build(AppColors.dark);

  static ThemeData _build(AppColors colors) {
    final base = ColorScheme(
      brightness: colors.brightness,
      primary: colors.primary,
      onPrimary: colors.onPrimary,
      primaryContainer: colors.primaryContainer,
      onPrimaryContainer: colors.onPrimaryContainer,
      secondary: colors.primary,
      onSecondary: colors.onPrimary,
      error: colors.danger,
      onError: colors.onDanger,
      errorContainer: colors.dangerContainer,
      onErrorContainer: colors.onDangerContainer,
      surface: colors.surface,
      onSurface: colors.onSurface,
      surfaceContainerHighest: colors.surfaceVariant,
      onSurfaceVariant: colors.onSurfaceVariant,
      outline: colors.border,
      outlineVariant: colors.borderSubtle,
      shadow: colors.shadow,
      scrim: colors.overlay,
      inverseSurface: colors.isDark
          ? AppColors.light.surface
          : AppColors.dark.surface,
      onInverseSurface: colors.isDark
          ? AppColors.light.onSurface
          : AppColors.dark.onSurface,
      inversePrimary: colors.isDark
          ? AppColors.light.primary
          : AppColors.dark.primary,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: colors.brightness,
      colorScheme: base,
      scaffoldBackgroundColor: colors.background,
      canvasColor: colors.background,
      dividerColor: colors.divider,
      disabledColor: colors.textDisabled,
      cardColor: colors.surfaceRaised,
      appBarTheme: AppBarTheme(
        backgroundColor: colors.surface,
        foregroundColor: colors.textPrimary,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          disabledBackgroundColor: colors.disabledFill,
          disabledForegroundColor: colors.textDisabled,
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: colors.primary,
          side: BorderSide(color: colors.border),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(foregroundColor: colors.primary),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: colors.surfaceVariant,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.primary, width: 1.5),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide(color: colors.danger),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: colors.isDark
            ? colors.surfaceVariant
            : colors.textPrimary,
        contentTextStyle: TextStyle(
          color: colors.isDark ? colors.textPrimary : colors.surface,
        ),
        behavior: SnackBarBehavior.floating,
      ),
      dividerTheme: DividerThemeData(color: colors.divider, thickness: 1),
      iconTheme: IconThemeData(color: colors.textPrimary),
      textTheme: _textTheme(colors),
      extensions: [colors],
    );
  }

  static TextTheme _textTheme(AppColors colors) {
    // Default to Public Sans (UI face). Fraunces brand headlines use AppTypography.display().
    final base = AppTypography.uiTextTheme(
      ThemeData(brightness: colors.brightness).textTheme,
    );
    return base.copyWith(
      displayLarge: base.displayLarge?.copyWith(color: colors.textPrimary),
      displayMedium: base.displayMedium?.copyWith(color: colors.textPrimary),
      displaySmall: base.displaySmall?.copyWith(color: colors.textPrimary),
      headlineLarge: base.headlineLarge?.copyWith(color: colors.textPrimary),
      headlineMedium: base.headlineMedium?.copyWith(color: colors.textPrimary),
      headlineSmall: base.headlineSmall?.copyWith(color: colors.textPrimary),
      titleLarge: base.titleLarge?.copyWith(color: colors.textPrimary),
      titleMedium: base.titleMedium?.copyWith(color: colors.textPrimary),
      titleSmall: base.titleSmall?.copyWith(color: colors.textPrimary),
      bodyLarge: base.bodyLarge?.copyWith(color: colors.textPrimary),
      bodyMedium: base.bodyMedium?.copyWith(color: colors.textPrimary),
      bodySmall: base.bodySmall?.copyWith(color: colors.textSecondary),
      labelLarge: base.labelLarge?.copyWith(color: colors.textPrimary),
      labelMedium: base.labelMedium?.copyWith(color: colors.textSecondary),
      labelSmall: base.labelSmall?.copyWith(color: colors.textSecondary),
    );
  }
}
