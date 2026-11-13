import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod/riverpod.dart';
import 'package:gpos_provantis/src/core/database/daos/settings_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/settings_dao_provider.dart';

/// A username and password saved from a previous successful sign-in.
class RememberedLogin {
  const RememberedLogin({required this.username, required this.password});

  final String username;
  final String password;
}

/// Remembers the last signed-in user for the "Remember last login" setting.
///
/// - The on/off switch and the username live in the settings table.
/// - The password is kept in the device's secure storage (Android Keystore,
///   Windows credential encryption), never in the database.
class RememberedLoginService {
  RememberedLoginService(this._dao, [FlutterSecureStorage? storage])
    : _storage = storage ?? const FlutterSecureStorage();

  static const _passwordKey = 'remembered_login_password';

  final SettingsDao _dao;
  final FlutterSecureStorage _storage;

  /// The saved login, or null if the setting is off or nothing is saved.
  Future<RememberedLogin?> load() async {
    try {
      final rows = await _dao.getSettings();
      if (rows.isEmpty) return null;

      final row = rows.first;
      final username = row.lastLoginUsername;
      if (!row.rememberLastLogin || username == null || username.isEmpty) {
        return null;
      }

      final password = await _storage.read(key: _passwordKey);
      return RememberedLogin(username: username, password: password ?? '');
    } catch (_) {
      // Secure storage can fail (e.g. a wiped keystore). Just don't pre-fill.
      return null;
    }
  }

  /// Saves the login if the setting is on. Never throws: failing to remember
  /// must not get in the way of signing in.
  Future<void> saveIfEnabled(String username, String password) async {
    try {
      final rows = await _dao.getSettings();
      if (rows.isEmpty || !rows.first.rememberLastLogin) return;

      await _dao.setLastLoginUsername(username);
      await _storage.write(key: _passwordKey, value: password);
    } catch (_) {}
  }

  /// Call this from the settings switch. Turning it off also wipes the saved
  /// username and password.
  Future<void> setEnabled(bool enabled) async {
    await _dao.setRememberLastLogin(enabled);
    if (!enabled) {
      try {
        await _storage.delete(key: _passwordKey);
      } catch (_) {}
    }
  }
}

final rememberedLoginServiceProvider = Provider<RememberedLoginService>((ref) {
  return RememberedLoginService(ref.watch(settingsDaoProvider));
});
