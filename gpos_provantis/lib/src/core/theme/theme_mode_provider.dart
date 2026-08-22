// Location: src/core/theme/theme_mode_provider.dart
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'theme_mode_provider.g.dart';

/// =========================================================================
/// THEME MODE — user's chosen appearance: light / dark / system.
///
/// `ThemeMode` (from Flutter) already models exactly this: `light`, `dark`,
/// `system`. No need to invent a parallel enum — we persist and expose
/// Flutter's own type directly.
///
/// Usage in a widget:
///   final mode = ref.watch(themeModeControllerProvider);
///   MaterialApp(themeMode: mode, ...)
///
/// To change it (e.g. from a settings page):
///   ref.read(themeModeControllerProvider.notifier).setMode(ThemeMode.dark);
/// =========================================================================

const _fileName = 'theme_mode.json';

Future<File> _themeModeFile() async {
  final dir = await getApplicationDocumentsDirectory();
  return File('${dir.path}/$_fileName');
}

ThemeMode _decode(String raw) {
  switch (raw) {
    case 'light':
      return ThemeMode.light;
    case 'dark':
      return ThemeMode.dark;
    case 'system':
    default:
      return ThemeMode.system;
  }
}

String _encode(ThemeMode mode) => switch (mode) {
  ThemeMode.light => 'light',
  ThemeMode.dark => 'dark',
  ThemeMode.system => 'system',
};

@Riverpod(keepAlive: true)
class ThemeModeController extends _$ThemeModeController {
  @override
  ThemeMode build() {
    // Kick off async load; defaults to system until it resolves.
    _load();
    return ThemeMode.system;
  }

  Future<void> _load() async {
    try {
      final file = await _themeModeFile();
      if (!await file.exists()) return;
      final raw = jsonDecode(await file.readAsString()) as Map<String, dynamic>;
      final mode = _decode(raw['mode'] as String? ?? 'system');
      state = mode;
    } catch (_) {
      // Corrupt or unreadable file — fall back silently to system.
      state = ThemeMode.system;
    }
  }

  Future<void> setMode(ThemeMode mode) async {
    state = mode;
    try {
      final file = await _themeModeFile();
      await file.writeAsString(jsonEncode({'mode': _encode(mode)}));
    } catch (_) {
      // Persistence failure shouldn't crash the UI toggle — the in-memory
      // state is already updated; it just won't survive an app restart.
    }
  }

  /// Convenience cycle: system -> light -> dark -> system ...
  Future<void> cycle() async {
    final next = switch (state) {
      ThemeMode.system => ThemeMode.light,
      ThemeMode.light => ThemeMode.dark,
      ThemeMode.dark => ThemeMode.system,
    };
    await setMode(next);
  }
}

/// True dark/light resolution accounting for `ThemeMode.system`.
///
/// Riverpod can't read `MediaQuery` on its own (that needs a BuildContext),
/// so widgets that need "is it *actually* dark right now" — not just the
/// user's preference — should use the `context.colors` / `context.isDarkMode`
/// extension in `app_colors_extension.dart` instead of this provider.
/// This provider only tracks the user's raw preference (light/dark/system).
