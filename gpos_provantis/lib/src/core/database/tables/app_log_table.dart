import 'package:drift/drift.dart';

/// One line of the developer log: something important that happened in the
/// app (an upload the server refused, a crash, a clean-up that changed data).
/// Shown on Settings > Developer. Written through `AppLogger`, never directly.
class AppLogTable extends Table {
  IntColumn get id => integer().autoIncrement()();

  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();

  /// `INFO`, `WARN` or `ERROR`.
  TextColumn get level => text()();

  /// Where it came from, e.g. `sales.upload`.
  TextColumn get source => text()();

  TextColumn get message => text()();

  /// The receipt (OR) number this entry is about, so a transaction can be
  /// searched by its number.
  TextColumn get detailId => text().nullable()();

  /// JSON with the details (status code, server reply, the sale's amounts).
  TextColumn get context => text().nullable()();

  TextColumn get stackTrace => text().nullable()();
}
