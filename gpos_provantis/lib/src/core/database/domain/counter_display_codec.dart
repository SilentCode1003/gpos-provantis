// Location: src/core/database/domain/counter_display_codec.dart
import 'dart:convert';

/// Reads and writes the `counterDisplay` TEXT column in `SettingsTable`.
///
/// WHAT IS STORED
/// The column holds a JSON list of the category codes that are HIDDEN,
/// for example `[2,4]`.
///
/// WHY "HIDDEN" AND NOT "SHOWN"
/// Categories come from the server and can be added or removed at any
/// time. If we stored the shown list, a brand-new category would be
/// missing from it and would silently disappear from the main screen.
/// Storing the hidden list means a new category shows by default, and a
/// removed category just leaves a harmless leftover code.
///
/// SAFE DEFAULTS
/// The column default is the text `UNREGISTERED`, which is not valid
/// JSON. Anything that cannot be read is treated as "nothing hidden".
class CounterDisplayCodec {
  const CounterDisplayCodec._();

  /// The value to store when nothing is hidden.
  static const String empty = '[]';

  /// Turns the stored text into a set of hidden category codes.
  /// Never throws: bad, empty, or `UNREGISTERED` text gives an empty set.
  static Set<int> decode(String? raw) {
    if (raw == null) return <int>{};

    final text = raw.trim();
    if (text.isEmpty || text == 'UNREGISTERED') return <int>{};

    try {
      final parsed = jsonDecode(text);
      if (parsed is! List) return <int>{};

      final codes = <int>{};
      for (final item in parsed) {
        if (item is int) {
          codes.add(item);
        } else if (item is num) {
          codes.add(item.toInt());
        } else if (item is String) {
          final value = int.tryParse(item);
          if (value != null) codes.add(value);
        }
      }
      return codes;
    } catch (_) {
      return <int>{};
    }
  }

  /// Turns a set of hidden category codes into text for the column.
  /// Codes are sorted so the same choices always give the same text.
  static String encode(Set<int> hiddenCodes) {
    final sorted = hiddenCodes.toList()..sort();
    return jsonEncode(sorted);
  }

  /// True when [categoryCode] should show on the main screen.
  static bool isVisible(Set<int> hiddenCodes, int categoryCode) {
    return !hiddenCodes.contains(categoryCode);
  }
}
