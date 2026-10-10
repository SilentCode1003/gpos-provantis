import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/email_table.dart';

part 'email_dao.g.dart';

@DriftAccessor(tables: [EmailTable])
class EmailDao extends DatabaseAccessor<AppDatabase> with _$EmailDaoMixin {
  EmailDao(super.db);

  Future<void> saveEmail(EmailTableCompanion email) {
    return into(emailTable).insertOnConflictUpdate(email);
  }

  Future<EmailTableData?> getEmail() {
    return select(emailTable).getSingleOrNull();
  }

  Stream<EmailTableData?> watchEmail() {
    return select(emailTable).watchSingleOrNull();
  }
}