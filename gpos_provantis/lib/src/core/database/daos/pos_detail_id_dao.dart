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

  Future<void> savePosDetailId(Insertable<PosDetailIdTableData> posDetailId) {
    return into(posDetailIdTable).insertOnConflictUpdate(posDetailId);
  }

  Future<PosDetailIdTableData?> getPosDetailId() {
    return select(posDetailIdTable).getSingleOrNull();
  }

  Stream<PosDetailIdTableData?> watchPosDetailId() {
    return select(posDetailIdTable).watchSingleOrNull();
  }

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
