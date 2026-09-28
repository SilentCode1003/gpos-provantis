import 'package:drift/drift.dart';
import 'package:uuid/uuid.dart';

/// A queue of cash-drawer activities to send to the server.
///
/// Every write to this table happens BEFORE the matching API call, never
/// after: the app always has a local record of what it intended to send,
/// even if it never got a chance to send it (no connectivity, app killed
/// mid-request, etc). [synced] is flipped to true only once the server has
/// confirmed the request, so a crash or connectivity loss between saving and
/// sending just leaves the row queued for the next retry.
///
/// [id] is a client-generated UUID and is NEVER sent to the server — it only
/// exists so the same row can be looked up again after insert and so retries
/// don't create a second local copy of an activity that's already queued.
class CashDrawerTable extends Table {
  TextColumn get id => text().clientDefault(() => const Uuid().v4())();

  TextColumn get shift => text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get cashier =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get shiftDate =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get branchId =>
      text().withDefault(const Constant('UNREGISTERED'))();
  TextColumn get posId => text().withDefault(const Constant('UNREGISTERED'))();

  /// The exact JSON string the server expects for the `denomination` field
  /// (already `jsonEncode`d — the API takes a JSON-encoded STRING, not a
  /// nested array). Stored pre-encoded so what gets sent is byte-for-byte
  /// what was queued, with no re-serialization step that could drift from it.
  TextColumn get denomination => text().withDefault(const Constant('[]'))();

  /// 'endshift' or 'transaction'. Named `activity` to match the API's own
  /// field name, even though it also fires at start shift (the server calls
  /// both open-shift and close-shift traffic 'endshift').
  TextColumn get activity =>
      text().withDefault(const Constant('UNREGISTERED'))();

  /// When this row was queued (epoch millis). Used to send activities to the
  /// server in the order they happened.
  IntColumn get queuedAt => integer()();

  /// True once the server has confirmed this activity. Unsynced rows are what
  /// gets retried; synced rows are kept as a local audit trail.
  BoolColumn get synced => boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};
}
