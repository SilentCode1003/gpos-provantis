import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/login_credentials_table.dart';

part 'login_credentials_dao.g.dart';

@DriftAccessor(tables: [LoginCredentialsTable])
class LoginCredentialsDao extends DatabaseAccessor<AppDatabase>
    with _$LoginCredentialsDaoMixin {
  LoginCredentialsDao(super.db);

  /// Keeps only one row, same as UserDataDao.
  // Saves a single login credential row and clears prior values.
  // Keeps exactly one active credential set for the current session.
  Future<void> saveCredentials(LoginCredentialsTableCompanion credentials) {
    return transaction(() async {
      await delete(loginCredentialsTable).go();
      await into(loginCredentialsTable).insert(credentials);
    });
  }

  // Reads the stored login credentials from local storage.
  // Returns null when no active credentials are saved yet.
  Future<LoginCredentialsTableData?> getCredentials() {
    return select(loginCredentialsTable).getSingleOrNull();
  }

  // Clears the saved login credentials from local storage.
  // Used when logging out or resetting the current session.
  Future<void> clearCredentials() {
    return delete(loginCredentialsTable).go();
  }
}
