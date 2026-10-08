import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/login_credentials_table.dart';

part 'login_credentials_dao.g.dart';

@DriftAccessor(tables: [LoginCredentialsTable])
class LoginCredentialsDao extends DatabaseAccessor<AppDatabase>
    with _$LoginCredentialsDaoMixin {
  LoginCredentialsDao(super.db);

  /// Keeps only one row, same as UserDataDao.
  Future<void> saveCredentials(LoginCredentialsTableCompanion credentials) {
    return transaction(() async {
      await delete(loginCredentialsTable).go();
      await into(loginCredentialsTable).insert(credentials);
    });
  }

  Future<LoginCredentialsTableData?> getCredentials() {
    return select(loginCredentialsTable).getSingleOrNull();
  }

  Future<void> clearCredentials() {
    return delete(loginCredentialsTable).go();
  }
}
