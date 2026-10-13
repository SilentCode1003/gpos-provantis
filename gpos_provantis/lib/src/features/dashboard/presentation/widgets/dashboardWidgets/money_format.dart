/// Formats an amount as pesos with thousands separators and two decimals:
/// `1234.5` -> `₱1,234.50`. Negative amounts get a real minus sign:
/// `-80` -> `−₱80.00`.
///
/// Plain Dart on purpose (no `intl` needed), and cheap enough to call for
/// every product card.
String formatPeso(num value) {
  final isNegative = value < 0;
  final parts = value.abs().toStringAsFixed(2).split('.');
  final whole = parts[0];

  final grouped = StringBuffer();
  for (var i = 0; i < whole.length; i++) {
    // A comma before every group of three digits, counting from the right.
    if (i > 0 && (whole.length - i) % 3 == 0) grouped.write(',');
    grouped.write(whole[i]);
  }

  return '${isNegative ? '\u2212' : ''}\u20b1$grouped.${parts[1]}';
}

/// Formats a whole number with thousands separators: `1234` -> `1,234`.
String formatCount(int value) {
  final digits = value.abs().toString();

  final grouped = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) grouped.write(',');
    grouped.write(digits[i]);
  }

  return '${value < 0 ? '\u2212' : ''}$grouped';
}
