import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/service_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/service_dao_provider.dart';

import '../domain/service_dto.dart';

part 'service_repository.g.dart';

@Riverpod(keepAlive: true)
ServiceRepository serviceRepository(Ref ref) {
  final dao = ref.watch(serviceDaoProvider);
  return ServiceRepository(ref, dao);
}

class ServiceRepository {
  final Ref _ref;
  final ServiceDao _dao;

  ServiceRepository(this._ref, this._dao);

  /// Fetches the active services from the server, replaces the local list and
  /// returns the saved rows.
  ///
  /// An empty list is valid (no active services) and clears the local copy, so
  /// a deactivated service can't stay sellable. Network failures
  /// ([DioException]) propagate; use [getLocalServices] for the offline
  /// fallback.
  Future<List<ServiceTableData>> fetchAndSaveServices() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/service/getactive',
      data: {'status': 'ACTIVE'},
    );

    final apiResponse = ApiResponseModel<List<ServiceDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => ServiceDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData ?? const <ServiceDto>[];

    await _dao.replaceServices([
      for (final r in records)
        ServiceTableCompanion.insert(
          id: Value(r.id),
          name: Value(r.name),
          price: Value(r.price),
          status: Value(r.status),
          createdBy: Value(r.createdBy),
          createdDate: Value(r.createdDate),
        ),
    ]);

    return _dao.getAllServices();
  }

  /// Locally stored services. No network call.
  Future<List<ServiceTableData>> getLocalServices() {
    return _dao.getAllServices();
  }
}
