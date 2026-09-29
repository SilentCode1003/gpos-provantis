import 'dart:convert';

class CounterDisplayCodec {
  const CounterDisplayCodec._();

  static const String empty = '[]';

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

  static String encode(Set<int> hiddenCodes) {
    final sorted = hiddenCodes.toList()..sort();
    return jsonEncode(sorted);
  }

  static bool isVisible(Set<int> hiddenCodes, int categoryCode) {
    return !hiddenCodes.contains(categoryCode);
  }
}
