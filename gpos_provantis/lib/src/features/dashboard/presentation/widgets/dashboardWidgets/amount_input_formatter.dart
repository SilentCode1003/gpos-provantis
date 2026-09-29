import 'package:flutter/services.dart';

String formatAmountForField(double amount) {
  final fixed = amount.toStringAsFixed(2);
  final parts = fixed.split('.');
  return _AmountInputFormatterGrouping.groupWholePart(parts[0]) +
      '.${parts[1]}';
}

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

TextEditingValue applyNumpadKey(TextEditingValue current, NumpadKey key) {
  final text = current.text;
  final cursor = current.selection.end < 0
      ? text.length
      : current.selection.end;

  final String rawNext;
  final int rawCursorAfterEdit;
  if (key == NumpadKey.backspace) {
    if (cursor <= 0) return current; // nothing before the cursor to remove

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

class _AmountEditCore {
  static const int maxDecimalDigits = 2;
  static final RegExp _validCharacter = RegExp(r'^[0-9.,]$');

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

double? parseAmountField(String text) {
  final trimmed = text.trim().replaceAll(',', '');
  if (trimmed.isEmpty || trimmed.endsWith('.')) return null;
  return double.tryParse(trimmed);
}
