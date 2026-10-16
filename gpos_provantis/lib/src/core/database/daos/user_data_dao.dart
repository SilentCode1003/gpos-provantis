import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_data_table.dart';

part 'user_data_dao.g.dart';

@DriftAccessor(tables: [UserDataTable])
class UserDataDao extends DatabaseAccessor<AppDatabase>
    with _$UserDataDaoMixin {
  UserDataDao(super.db);

  // Saves the current user row in local storage.
  // Replaces the previous user entry so the app keeps a single active profile.
  Future<void> saveUser(UserDataTableCompanion user) {
    return transaction(() async {
      await delete(userDataTable).go();
      await into(userDataTable).insert(user);
    });
  }

  // Reads the stored user profile from local storage.
  // Returns null when no profile has been saved yet.
  Future<UserDataTableData?> getUser() {
    return select(userDataTable).getSingleOrNull();
  }

  // Watches the current user row for live updates.
  // Useful for screens that need immediate profile refreshes.
  Stream<UserDataTableData?> watchUser() {
    return select(userDataTable).watchSingleOrNull();
  }
}
