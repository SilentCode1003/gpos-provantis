// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/pos_form_sheet.dart
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';

/// --- Shared scaffold for touchscreen form sheets ---------------------------
///
/// Every "type something in, then confirm" bottom sheet (re-print, refund,
/// send e-receipt) is built on this so keyboard handling and touch sizing
/// live in exactly one place.
///
/// Keyboard behavior: the sheet must be opened via [showPosFormSheet] (which
/// sets `isScrollControlled: true`). Inside, [AnimatedPadding] tracks
/// `MediaQuery.viewInsets.bottom` so the whole sheet rides above the
/// keyboard, and the body is scrollable so a short landscape screen can
/// still reach every field instead of overflowing.

/// Opens [child] as a keyboard-aware modal bottom sheet.
///
/// `useSafeArea` keeps the sheet clear of the status bar / notches when the
/// keyboard pushes it to full height on small screens.
Future<T?> showPosFormSheet<T>(BuildContext context, {required Widget child}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    backgroundColor: Colors.transparent,
    builder: (_) => child,
  );
}

class PosFormSheet extends StatelessWidget {
  const PosFormSheet({
    super.key,
    required this.title,
    required this.children,
    this.subtitle,
    this.icon,
    this.accent,
    this.onAccent,
    required this.submitLabel,
    required this.onSubmit,
    this.submitEnabled = true,
  });

  final String title;
  final String? subtitle;
  final IconData? icon;

  /// Optional tint for the header icon chip and submit button. Falls back to
  /// `colors.primary`. Used by the refund sheet to pick up `colors.refund`.
  final Color? accent;
  final Color? onAccent;

  final List<Widget> children;
  final String submitLabel;
  final VoidCallback onSubmit;
  final bool submitEnabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accentColor = accent ?? colors.primary;
    final onAccentColor = onAccent ?? colors.onPrimary;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        // Full-width fields on a landscape tablet are absurdly wide and hard
        // to scan. Cap and center.
        constraints: const BoxConstraints(maxWidth: 560),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: Container(
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(24, 12, 24, 28),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Drag handle — same dimensions as OthersSheet.
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: colors.border,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                  ),

                  // Header: icon chip + title (+ optional subtitle).
                  Row(
                    children: [
                      if (icon != null) ...[
                        Container(
                          width: 48,
                          height: 48,
                          decoration: BoxDecoration(
                            color: accentColor.withValues(alpha: 0.14),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Icon(icon, size: 26, color: accentColor),
                        ),
                        const SizedBox(width: 14),
                      ],
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTypography.display(
                                color: colors.textPrimary,
                                fontSize: 22,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            if (subtitle != null) ...[
                              const SizedBox(height: 2),
                              Text(
                                subtitle!,
                                style: AppTypography.ui(
                                  color: colors.textSecondary,
                                  fontSize: 14,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      // Explicit close target — a 4px drag handle is not a
                      // reliable dismiss affordance on a POS touchscreen.
                      SizedBox(
                        width: 48,
                        height: 48,
                        child: IconButton(
                          onPressed: () => Navigator.of(context).pop(),
                          icon: Icon(
                            Icons.close_rounded,
                            size: 26,
                            color: colors.textSecondary,
                          ),
                          tooltip: 'Close',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  ...children,

                  const SizedBox(height: 8),
                  PosSheetButton(
                    label: submitLabel,
                    onPressed: submitEnabled ? onSubmit : null,
                    background: accentColor,
                    foreground: onAccentColor,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// --- Labeled, oversized text field -----------------------------------------
///
/// Label sits *above* the field (not as a floating Material label) so it
/// never shifts/shrinks while the cashier is typing, and stays readable at
/// arm's length. 64px tall, 18px input text, thick focus ring.
class PosTextField extends StatelessWidget {
  const PosTextField({
    super.key,
    required this.label,
    required this.controller,
    this.hint,
    this.icon,
    this.focusNode,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.textCapitalization = TextCapitalization.none,
    this.autofocus = false,
    this.maxLines = 1,
    this.minLines,
    this.errorText,
    this.onSubmitted,
    this.onChanged,
    this.autofillHints,
  });

  final String label;
  final TextEditingController controller;
  final String? hint;
  final IconData? icon;
  final FocusNode? focusNode;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final TextCapitalization textCapitalization;
  final bool autofocus;
  final int maxLines;
  final int? minLines;
  final String? errorText;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final multiline = maxLines > 1;

    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(14),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label,
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
              letterSpacing: 0.2,
            ),
          ),
        ),
        TextField(
          controller: controller,
          focusNode: focusNode,
          autofocus: autofocus,
          keyboardType: keyboardType,
          textInputAction: textInputAction,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          minLines: minLines,
          autofillHints: autofillHints,
          onSubmitted: onSubmitted,
          onChanged: onChanged,
          cursorColor: colors.primary,
          cursorWidth: 2.5,
          style: AppTypography.ui(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w500,
          ),
          // Keep the field visible above the keyboard even when it's
          // multiline and grows; padding here is extra scroll headroom.
          scrollPadding: const EdgeInsets.only(bottom: 120),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: AppTypography.ui(
              color: colors.textDisabled,
              fontSize: 18,
            ),
            errorText: errorText,
            errorStyle: AppTypography.ui(
              color: colors.danger,
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
            filled: true,
            fillColor: colors.surfaceVariant,
            prefixIcon: icon == null
                ? null
                : Icon(icon, size: 24, color: colors.textSecondary),
            // 64px total height for single-line fields; multiline gets
            // natural height with the same vertical padding.
            contentPadding: EdgeInsets.symmetric(
              horizontal: 18,
              vertical: multiline ? 18 : 21,
            ),
            border: border(colors.border),
            enabledBorder: border(colors.border),
            focusedBorder: border(colors.primary, width: 2),
            errorBorder: border(colors.danger),
            focusedErrorBorder: border(colors.danger, width: 2),
          ),
        ),
      ],
    );
  }
}

/// --- Full-width 60px action button -----------------------------------------
class PosSheetButton extends StatelessWidget {
  const PosSheetButton({
    super.key,
    required this.label,
    required this.onPressed,
    required this.background,
    required this.foreground,
  });

  final String label;
  final VoidCallback? onPressed;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return SizedBox(
      height: 60,
      child: FilledButton(
        onPressed: onPressed,
        style: FilledButton.styleFrom(
          backgroundColor: background,
          foregroundColor: foreground,
          disabledBackgroundColor: colors.disabledFill,
          disabledForegroundColor: colors.textDisabled,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: AppTypography.ui(
            fontSize: 17,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.3,
          ),
        ),
        child: Text(label),
      ),
    );
  }
}