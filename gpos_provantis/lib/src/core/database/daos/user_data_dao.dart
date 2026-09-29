import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/user_data_table.dart';

part 'user_data_dao.g.dart';

@DriftAccessor(tables: [UserDataTable])
class UserDataDao extends DatabaseAccessor<AppDatabase>
    with _$UserDataDaoMixin {
  UserDataDao(super.db);

  Future<void> saveUser(UserDataTableCompanion user) {
    return transaction(() async {
      await delete(userDataTable).go();
      await into(userDataTable).insert(user);
    });
  }

  Future<UserDataTableData?> getUser() {
    return select(userDataTable).getSingleOrNull();
  }

  Stream<UserDataTableData?> watchUser() {
    return select(userDataTable).watchSingleOrNull();
  }
}
