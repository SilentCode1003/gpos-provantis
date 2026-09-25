// Location: src/shared/widgets/confirm_dialog.dart
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';

/// CONFIRM DIALOG — single confirmation design for the whole app.
/// Flat, no chrome, tuned for POS performance discipline.
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

  /// Short all-caps label above title (e.g. "RETURN TO SETUP"). Optional.
  final String? eyebrow;

  final String confirmLabel;
  final String cancelLabel;

  /// True (destructive) for irreversible actions; false for confirmations.
  /// Controls color (danger vs primary) and eyebrow tone.
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
            // Subtle divider between text lines (not full-weight border)
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

/// Flat, full-width text action with hairline divider between choices.
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
