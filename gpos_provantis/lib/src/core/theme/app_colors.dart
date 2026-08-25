// Location: src/core/theme/app_colors.dart
import 'package:flutter/material.dart';

/// =========================================================================
/// APP COLORS — single source of truth for the POS V2 palette.
///
/// Structure:
///   1. `AppPalette`   — raw, mode-agnostic hex tokens (the "paint swatches").
///                        Never use these directly in widgets.
///   2. `AppColors`    — semantic, mode-aware roles (the "usage"). This is
///                        what you actually call from UI code, e.g.
///                        `context.colors.primary` or `context.colors.danger`.
///   3. `AppColors.light` / `AppColors.dark` — the two concrete instances.
///
/// Brand source color: #009184 (teal), the only color the V1 app used
/// besides white. Every other token here is derived from it or chosen to
/// harmonize with it, so V2 stays visually a "sibling" of V1 while adding
/// full semantic + dark mode support.
/// =========================================================================

/// Raw color swatches. Purely mechanical — no meaning attached yet.
/// Naming follows a Material-style tonal scale: lower number = lighter.
abstract class AppPalette {
  // ---- Brand teal (derived from #009184) ---------------------------------
  static const teal50 = Color(0xFFF1F8F8);
  static const teal100 = Color(0xFFDEF2F1);
  static const teal200 = Color(0xFFB8EAE6);
  static const teal300 = Color(0xFF81E4DB);
  static const teal400 = Color(0xFF30E8D8);
  static const teal500 = Color(0xFF009184); // <- exact V1 brand color
  static const teal600 = Color(0xFF03776D);
  static const teal700 = Color(0xFF055C54);
  static const teal800 = Color(0xFF05423D);
  static const teal900 = Color(0xFF052E2A);
  static const teal950 = Color(0xFF041B19);

  // ---- Neutrals (slightly teal-tinted grays, not pure gray) --------------
  // A hint of the brand hue in the neutrals keeps light/dark surfaces from
  // feeling like a generic gray Material app bolted onto a teal logo.
  static const neutral0 = Color(0xFFFFFFFF); // <- exact V1 white
  static const neutral50 = Color(0xFFF7F9F9);
  static const neutral100 = Color(0xFFEDF1F1);
  static const neutral200 = Color(0xFFDCE3E2);
  static const neutral300 = Color(0xFFC2CCCB);
  static const neutral400 = Color(0xFF97A5A3);
  static const neutral500 = Color(0xFF708080);
  static const neutral600 = Color(0xFF546261);
  static const neutral700 = Color(0xFF404C4B);
  static const neutral750 = Color(0xFF333D3C); // lifted dark-mode background
  static const neutral800 = Color(0xFF2A3332);
  static const neutral850 = Color(0xFF232B2A); // lifted dark-mode surface
  static const neutral900 = Color(0xFF1C2322);
  static const neutral950 = Color(0xFF0F1414);
  static const neutral1000 = Color(
    0xFF0A0D0D,
  ); // unused by AppColors.dark now —
  // kept only in case something elsewhere in the app reaches for true
  // near-black directly; the semantic dark theme below no longer uses it.

  // ---- Semantic hues (status colors, tuned to sit well next to teal) -----
  static const green500 = Color(0xFF2E9E5B); // success
  static const green700 = Color(0xFF1F7A45);
  static const green200 = Color(0xFFB8E6C8);
  static const green950 = Color(0xFF0F2A1A);

  static const amber500 = Color(0xFFE0A020); // warning
  static const amber700 = Color(0xFFB07C10);
  static const amber200 = Color(0xFFF5DFA6);
  static const amber950 = Color(0xFF2E2408);

  static const red500 = Color(0xFFDC3E3E); // error / danger
  static const red700 = Color(0xFFB02A2A);
  static const red200 = Color(0xFFF3C2C2);
  static const red950 = Color(0xFF330E0E);

