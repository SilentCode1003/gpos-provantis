import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';

part 'login_local_data_source.g.dart';

class LoginLocalDataSource {
  final AppDatabase _db;
  LoginLocalDataSource(this._db);

  Stream<UserDataTableData?> watchCurrentUser() {
    return _db.select(_db.userDataTable).watchSingleOrNull().handleError((
      Object e,
      StackTrace st,
    ) {
      debugPrint('🔥 watchCurrentUser stream error: $e\n$st');
    });
  }
}

@Riverpod(keepAlive: true)
LoginLocalDataSource loginLocalDataSource(Ref ref) {
  return LoginLocalDataSource(ref.watch(appDatabaseProvider));
}
