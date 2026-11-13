import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/app_log_table.dart';

part 'app_log_dao.g.dart';

@DriftAccessor(tables: [AppLogTable])
class AppLogDao extends DatabaseAccessor<AppDatabase> with _$AppLogDaoMixin {
  AppLogDao(super.db);

  Future<void> add(AppLogTableCompanion entry) {
    return into(appLogTable).insert(entry);
  }

  /// Newest first.
  Stream<List<AppLogTableData>> watchLatest({int limit = 1000}) {
    return (select(appLogTable)
          ..orderBy([(t) => OrderingTerm.desc(t.id)])
          ..limit(limit))
        .watch();
  }

  Future<int> clear() => delete(appLogTable).go();

  /// Keeps the log small: drops entries older than [maxAge], then anything
  /// beyond the newest [keep]. Returns how many rows were removed.
  Future<int> prune({
    int keep = 5000,
    Duration maxAge = const Duration(days: 30),
  }) async {
    final cutoff = DateTime.now().subtract(maxAge);
    var removed = await (delete(
      appLogTable,
    )..where((t) => t.createdAt.isSmallerThanValue(cutoff))).go();

    final lastToKeep =
        await (select(appLogTable)
              ..orderBy([(t) => OrderingTerm.desc(t.id)])
              ..limit(1, offset: keep - 1))
            .getSingleOrNull();
    if (lastToKeep != null) {
      removed += await (delete(
        appLogTable,
      )..where((t) => t.id.isSmallerThanValue(lastToKeep.id))).go();
    }
    return removed;
  }
}