  static const blue500 = Color(0xFF3B82C4); // info
  static const blue700 = Color(0xFF2A63A0);
  static const blue200 = Color(0xFFC0DCF0);
  static const blue950 = Color(0xFF0D2033);

  // ---- POS-specific accents ----------------------------------------------
  // Common POS states that don't map cleanly to generic success/warn/error.
  static const violet500 = Color(0xFF7C5CC4); // e.g. "on hold" / "parked sale"
  static const violet700 = Color(0xFF5E439C);
  static const violet200 = Color(0xFFDBD0F0);

  static const orange500 = Color(0xFFE0762A); // e.g. "refund" / "void"
  static const orange700 = Color(0xFFB35A1B);
  static const orange200 = Color(0xFFF5D3B8);
}

/// Semantic, theme-aware color roles.
///
/// Instantiate via [AppColors.light] / [AppColors.dark] — don't construct
/// this directly elsewhere. Access from widgets via the `context.colors`
/// extension defined in `app_colors_extension.dart`.
@immutable
class AppColors extends ThemeExtension<AppColors> {
  const AppColors({
    required this.brightness,
    // Brand
    required this.primary,
    required this.onPrimary,
    required this.primaryContainer,
    required this.onPrimaryContainer,
    // Surfaces
    required this.background,
    required this.onBackground,
    required this.surface,
    required this.onSurface,
    required this.surfaceVariant,
    required this.onSurfaceVariant,
    required this.surfaceRaised, // cards, sheets, dialogs sitting above surface
    required this.border,
    required this.borderSubtle,
    // Text
    required this.textPrimary,
    required this.textSecondary,
    required this.textDisabled,
    required this.onColor, // text/icon color to use ON a colored fill (e.g. onPrimary alias)
    // Status
    required this.success,
    required this.onSuccess,
    required this.successContainer,
    required this.onSuccessContainer,
    required this.warning,
    required this.onWarning,
    required this.warningContainer,
    required this.onWarningContainer,
    required this.danger,
    required this.onDanger,
    required this.dangerContainer,
    required this.onDangerContainer,
    required this.info,
    required this.onInfo,
    required this.infoContainer,
    required this.onInfoContainer,
    // POS-specific
    required this.held, // parked / on-hold sale
    required this.onHeld,
    required this.refund, // refund / void action
    required this.onRefund,
    // Utility
    required this.shadow,
    required this.overlay, // scrim behind modals/sheets
    required this.divider,
    required this.disabledFill,
  });

  final Brightness brightness;

  // Brand
  final Color primary;
  final Color onPrimary;
  final Color primaryContainer;
  final Color onPrimaryContainer;

  // Surfaces
  final Color background;
  final Color onBackground;
  final Color surface;
  final Color onSurface;
  final Color surfaceVariant;
  final Color onSurfaceVariant;
  final Color surfaceRaised;
  final Color border;
  final Color borderSubtle;

  // Text
  final Color textPrimary;
  final Color textSecondary;
  final Color textDisabled;
  final Color onColor;

  // Status: success
  final Color success;
  final Color onSuccess;
  final Color successContainer;
  final Color onSuccessContainer;

  // Status: warning
  final Color warning;
  final Color onWarning;
  final Color warningContainer;
  final Color onWarningContainer;

  // Status: danger
  final Color danger;
  final Color onDanger;
  final Color dangerContainer;
  final Color onDangerContainer;

  // Status: info
  final Color info;
  final Color onInfo;
  final Color infoContainer;
  final Color onInfoContainer;

  // POS-specific
  final Color held;
  final Color onHeld;
  final Color refund;
  final Color onRefund;

  // Utility
  final Color shadow;
  final Color overlay;
  final Color divider;
  final Color disabledFill;

  bool get isDark => brightness == Brightness.dark;

