import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/denomination_dao.dart';

part 'denominations_dao_provider.g.dart';

@riverpod
DenominationDao denominationsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DenominationDao(db);
}

final denominationsProvider =
    StreamNotifierProvider<DenominationsNotifier, List<DenominationTableData>>(
      DenominationsNotifier.new,
    );

class DenominationsNotifier
    extends StreamNotifier<List<DenominationTableData>> {
  @override
  Stream<List<DenominationTableData>> build() {
    final dao = ref.watch(denominationsDaoProvider);
    return dao.watchAllDenominations();
  }
}
