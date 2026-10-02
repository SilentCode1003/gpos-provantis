import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/addon_dao.dart';

part 'addon_dao_provider.g.dart';

@Riverpod(keepAlive: true)
AddonDao addonDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return AddonDao(db);
}

final addonsProvider =
    StreamNotifierProvider<AddonsNotifier, List<AddonTableData>>(
      AddonsNotifier.new,
    );

class AddonsNotifier extends StreamNotifier<List<AddonTableData>> {
  @override
  Stream<List<AddonTableData>> build() {
    final dao = ref.watch(addonDaoProvider);
    return dao.watchAllAddons();
  }
}
