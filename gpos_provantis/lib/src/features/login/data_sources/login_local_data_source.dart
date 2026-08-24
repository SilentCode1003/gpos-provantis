import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';

part 'login_local_data_source.g.dart';

/// Reads the locally-stored logged-in user from UserDataTable.
///
/// NOTE: this only covers the READ side (watchCurrentUser). The login
/// screen isn't built yet, so there's currently no code that WRITES a row
/// into UserDataTable on successful login — that's the next piece to add
/// once the login flow exists. Until then, watchCurrentUser() will simply
/// emit null (no rows), which api_client.dart already treats as "no APK
/// yet" and handles gracefully.
class LoginLocalDataSource {
  final AppDatabase _db;
  LoginLocalDataSource(this._db);

  Stream<UserDataTableData?> watchCurrentUser() {
    return _db.select(_db.userDataTable).watchSingleOrNull().handleError((
      Object e,
      StackTrace st,
    ) {
      // watchSingleOrNull() throws if the query ever returns more than one
      // row. UserDataTable is meant to hold at most one row (single logged
      // -in user per device), so this would indicate a bug elsewhere if it
      // ever fires.
      debugPrint('🔥 watchCurrentUser stream error: $e\n$st');
    });
  }
}

@Riverpod(keepAlive: true)
LoginLocalDataSource loginLocalDataSource(Ref ref) {
  return LoginLocalDataSource(ref.watch(appDatabaseProvider));
}