  // ---------------------------------------------------------------------
  // LIGHT
  // ---------------------------------------------------------------------
  static const light = AppColors(
    brightness: Brightness.light,

    primary: AppPalette.teal500,
    onPrimary: AppPalette.neutral0,
    primaryContainer: AppPalette.teal100,
    onPrimaryContainer: AppPalette.teal800,

    background: AppPalette.neutral50,
    onBackground: AppPalette.neutral900,
    surface: AppPalette.neutral0,
    onSurface: AppPalette.neutral900,
    surfaceVariant: AppPalette.neutral100,
    onSurfaceVariant: AppPalette.neutral700,
    surfaceRaised: AppPalette.neutral0,
    border: AppPalette.neutral200,
    borderSubtle: AppPalette.neutral100,

    textPrimary: AppPalette.neutral900,
    textSecondary: AppPalette.neutral600,
    textDisabled: AppPalette.neutral400,
    onColor: AppPalette.neutral0,

    success: AppPalette.green500,
    onSuccess: AppPalette.neutral0,
    successContainer: AppPalette.green200,
    onSuccessContainer: AppPalette.green700,

    warning: AppPalette.amber500,
    onWarning: AppPalette.neutral900,
    warningContainer: AppPalette.amber200,
    onWarningContainer: AppPalette.amber700,

    danger: AppPalette.red500,
    onDanger: AppPalette.neutral0,
    dangerContainer: AppPalette.red200,
    onDangerContainer: AppPalette.red700,

    info: AppPalette.blue500,
    onInfo: AppPalette.neutral0,
    infoContainer: AppPalette.blue200,
    onInfoContainer: AppPalette.blue700,

    held: AppPalette.violet500,
    onHeld: AppPalette.neutral0,
    refund: AppPalette.orange500,
    onRefund: AppPalette.neutral0,

    shadow: Color(0x1F000000), // 12% black
    overlay: Color(0x66000000), // 40% black
    divider: AppPalette.neutral200,
    disabledFill: AppPalette.neutral100,
  );

  // ---------------------------------------------------------------------
  // DARK
  // ---------------------------------------------------------------------
  // Base is a LIFTED teal-tinted charcoal (neutral750), not a near-black
  // (previously neutral1000, ~5% luminance). Near-black backgrounds next
  // to near-white text create the exact AMOLED-style contrast spike
  // that's hard on the eyes over a long POS shift — pure black also
  // causes halation/smearing on OLED under bright retail lighting and
  // makes the teal brand color look washed out next to it. Lifting the
  // background AND softening textPrimary (neutral100 -> neutral200) pulls
  // both ends of the scale in toward each other instead of camping at
  // opposite extremes — same legible-in-the-dark result, gentler get-there.
  // Containers get darker, desaturated status hues rather than just
  // dimming the light-mode ones, per Material 3 guidance.
  static const dark = AppColors(
    brightness: Brightness.dark,

    primary: AppPalette.teal300, // lighter tint reads better on dark surfaces
    onPrimary: AppPalette.teal950,
    primaryContainer: AppPalette.teal700,
    onPrimaryContainer: AppPalette.teal100,

    background: AppPalette.neutral750,
    onBackground: AppPalette.neutral200,
    surface: AppPalette.neutral800,
    onSurface: AppPalette.neutral200,
    surfaceVariant: AppPalette.neutral850,
    onSurfaceVariant: AppPalette.neutral300,
    surfaceRaised: AppPalette.neutral850,
    border: AppPalette.neutral700,
    borderSubtle: AppPalette.neutral800,

    textPrimary: AppPalette.neutral200,
    textSecondary: AppPalette.neutral400,
    textDisabled: AppPalette.neutral600,
    onColor: AppPalette.neutral950,

    success: AppPalette.green500,
    onSuccess: AppPalette.green950,
    successContainer: AppPalette.green700,
    onSuccessContainer: AppPalette.green200,

    warning: AppPalette.amber500,
    onWarning: AppPalette.amber950,
    warningContainer: AppPalette.amber700,
    onWarningContainer: AppPalette.amber200,

    danger: AppPalette.red500,
    onDanger: AppPalette.red950,
    dangerContainer: AppPalette.red700,
    onDangerContainer: AppPalette.red200,

    info: AppPalette.blue500,
    onInfo: AppPalette.blue950,
    infoContainer: AppPalette.blue700,
    onInfoContainer: AppPalette.blue200,

    held: AppPalette.violet500,
    onHeld: AppPalette.neutral0,
    refund: AppPalette.orange500,
    onRefund: AppPalette.neutral950,

    // Shadow/overlay kept as near-black washes rather than lifted —
    // these are transparency-based (not a fill), so they still need to
    // read as "recede/dim" against the new lighter surfaces, and a
    // lifted shadow color would just look gray and washed out instead
    // of receding.
    shadow: Color(0x66000000), // 40% black — needs to read on dark surfaces
    overlay: Color(0x99000000), // 60% black
    divider: AppPalette.neutral700,
    disabledFill: AppPalette.neutral850,
  );

