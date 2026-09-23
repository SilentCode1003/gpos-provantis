// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/amount_numpad.dart
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'amount_input_formatter.dart';

/// =========================================================================
/// AMOUNT NUMPAD — a dedicated on-screen numeric keypad for entering
/// money amounts, used everywhere this modal needs an amount typed in
/// (`_CashScreen`, `_CashRow`, `_EPaymentBlock`).
///
/// WHY NOT THE OS SOFT KEYBOARD: this is a fixed touchscreen POS
/// terminal, not a phone — relying on the Android/Windows on-screen
/// keyboard means every amount field inherits a keyboard the app
/// doesn't control: it can be dismissed by an accidental tap outside
/// it, its key sizing follows phone/tablet text-entry conventions
/// rather than this app's touch-target rules, and its layout wastes
/// space on a full alphabet the cashier will never need for a number.
/// A dedicated numpad is sized and spaced exactly like every other
/// control in this modal, never disappears unexpectedly, and its keys
/// map 1:1 to what a money amount can actually contain — nothing else
/// is even offered as a key.
///
/// HOW A FIELD OPTS IN: the `TextField` it drives must be
/// `readOnly: true` (this is what stops Android/Windows from popping
/// the OS keyboard the instant the field gains focus) while keeping
/// `showCursor: true` and a normal `focusNode`/`onTap` so the field
/// still looks and feels editable — it just receives its edits from
/// this widget's key taps instead of from a keyboard. See
/// `_AmountField` in payment_modal.dart for the wrapper every amount
/// field in this modal uses, which wires that up consistently.
///
/// SHARED VALIDATION: every key tap routes through `applyNumpadKey` in
/// amount_input_formatter.dart — the exact same rule set
/// (`AmountInputFormatter`) already enforces for typed input, so a
/// numpad tap and a keystroke can never disagree about what's a valid
/// amount.
/// =========================================================================

class AmountNumpad extends StatelessWidget {
  const AmountNumpad({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  /// The currently-active amount field's controller. The numpad reads
  /// its current value/cursor from this and writes the result straight
  /// back — there's always exactly one active field per numpad instance
  /// (each amount field mounts its own numpad directly beneath it
  /// rather than sharing one numpad across multiple fields on screen,
  /// which keeps "which field am I typing into" unambiguous without
  /// needing separate focus-tracking state).
  final TextEditingController controller;

  /// Called after every key tap with the field's new *parsed* value
  /// (already comma-stripped, still null while the field doesn't yet
  /// hold a complete number) — mirrors a `TextField.onChanged` handler
  /// fed through `parseAmountField`, so callers don't need to parse the
  /// controller's text themselves.
  final ValueChanged<double?> onChanged;

  void _handleKey(NumpadKey key) {
    final current = TextEditingValue(
      text: controller.text,
      selection: controller.selection,
    );
    final next = applyNumpadKey(current, key);
    controller.value = next;
    onChanged(parseAmountField(next.text));
  }

  @override
  Widget build(BuildContext context) {
    // Fills whatever height/width it's given rather than sizing to its
    // own intrinsic content — this is what lets the numpad actually
    // grow to fill the rail it sits in (see _NumpadRail) instead of
    // sitting small and centered with empty space around it. Each row
    // is Expanded so all 4 rows share the available height equally, and
    // each key inside a row is Expanded too (see _NumpadRow), so a key
    // is exactly "1/3 of the row's width" by "1/4 of the numpad's
    // height" — no AspectRatio holding it back from growing into
    // whatever room is actually there.
    return Column(
      children: [
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '7',
                onTap: () => _handleKey(NumpadKey.d7),
              ),
              _NumpadDigitKey(
                label: '8',
                onTap: () => _handleKey(NumpadKey.d8),
              ),
              _NumpadDigitKey(
                label: '9',
                onTap: () => _handleKey(NumpadKey.d9),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '4',
                onTap: () => _handleKey(NumpadKey.d4),
              ),
              _NumpadDigitKey(
                label: '5',
                onTap: () => _handleKey(NumpadKey.d5),
              ),
              _NumpadDigitKey(
                label: '6',
                onTap: () => _handleKey(NumpadKey.d6),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '1',
                onTap: () => _handleKey(NumpadKey.d1),
              ),
              _NumpadDigitKey(
                label: '2',
                onTap: () => _handleKey(NumpadKey.d2),
              ),
              _NumpadDigitKey(
                label: '3',
                onTap: () => _handleKey(NumpadKey.d3),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _NumpadRow(
            children: [
              _NumpadDigitKey(
                label: '.',
                onTap: () => _handleKey(NumpadKey.point),
              ),
              _NumpadDigitKey(
                label: '0',
                onTap: () => _handleKey(NumpadKey.d0),
              ),
              _NumpadBackspaceKey(onTap: () => _handleKey(NumpadKey.backspace)),
            ],
          ),
        ),
      ],
    );
  }
}

/// One row of three keys, evenly spaced — matches the 3-across cube
/// rhythm used elsewhere in this modal (root options, split choice) so
/// the numpad reads as part of the same visual family rather than a
/// bolted-on control. Each key is Expanded so it fills the row's full
/// height (the row itself is Expanded by the parent Column above), not
/// just its width.
class _NumpadRow extends StatelessWidget {
  const _NumpadRow({required this.children});

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        for (var i = 0; i < children.length; i++) ...[
          if (i > 0) const SizedBox(width: 12),
          Expanded(child: children[i]),
        ],
      ],
    );
  }
}

/// A single digit/point key. Fills whatever cell size the row/column
/// grid gives it — no AspectRatio, no minHeight floor, since on a fixed
/// numpad rail the row height itself already guarantees a large key;
/// constraining it further would only ever shrink it back down towards
/// the old cramped size, not help it grow to fill the rail.
class _NumpadDigitKey extends StatelessWidget {
  const _NumpadDigitKey({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Text(
            label,
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 28,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

/// Backspace key — same fill behavior as a digit key so the grid stays
/// visually regular, distinguished by an icon and a slightly muted
/// fill rather than a shape change, since it sits directly beside the
/// digit keys and a shape change there raises the odds of a mis-tap.
class _NumpadBackspaceKey extends StatelessWidget {
  const _NumpadBackspaceKey({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.border, width: 1.5),
          ),
          alignment: Alignment.center,
          child: Icon(
            Icons.backspace_outlined,
            size: 28,
            color: colors.textSecondary,
          ),
        ),
      ),
    );
  }
}
