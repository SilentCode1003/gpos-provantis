import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../core/database/app_database.dart';
import '../domain/users_model.dart';

part 'users_repository.g.dart';

class UsersRepository {
  final AppDatabase _db;

  UsersRepository(this._db);

  // 1. READ (Now a Stream instead of a Future)
  Stream<List<UsersModel>> watchUsers() {
    return _db
        .select(_db.usersTable)
        .watch()
        .map(
          (rows) => rows
              .map(
                (row) => UsersModel(
                  id: row.id,
                  empId: row.empId,
                  username: row.username,
                  password: row.password,
                  createdBy: row.createdBy,
                  updatedBy: row.updatedBy,
                  createdAt: row.createdAt,
                  updatedAt: row.updatedAt,
                  isActive: row.isActive,
                ),
              )
              .toList(),
        );
  }

  // 2. CREATE
  Future<void> insertUser(UsersModel user) async {
    await _db
        .into(_db.usersTable)
        .insert(
          UsersTableCompanion.insert(
            // If the UI sends an empty ID, let Drift generate it!
            id: user.id.isEmpty ? const Value.absent() : Value(user.id),
            empId: user.empId,
            username: user.username,
            password: user.password,
            createdBy: user.createdBy,
            updatedBy: user.updatedBy,

            // Let Drift generate the timestamps for new entries
            createdAt: const Value.absent(),
            updatedAt: const Value.absent(),
            isActive: Value(user.isActive),
          ),
        );
  }

  // 3. UPDATE
  Future<void> updateUser(UsersModel user) async {
    await _db
        .update(_db.usersTable)
        .replace(
          UsersTableCompanion(
            id: Value(user.id), // Primary Key determines which row updates
            empId: Value(user.empId),
            username: Value(user.username),
            password: Value(user.password),
            createdBy: Value(user.createdBy),
            updatedBy: Value(user.updatedBy),
            createdAt: Value(user.createdAt),
            // Optionally, update the timestamp here if you want to track edits:
            // updatedAt: Value(DateTime.now().toUtc().toIso8601String()),
            updatedAt: Value(user.updatedAt),
            isActive: Value(user.isActive),
          ),
        );
  }

  // 4. DELETE
  Future<void> deleteUser(String id) async {
    await (_db.delete(_db.usersTable)..where((tbl) => tbl.id.equals(id))).go();
  }
}

@riverpod
UsersRepository usersRepository(Ref ref) {
  return UsersRepository(ref.watch(appDatabaseProvider));
}