  @override
  AppColors copyWith({
    Brightness? brightness,
    Color? primary,
    Color? onPrimary,
    Color? primaryContainer,
    Color? onPrimaryContainer,
    Color? background,
    Color? onBackground,
    Color? surface,
    Color? onSurface,
    Color? surfaceVariant,
    Color? onSurfaceVariant,
    Color? surfaceRaised,
    Color? border,
    Color? borderSubtle,
    Color? textPrimary,
    Color? textSecondary,
    Color? textDisabled,
    Color? onColor,
    Color? success,
    Color? onSuccess,
    Color? successContainer,
    Color? onSuccessContainer,
    Color? warning,
    Color? onWarning,
    Color? warningContainer,
    Color? onWarningContainer,
    Color? danger,
    Color? onDanger,
    Color? dangerContainer,
    Color? onDangerContainer,
    Color? info,
    Color? onInfo,
    Color? infoContainer,
    Color? onInfoContainer,
    Color? held,
    Color? onHeld,
    Color? refund,
    Color? onRefund,
    Color? shadow,
    Color? overlay,
    Color? divider,
    Color? disabledFill,
  }) {
    return AppColors(
      brightness: brightness ?? this.brightness,
      primary: primary ?? this.primary,
      onPrimary: onPrimary ?? this.onPrimary,
      primaryContainer: primaryContainer ?? this.primaryContainer,
      onPrimaryContainer: onPrimaryContainer ?? this.onPrimaryContainer,
      background: background ?? this.background,
      onBackground: onBackground ?? this.onBackground,
      surface: surface ?? this.surface,
      onSurface: onSurface ?? this.onSurface,
      surfaceVariant: surfaceVariant ?? this.surfaceVariant,
      onSurfaceVariant: onSurfaceVariant ?? this.onSurfaceVariant,
      surfaceRaised: surfaceRaised ?? this.surfaceRaised,
      border: border ?? this.border,
      borderSubtle: borderSubtle ?? this.borderSubtle,
      textPrimary: textPrimary ?? this.textPrimary,
      textSecondary: textSecondary ?? this.textSecondary,
      textDisabled: textDisabled ?? this.textDisabled,
      onColor: onColor ?? this.onColor,
      success: success ?? this.success,
      onSuccess: onSuccess ?? this.onSuccess,
      successContainer: successContainer ?? this.successContainer,
      onSuccessContainer: onSuccessContainer ?? this.onSuccessContainer,
      warning: warning ?? this.warning,
      onWarning: onWarning ?? this.onWarning,
      warningContainer: warningContainer ?? this.warningContainer,
      onWarningContainer: onWarningContainer ?? this.onWarningContainer,
      danger: danger ?? this.danger,
      onDanger: onDanger ?? this.onDanger,
      dangerContainer: dangerContainer ?? this.dangerContainer,
      onDangerContainer: onDangerContainer ?? this.onDangerContainer,
      info: info ?? this.info,
      onInfo: onInfo ?? this.onInfo,
      infoContainer: infoContainer ?? this.infoContainer,
      onInfoContainer: onInfoContainer ?? this.onInfoContainer,
      held: held ?? this.held,
      onHeld: onHeld ?? this.onHeld,
      refund: refund ?? this.refund,
      onRefund: onRefund ?? this.onRefund,
      shadow: shadow ?? this.shadow,
      overlay: overlay ?? this.overlay,
      divider: divider ?? this.divider,
      disabledFill: disabledFill ?? this.disabledFill,
    );
  }

