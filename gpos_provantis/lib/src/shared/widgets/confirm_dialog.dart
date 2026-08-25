// Location: src/shared/widgets/confirm_dialog.dart
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';

/// =========================================================================
/// CONFIRM DIALOG — the one confirmation-box design for the whole app.
///
/// Built so a screen never has to invent this pattern from scratch again:
/// a danger-colored eyebrow label, a Fraunces headline, a Public Sans
/// body, and two flat text actions split by a single hairline — no
/// icon-in-a-tinted-box (a stock Material pattern that reads as dated
/// regardless of which palette fills it in), no button chrome, no
/// shadow/elevation/blur, in keeping with this app's flat, cheap-to-paint
/// discipline (see login_screen.dart's file header for the fuller
/// rationale on POS-hardware performance).
///
/// USAGE — from anywhere with a BuildContext:
///
///   final confirmed = await showConfirmDialog(
///     context,
///     eyebrow: 'RETURN TO SETUP',
///     title: 'Leave login for domain setup?',
///     body: 'This reopens domain, branch, and POS configuration. '
///         'Anyone signing in on this device will need to wait until '
///         'setup is finished again.',
///     confirmLabel: 'Go to setup',
///   );
///   if (confirmed == true) { ... }
///
/// `isDestructive` (default true) controls whether the confirm action and
/// eyebrow render in `colors.danger` or `colors.primary` — set it false
/// for confirmations that aren't actually a warning (e.g. "Confirm this
/// is a $0.00 sale?"), so the color still means something every time.
/// =========================================================================

Future<bool?> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String body,
  String? eyebrow,
  String confirmLabel = 'Confirm',
  String cancelLabel = 'Cancel',
  bool isDestructive = true,
  bool barrierDismissible = true,
}) {
  return showDialog<bool>(
    context: context,
    barrierDismissible: barrierDismissible,
    builder: (context) => ConfirmDialog(
      title: title,
      body: body,
      eyebrow: eyebrow,
      confirmLabel: confirmLabel,
      cancelLabel: cancelLabel,
      isDestructive: isDestructive,
    ),
  );
}

class ConfirmDialog extends StatelessWidget {
  const ConfirmDialog({
    super.key,
    required this.title,
    required this.body,
    this.eyebrow,
    this.confirmLabel = 'Confirm',
    this.cancelLabel = 'Cancel',
    this.isDestructive = true,
  });

  final String title;
  final String body;

  /// Short, all-caps context label above the title (e.g. "RETURN TO
  /// SETUP", "VOID SALE"). Optional — omit for confirmations that don't
  /// need a named category.
  final String? eyebrow;

  final String confirmLabel;
  final String cancelLabel;

  /// True (default) for anything disruptive, irreversible, or costly to
  /// undo — renders the eyebrow and confirm action in `colors.danger`.
  /// False for confirmations that are just a deliberate double-check on
  /// an otherwise ordinary action — renders them in `colors.primary`
  /// instead, so danger-red doesn't get diluted into meaning "any
  /// dialog" across the app.
  final bool isDestructive;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final accent = isDestructive ? colors.danger : colors.primary;

    return Dialog(
      backgroundColor: colors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: colors.border),
      ),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 380),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (eyebrow != null) ...[
                    Text(
                      eyebrow!,
                      style: AppTypography.ui(
                        color: accent,
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.4,
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                  Text(
                    title,
                    style: AppTypography.display(
                      color: colors.textPrimary,
                      fontSize: 21,
                      fontWeight: FontWeight.w600,
                      height: 1.15,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Text(
                    body,
                    style: AppTypography.ui(
                      color: colors.textSecondary,
                      fontSize: 14,
                      height: 1.45,
                    ),
                  ),
                ],
              ),
            ),
            // borderSubtle, not border: this hairline sits between two
            // lines of text inside a surface the same color as itself —
            // border's full weight (meant for card/input edges against
            // the page) reads too heavy and too neutral-gray in that
            // context, closer to a leftover HTML <hr> than a quiet seam.
            Divider(height: 1, thickness: 1, color: colors.borderSubtle),
            Row(
              children: [
                Expanded(
                  child: _DialogAction(
                    label: cancelLabel,
                    color: colors.textPrimary,
                    onPressed: () => Navigator.of(context).pop(false),
                  ),
                ),
                Container(width: 1, height: 52, color: colors.borderSubtle),
                Expanded(
                  child: _DialogAction(
                    label: confirmLabel,
                    color: accent,
                    fontWeight: FontWeight.w600,
                    onPressed: () => Navigator.of(context).pop(true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Flat, full-width text action sharing one row — no button chrome
/// (no fill, no border-radius, no elevation), just type and a hairline
/// divider between the two choices.
class _DialogAction extends StatelessWidget {
  const _DialogAction({
    required this.label,
    required this.color,
    required this.onPressed,
    this.fontWeight = FontWeight.w600,
  });

  final String label;
  final Color color;
  final VoidCallback onPressed;
  final FontWeight fontWeight;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        child: SizedBox(
          height: 52,
          child: Center(
            child: Text(
              label,
              style: AppTypography.ui(
                color: color,
                fontSize: 14,
                fontWeight: fontWeight,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
