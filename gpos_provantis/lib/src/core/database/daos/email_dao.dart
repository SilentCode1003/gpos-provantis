import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/email_table.dart';

part 'email_dao.g.dart';

@DriftAccessor(tables: [EmailTable])
class EmailDao extends DatabaseAccessor<AppDatabase> with _$EmailDaoMixin {
  EmailDao(super.db);

  // Saves the email record with conflict-safe upsert behavior.
  // Keeps the configured sender address available for later reads.
  Future<void> saveEmail(EmailTableCompanion email) {
    return into(emailTable).insertOnConflictUpdate(email);
  }

  // Reads the stored email row from local storage.
  // Returns null when no email configuration has been saved yet.
  Future<EmailTableData?> getEmail() {
    return select(emailTable).getSingleOrNull();
  }

  // Watches the email configuration for live updates.
  // Useful for screens that need the currently configured sender address.
  Stream<EmailTableData?> watchEmail() {
    return select(emailTable).watchSingleOrNull();
  }
}