  @override
  AppColors lerp(ThemeExtension<AppColors>? other, double t) {
    if (other is! AppColors) return this;
    return AppColors(
      brightness: t < 0.5 ? brightness : other.brightness,
      primary: Color.lerp(primary, other.primary, t)!,
      onPrimary: Color.lerp(onPrimary, other.onPrimary, t)!,
      primaryContainer: Color.lerp(
        primaryContainer,
        other.primaryContainer,
        t,
      )!,
      onPrimaryContainer: Color.lerp(
        onPrimaryContainer,
        other.onPrimaryContainer,
        t,
      )!,
      background: Color.lerp(background, other.background, t)!,
      onBackground: Color.lerp(onBackground, other.onBackground, t)!,
      surface: Color.lerp(surface, other.surface, t)!,
      onSurface: Color.lerp(onSurface, other.onSurface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      onSurfaceVariant: Color.lerp(
        onSurfaceVariant,
        other.onSurfaceVariant,
        t,
      )!,
      surfaceRaised: Color.lerp(surfaceRaised, other.surfaceRaised, t)!,
      border: Color.lerp(border, other.border, t)!,
      borderSubtle: Color.lerp(borderSubtle, other.borderSubtle, t)!,
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t)!,
      textSecondary: Color.lerp(textSecondary, other.textSecondary, t)!,
      textDisabled: Color.lerp(textDisabled, other.textDisabled, t)!,
      onColor: Color.lerp(onColor, other.onColor, t)!,
      success: Color.lerp(success, other.success, t)!,
      onSuccess: Color.lerp(onSuccess, other.onSuccess, t)!,
      successContainer: Color.lerp(
        successContainer,
        other.successContainer,
        t,
      )!,
      onSuccessContainer: Color.lerp(
        onSuccessContainer,
        other.onSuccessContainer,
        t,
      )!,
      warning: Color.lerp(warning, other.warning, t)!,
      onWarning: Color.lerp(onWarning, other.onWarning, t)!,
      warningContainer: Color.lerp(
        warningContainer,
        other.warningContainer,
        t,
      )!,
      onWarningContainer: Color.lerp(
        onWarningContainer,
        other.onWarningContainer,
        t,
      )!,
      danger: Color.lerp(danger, other.danger, t)!,
      onDanger: Color.lerp(onDanger, other.onDanger, t)!,
      dangerContainer: Color.lerp(dangerContainer, other.dangerContainer, t)!,
      onDangerContainer: Color.lerp(
        onDangerContainer,
        other.onDangerContainer,
        t,
      )!,
      info: Color.lerp(info, other.info, t)!,
      onInfo: Color.lerp(onInfo, other.onInfo, t)!,
      infoContainer: Color.lerp(infoContainer, other.infoContainer, t)!,
      onInfoContainer: Color.lerp(onInfoContainer, other.onInfoContainer, t)!,
      held: Color.lerp(held, other.held, t)!,
      onHeld: Color.lerp(onHeld, other.onHeld, t)!,
      refund: Color.lerp(refund, other.refund, t)!,
      onRefund: Color.lerp(onRefund, other.onRefund, t)!,
      shadow: Color.lerp(shadow, other.shadow, t)!,
      overlay: Color.lerp(overlay, other.overlay, t)!,
      divider: Color.lerp(divider, other.divider, t)!,
      disabledFill: Color.lerp(disabledFill, other.disabledFill, t)!,
    );
  }
}
