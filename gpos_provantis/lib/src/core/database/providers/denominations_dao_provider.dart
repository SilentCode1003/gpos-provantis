import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/denominations_dao.dart';

part 'denominations_dao_provider.g.dart';

@riverpod
DenominationsDao denominationsDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return DenominationsDao(db);
}

final denominationsProvider =
    StreamNotifierProvider<DenominationsNotifier, List<DenominationsTableData>>(
      DenominationsNotifier.new,
    );

class DenominationsNotifier
    extends StreamNotifier<List<DenominationsTableData>> {
  @override
  Stream<List<DenominationsTableData>> build() {
    final dao = ref.watch(denominationsDaoProvider);
    return dao.watchAllDenominations();
  }
}
