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

class AmountInputFormatter extends TextInputFormatter {
  const AmountInputFormatter({this.maxDecimalDigits = 2});

  final int maxDecimalDigits;

  static final RegExp _validCharacter = RegExp(r'^[0-9.,]$');

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final newText = newValue.text;

    // Empty is always allowed — the field being cleared out entirely is
    // a normal, valid intermediate state, not something to reject.
    if (newText.isEmpty) {
      return newValue;
    }

    // Reject anything that isn't a digit, a decimal point, or a comma
    // outright — this is what stops a hardware/software keyboard's
    // letter keys from ever landing in the field. Commas are accepted
    // here only so this formatter can strip and re-lay them itself
    // below; nothing downstream treats a user-typed comma as
    // meaningful on its own.
    for (final char in newText.split('')) {
      if (!_validCharacter.hasMatch(char)) return oldValue;
    }

    // How many "significant" characters (digits, plus a decimal point
    // if one precedes the cursor) sat before the cursor in the new
    // value — commas don't count, since they're pure display
    // formatting this formatter inserts/removes on its own. The
    // decimal point DOES count here, unlike in the digit-only count
    // used elsewhere: if it didn't, typing "123" + "." would anchor
    // the cursor to "after the 3rd digit", which sits *before* the
    // dot the user just typed rather than after it — landing back on
    // the ones place instead of moving into the cents.
    final cursorIndex = newValue.selection.end < 0
        ? newText.length
        : newValue.selection.end;
    final textBeforeCursor = newText.substring(0, cursorIndex);
    final digitsBeforeCursor = textBeforeCursor
        .replaceAll(RegExp(r'[^0-9]'), '')
        .length;
    final dotIsBeforeCursor = textBeforeCursor.contains('.');

    // Strip commas before validating/splitting — they're purely
    // display formatting from here on, re-added at the end.
    final unformatted = newText.replaceAll(',', '');

    // At most one decimal point.
    final dotCount = '.'.allMatches(unformatted).length;
    if (dotCount > 1) return oldValue;

    final parts = unformatted.split('.');
    final wholePart = parts[0];
    final fractionPart = parts.length > 1 ? parts[1] : null;

    // No leading zeros ("00", "007") other than a bare "0" or "0." —
    // prevents a mis-tap from quietly turning "5" into "05" and then
    // "005" without the cashier noticing the drift.
    if (wholePart.length > 1 && wholePart.startsWith('0')) return oldValue;

    // Cap decimal places at maxDecimalDigits (2 for currency) — a third
    // typed digit after the point is simply not accepted, same as a
    // stray letter wouldn't be.
    if (fractionPart != null && fractionPart.length > maxDecimalDigits) {
      return oldValue;
    }

    final grouped =
        _groupWholePart(wholePart) +
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
  int _resolveCursorOffset(
    String text,
    int targetDigitCount,
    bool dotAlreadyTyped,
  ) {
    final afterDigits = _offsetAfterNDigits(text, targetDigitCount);
    if (!dotAlreadyTyped) return afterDigits;
    final dotIndex = text.indexOf('.');
    // The decimal point should sit at or immediately after
    // afterDigits — step past it if it's right there, otherwise trust
    // the digit-based offset (covers the "0 digits typed yet, cursor
    // sits after a leading dot" edge case, which shouldn't normally
    // arise since a lone "." isn't a valid amount, but stays safe
    // either way).
    if (dotIndex >= 0 && dotIndex >= afterDigits) {
      return dotIndex + 1;
    }
    return afterDigits;
  }

  /// Inserts thousands-separator commas into a whole-number digit
  /// string: "1234567" -> "1,234,567". Assumes no existing punctuation
  /// (callers strip commas before calling this). Delegates to the same
  /// grouping logic `formatAmountForField` uses, so live-typed and
  /// programmatically-set amounts always group identically.
  String _groupWholePart(String digits) =>
      _AmountInputFormatterGrouping.groupWholePart(digits);

  /// Finds the character offset in [text] that sits immediately after
  /// the [targetDigitCount]-th digit (commas and the decimal point
  /// don't count). Used to re-anchor the cursor to "after the digit the
  /// cashier just typed" rather than to a raw character index that's
  /// meaningless once commas shift around it.
  int _offsetAfterNDigits(String text, int targetDigitCount) {
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
