// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/amount_input_formatter.dart
import 'package:flutter/services.dart';

/// =========================================================================
/// AMOUNT INPUT FORMATTER — keeps a money TextField honest while the
/// cashier is typing, on a touchscreen where a stray finger easily lands
/// on the wrong key and there's no physical keyboard shape stopping a
/// letter from ever being possible in the first place. Also live-groups
/// the whole-number part with commas (1,234.56) so a multi-digit total
/// is readable at a glance instead of sitting as one undifferentiated
/// string of digits — which matters more here than on a typical form
/// field, since misreading the number on a payment screen is a real
/// money mistake, not just a cosmetic inconvenience.
///
/// RULES ENFORCED, CHARACTER BY CHARACTER (not just validated after the
/// fact — invalid input is rejected before it ever reaches the field,
/// so the cashier never sees a bad character flash in and get
/// auto-removed):
///   - Digits and a single '.' only — no letters, no minus sign (no
///     negative tenders), no second decimal point. Commas are also
///     accepted as input (so pasted/prefilled "1,234.56" text doesn't
///     get rejected outright) but are never counted as significant —
///     they're stripped and reinserted by this formatter itself, never
///     left to the typist to place correctly.
///   - At most 2 digits after the decimal point — this is currency, a
///     third decimal digit is never meaningful here.
///   - No leading zeros beyond a single '0' (so "0" and "0.5" are fine,
///     "007" is not) — prevents a mis-tap from quietly turning "5" into
///     "05" and then "005" without the cashier noticing the drift.
///
/// CURSOR HANDLING: grouping commas shift character positions every
/// time a digit is typed ("999" -> "1,000" is a 1-character insert that
/// changes the string length by 2), so this formatter tracks the
/// cursor by *how many digits precede it*, not by raw character index,
/// and re-derives the character offset from that count after
/// reformatting. That's what keeps the cursor sitting after the digit
/// just typed instead of jumping to the end of the field on every
/// keystroke — the naive approach (reformat and leave the cursor at
/// newValue.selection) breaks exactly that way.
///
/// TWO ENTRY POINTS, ONE RULESET: `AmountInputFormatter` (a
/// `TextInputFormatter`) handles real typed/pasted edits; `NumpadKey` +
/// `applyNumpadKey` handle taps on the on-screen numpad
/// (`AmountNumpad`, in amount_numpad.dart) this POS uses instead of the
/// OS soft keyboard. Both funnel through `_AmountEditCore.reformat` so
/// the two input paths enforce identical rules and can't quietly drift
/// apart — a numpad tap and the equivalent keystroke always produce the
/// same result.
/// =========================================================================

/// Formats a known-good double as grouped, fixed-2-decimal text — e.g.
/// `1234.5` -> `"1,234.50"`. Used anywhere an amount field's text is set
/// programmatically (an initial value, a "Fill remaining"/"Exact
/// amount" button) rather than typed, since `AmountInputFormatter`
/// above only runs on user-driven edits and never sees a direct
/// `controller.text = ...` assignment — without this, those assignments
/// would display an ungrouped number until the cashier's next keystroke
/// re-triggered the formatter.
String formatAmountForField(double amount) {
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  return _AmountInputFormatterGrouping.groupWholePart(parts[0]) +
      '.${parts[1]}';
}

/// Grouping logic broken out so both the live formatter and
/// `formatAmountForField` share exactly one implementation — otherwise
/// a fix to one (e.g. handling of very large amounts) could silently
/// drift out of sync with the other.
class _AmountInputFormatterGrouping {
  static String groupWholePart(String digits) {
    if (digits.length <= 3) return digits;
    final buffer = StringBuffer();
    final remainderLength = digits.length % 3;
    if (remainderLength > 0) {
      buffer.write(digits.substring(0, remainderLength));
      if (digits.length > remainderLength) buffer.write(',');
    }
    for (var i = remainderLength; i < digits.length; i += 3) {
      buffer.write(digits.substring(i, i + 3));
      if (i + 3 < digits.length) buffer.write(',');
    }
    return buffer.toString();
  }
}

/// One key on the numpad: a digit 0-9, the decimal point, or backspace.
/// Modeled as a sealed-ish enum rather than passing raw strings around,
/// so `applyNumpadKey` below can't be called with something that isn't
/// actually a key on the pad.
enum NumpadKey {
  d0,
  d1,
  d2,
  d3,
  d4,
  d5,
  d6,
  d7,
  d8,
  d9,
  point,
  backspace;

  /// The literal character this key inserts, or null for backspace
  /// (which removes rather than inserts).
  String? get character {
    switch (this) {
      case NumpadKey.d0:
        return '0';
      case NumpadKey.d1:
        return '1';
      case NumpadKey.d2:
        return '2';
      case NumpadKey.d3:
        return '3';
      case NumpadKey.d4:
        return '4';
      case NumpadKey.d5:
        return '5';
      case NumpadKey.d6:
        return '6';
      case NumpadKey.d7:
        return '7';
      case NumpadKey.d8:
        return '8';
      case NumpadKey.d9:
        return '9';
      case NumpadKey.point:
        return '.';
      case NumpadKey.backspace:
        return null;
    }
  }
}

