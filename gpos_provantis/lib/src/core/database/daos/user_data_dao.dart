import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_data_table.dart';

part 'user_data_dao.g.dart';

@DriftAccessor(tables: [UserDataTable])
class UserDataDao extends DatabaseAccessor<AppDatabase>
    with _$UserDataDaoMixin {
      UserDataDao(super.db);

  /// Saves (inserts or overwrites) the single user data row.
  /// `id` uses the table's fixed default ('user_data'), so this is
  /// always an upsert against that one row.
  Future<void> saveUser(UserDataTableCompanion user) {
    return into(userDataTable).insertOnConflictUpdate(user);
  }

  Future<UserDataTableData?> getUser() {
    return select(userDataTable).getSingleOrNull();
  }

  Stream<UserDataTableData?> watchUser() {
    return select(userDataTable).watchSingleOrNull();
  }
}
