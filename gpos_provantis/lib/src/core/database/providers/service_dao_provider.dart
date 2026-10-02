import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/service_dao.dart';

part 'service_dao_provider.g.dart';

@Riverpod(keepAlive: true)
ServiceDao serviceDao(Ref ref) {
  final db = ref.watch(appDatabaseProvider);
  return ServiceDao(db);
}

final servicesProvider =
    StreamNotifierProvider<ServicesNotifier, List<ServiceTableData>>(
      ServicesNotifier.new,
    );

class ServicesNotifier extends StreamNotifier<List<ServiceTableData>> {
  @override
  Stream<List<ServiceTableData>> build() {
    final dao = ref.watch(serviceDaoProvider);
    return dao.watchAllServices();
  }
}
