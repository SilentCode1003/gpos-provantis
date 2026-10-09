import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';

/// How many Others actions are pinned beside the shift button.
const int kPinnedOtherActionCount = 3;

/// Counts how many times each Others action has been used, and remembers the
/// counts between app launches. State maps action id -> tap count.
class OthersUsageNotifier extends Notifier<Map<String, int>> {
  static const _prefsKey = 'others_action_usage_v1';

  late final Future<void> _loaded = _load();

  @override
  Map<String, int> build() {
    unawaited(_loaded);
    return const {};
  }

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final raw = prefs.getString(_prefsKey);
      if (raw == null) return;

      final decoded = jsonDecode(raw) as Map<String, dynamic>;
      final stored = decoded.map((k, v) => MapEntry(k, (v as num).toInt()));

      // Add anything tapped while the saved counts were still loading.
      final merged = Map<String, int>.from(stored);
      state.forEach((id, count) {
        merged[id] = (merged[id] ?? 0) + count;
      });
      state = merged;
    } catch (e) {
      debugPrint('[OthersUsage] load FAILED: $e');
    }
  }

  /// Adds one tap for [actionId] and saves it.
  Future<void> record(String actionId) async {
    state = {...state, actionId: (state[actionId] ?? 0) + 1};
    await _loaded;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_prefsKey, jsonEncode(state));
    } catch (e) {
      debugPrint('[OthersUsage] save FAILED: $e');
    }
  }
}

final othersUsageProvider =
    NotifierProvider<OthersUsageNotifier, Map<String, int>>(
      OthersUsageNotifier.new,
    );

/// Picks the actions to pin: most tapped first. Ties, and any empty slots
/// (fresh install, or fewer than 3 actions ever tapped), follow the order the
/// actions appear in the Others sheet.
List<OtherAction> topOtherActions(
  List<OtherAction> actions,
  Map<String, int> usage, {
  int count = kPinnedOtherActionCount,
}) {
  final indexed = actions.asMap().entries.toList();

  indexed.sort((a, b) {
    final byUse = (usage[b.value.id] ?? 0).compareTo(usage[a.value.id] ?? 0);
    return byUse != 0 ? byUse : a.key.compareTo(b.key);
  });

  return indexed.take(count).map((e) => e.value).toList();
}
