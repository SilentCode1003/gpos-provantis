import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/pos_detail_id_table.dart';

part 'pos_detail_id_dao.g.dart';

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

  // Saves the current POS detail ID in local storage.
  // Keeps the latest remote value ready for the next sale.
  Future<void> savePosDetailId(Insertable<PosDetailIdTableData> posDetailId) {
    return into(posDetailIdTable).insertOnConflictUpdate(posDetailId);
  }

  // Reads the stored POS detail ID from local storage.
  // Returns null when the app has not synced one yet.
  Future<PosDetailIdTableData?> getPosDetailId() {
    return select(posDetailIdTable).getSingleOrNull();
  }

  // Watches the POS detail ID value for live updates.
  // Useful for any screen that needs the newest detail ID.
  Stream<PosDetailIdTableData?> watchPosDetailId() {
    return select(posDetailIdTable).watchSingleOrNull();
  }

  // Consumes the current detail ID and advances it for the next use.
  // This keeps sequential sale IDs monotonic and safe.
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

      final lastUsed = int.tryParse(rawValue);
      if (lastUsed == null) {
        throw PosDetailIdUnavailableException(
          'Stored detail ID "$rawValue" is not a valid integer.',
        );
      }

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