/// Applies one [NumpadKey] tap to the field's current grouped/formatted
/// text and cursor position, returning the new formatted text +
/// selection — the exact same result the `TextInputFormatter` below
/// would produce for the equivalent keystroke, since both route through
/// `_AmountEditCore.apply`. This is what lets the on-screen numpad and
/// (if a hardware/barcode-scanner keyboard is ever plugged into a
/// terminal) real typing stay behaviorally identical rather than
/// silently drifting into two different rule sets over time.
TextEditingValue applyNumpadKey(TextEditingValue current, NumpadKey key) {
  final text = current.text;
  final cursor = current.selection.end < 0
      ? text.length
      : current.selection.end;

  final String rawNext;
  final int rawCursorAfterEdit;
  if (key == NumpadKey.backspace) {
    if (cursor <= 0) return current; // nothing before the cursor to remove
    // Deleting a comma should remove the digit before it too — a comma
    // is display formatting the cashier never typed, so backspacing
    // "onto" one should feel like backspacing past it, not require a
    // second tap that appears to do nothing.
    var deleteFrom = cursor - 1;
    if (text[deleteFrom] == ',') deleteFrom -= 1;
    if (deleteFrom < 0) return current;
    rawNext = text.substring(0, deleteFrom) + text.substring(cursor);
    rawCursorAfterEdit = deleteFrom;
  } else {
    final char = key.character!;
    rawNext = text.substring(0, cursor) + char + text.substring(cursor);
    rawCursorAfterEdit = cursor + char.length;
  }

  return _AmountEditCore.reformat(
    rawText: rawNext,
    rawCursor: rawCursorAfterEdit,
    fallback: current,
  );
}

/// Core "given raw (possibly just-edited, possibly still comma-grouped)
/// text and a raw cursor position, produce the validated/reformatted
/// result" logic — shared by the character-by-character
/// `TextInputFormatter` (below) and `applyNumpadKey` (above), so the
/// two input paths can never quietly disagree about what's a valid
/// amount.
class _AmountEditCore {
  static const int maxDecimalDigits = 2;
  static final RegExp _validCharacter = RegExp(r'^[0-9.,]$');

  /// Returns the reformatted, validated TextEditingValue, or [fallback]
  /// unchanged if the edit described by [rawText]/[rawCursor] isn't a
  /// valid amount edit (bad character, second decimal point, too many
  /// decimal digits, or a leading zero run).
  static TextEditingValue reformat({
    required String rawText,
    required int rawCursor,
    required TextEditingValue fallback,
  }) {
    if (rawText.isEmpty) {
      return const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
    }

    for (final char in rawText.split('')) {
      if (!_validCharacter.hasMatch(char)) return fallback;
    }

    final textBeforeCursor = rawText.substring(
      0,
      rawCursor.clamp(0, rawText.length),
    );
    final digitsBeforeCursor = textBeforeCursor
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;
    final dotIsBeforeCursor = textBeforeCursor.contains('.');

    final unformatted = rawText.replaceAll(',', '');

    final dotCount = '.'.allMatches(unformatted).length;
    if (dotCount > 1) return fallback;

    final parts = unformatted.split('.');
    final wholePart = parts[0];
    final fractionPart = parts.length > 1 ? parts[1] : null;

    if (wholePart.length > 1 && wholePart.startsWith('0')) return fallback;

    if (fractionPart != null && fractionPart.length > maxDecimalDigits) {
      return fallback;
    }

    final grouped =
        _AmountInputFormatterGrouping.groupWholePart(wholePart) +
        (fractionPart != null
            ? '.$fractionPart'
            : (unformatted.endsWith('.') ? '.' : ''));

    final newCursorOffset = _resolveCursorOffset(
      grouped,
      digitsBeforeCursor,
      dotIsBeforeCursor,
    );

    return TextEditingValue(
      text: grouped,
      selection: TextSelection.collapsed(offset: newCursorOffset),
    );
  }

  /// Finds where the cursor should land in the freshly-grouped [text]:
  /// right after the [targetDigitCount]-th digit, then one more step
  /// past that if a decimal point had already been typed before the
  /// cursor (`dotAlreadyTyped`). That second part is what fixes typing
  /// "." itself — at the moment the dot is typed, the digit count
  /// hasn't changed (a dot isn't a digit), so anchoring on digits alone
  /// would leave the cursor sitting right before the dot instead of
  /// after it, which is what let the next digit typed land on the ones
  /// place instead of the cents place.
  static int _resolveCursorOffset(
    String text,
    int targetDigitCount,
    bool dotAlreadyTyped,
  ) {
    final afterDigits = _offsetAfterNDigits(text, targetDigitCount);
    if (!dotAlreadyTyped) return afterDigits;
    final dotIndex = text.indexOf('.');
    if (dotIndex >= 0 && dotIndex >= afterDigits) {
      return dotIndex + 1;
    }
    return afterDigits;
  }

  /// Finds the character offset in [text] that sits immediately after
  /// the [targetDigitCount]-th digit (commas and the decimal point
  /// don't count).
  static int _offsetAfterNDigits(String text, int targetDigitCount) {
    if (targetDigitCount <= 0) return 0;
    var digitsSeen = 0;
    for (var i = 0; i < text.length; i++) {
      if (RegExp(r'[0-9]').hasMatch(text[i])) {
        digitsSeen++;
        if (digitsSeen == targetDigitCount) return i + 1;
      }
    }
    return text.length;
  }
}

class AmountInputFormatter extends TextInputFormatter {
  const AmountInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    return _AmountEditCore.reformat(
      rawText: newValue.text,
      rawCursor: newValue.selection.end < 0
          ? newValue.text.length
          : newValue.selection.end,
      fallback: oldValue,
    );
  }
}

/// Parses whatever's currently in an amount field back into a double,
/// treating a trailing "." (e.g. mid-typing "12.") and blank input as
/// "not yet a valid amount" rather than throwing or silently
/// truncating. Strips grouping commas first, since the formatter above
/// always leaves them in the displayed text.
double? parseAmountField(String text) {
  final trimmed = text.trim().replaceAll(',', '');
  if (trimmed.isEmpty || trimmed.endsWith('.')) return null;
  return double.tryParse(trimmed);
}
