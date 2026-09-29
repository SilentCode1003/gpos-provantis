import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// Cached result rows of the "sold items by date" report.
///
/// The server's answer depends on (dateRange, category filter, product
/// filter), so each row is stored WITH the query that produced it. That lets
/// the screen show exactly the rows for the filter the user applied, and lets
/// several different queries live in the cache side by side (so switching
/// filters offline still works for anything fetched before).
class SoldItemsTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  // --- the query that produced this row -----------------------------------
  /// "2026-09-28" for a single day, "2026-09-21 - 2026-09-28" for a range.
  TextColumn get dateRange => text()();

  /// Category filter as sent to the API. 'ALL' means no filter.
  TextColumn get categoryFilter => text().withDefault(const Constant('ALL'))();

  /// Product filter as sent to the API. 'ALL' means no filter.
  TextColumn get productFilter => text().withDefault(const Constant('ALL'))();

  /// When this row was fetched (epoch millis). Lets the UI say
  /// "Last updated ..." when showing offline data.
  IntColumn get fetchedAt => integer()();

  // --- the data itself ----------------------------------------------------
  TextColumn get branch => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get category =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get name => text().withDefault(const Constant('UNREGISTERED'))();
  IntColumn get quantity => integer().withDefault(const Constant(0))();

  @override
  Set<Column> get primaryKey => {id};

  /// Same product can't appear twice within one cached query.
  @override
  List<Set<Column>> get uniqueKeys => [
    {dateRange, categoryFilter, productFilter, branch, category, name},
  ];
}
