import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_detail_id_table.dart';

part 'pos_detail_id_dao.g.dart';

/// Thrown by [PosDetailIdDao.consumeAndIncrementDetailId] when there is no
/// usable detail ID to hand out yet — either the table has never been
/// populated (fresh install, never synced with the server) or it still
/// holds the table's literal `'UNREGISTERED'` default. A sale must not be
/// created in this state: inventing a starting number locally risks
/// colliding with whatever sequence the server is actually on.
class PosDetailIdUnavailableException implements Exception {
  const PosDetailIdUnavailableException(this.message);
  final String message;

  @override
  String toString() => 'PosDetailIdUnavailableException: $message';
}

@DriftAccessor(tables: [PosDetailIdTable])
class PosDetailIdDao extends DatabaseAccessor<AppDatabase>
    with _$PosDetailIdDaoMixin {
  PosDetailIdDao(super.db);

  Future<void> savePosDetailId(Insertable<PosDetailIdTableData> posDetailId) {
    return into(posDetailIdTable).insertOnConflictUpdate(posDetailId);
  }

  Future<PosDetailIdTableData?> getPosDetailId() {
    return select(posDetailIdTable).getSingleOrNull();
  }

  Stream<PosDetailIdTableData?> watchPosDetailId() {
    return select(posDetailIdTable).watchSingleOrNull();
  }

  /// Atomically reads the last detail ID that was used, increments it by
  /// 1 to get *this* sale's ID, persists that incremented value back as
  /// the new "last used" (so the sale after this one increments from
  /// it in turn), and returns it — all inside one Drift transaction so
  /// two sales created back-to-back (e.g. rapid taps on a touchscreen)
  /// can never both compute the same next value.
  ///
  /// The stored value always means "the last detail ID actually used"
  /// — never "the next one to hand out". This matters because it's also
  /// what `PosDetailIdRepository.fetchAndSavePosDetailId()` writes after
  /// pulling from the server: the server's `getdetailid` response is
  /// likewise the last-used ID, not a pre-reserved next one, so this
  /// method's own +1 step is what turns it into a usable ID for a new
  /// sale in both cases (local-only and just-synced).
  ///
  /// This never talks to the server. The stored value is only ever set
  /// by [savePosDetailId] (server pull / manual reconciliation) or
  /// incremented here (local sale creation) — see the sales-flow spec.
  ///
  /// Throws [PosDetailIdUnavailableException] if there's no row yet, or
  /// the row still holds the table's `'UNREGISTERED'` default, or the
  /// stored value isn't a parseable integer.
  Future<String> consumeAndIncrementDetailId() {
    return transaction(() async {
      final row = await getPosDetailId();
      final rawValue = row?.posDetailId;

      if (rawValue == null || rawValue == 'UNREGISTERED') {
        throw const PosDetailIdUnavailableException(
          'No detail ID has been synced from the server yet — cannot '
          'create a sale until at least one sync has completed.',
        );
      }

      // NOTE: the server's detail ID is currently a plain zero-padded
      // numeric string (e.g. "100000012") — no prefix. If a prefixed
      // format (e.g. "POS1000012") is ever introduced, this needs to
      // change to split off the non-numeric prefix before parsing and
      // re-attach it after formatting; it does NOT handle that today.
      final lastUsed = int.tryParse(rawValue);
      if (lastUsed == null) {
        throw PosDetailIdUnavailableException(
          'Stored detail ID "$rawValue" is not a valid integer.',
        );
      }

      // Preserve the original string's zero-padding width — "100000012"
      // (9 chars) must increment to "100000013" (still 9 chars), not
      // silently lose leading zeros. If the increment pushes the number
      // to one more digit than the original width (e.g. "999999999" ->
      // "1000000000"), the extra digit is kept rather than truncated —
      // padding only ever adds zeros, it never cuts digits off a real
      // number.
      final newDetailId = (lastUsed + 1).toString().padLeft(
        rawValue.length,
        '0',
      );
      await savePosDetailId(
        PosDetailIdTableCompanion.insert(posDetailId: Value(newDetailId)),
      );

      return newDetailId;
    });
  }
}
