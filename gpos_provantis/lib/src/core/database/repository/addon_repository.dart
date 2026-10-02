import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/addon_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/addon_dao_provider.dart';

import '../domain/addon_dto.dart';

part 'addon_repository.g.dart';

@Riverpod(keepAlive: true)
AddonRepository addonRepository(Ref ref) {
  final dao = ref.watch(addonDaoProvider);
  return AddonRepository(ref, dao);
}

class AddonRepository {
  final Ref _ref;
  final AddonDao _dao;

  AddonRepository(this._ref, this._dao);

  /// Fetches the active addons from the server, replaces the local list and
  /// returns the saved rows.
  ///
  /// An empty list is valid (no active addons) and clears the local copy, so a
  /// deactivated addon can't stay sellable. Network failures ([DioException])
  /// propagate; use [getLocalAddons] for the offline fallback.
  Future<List<AddonTableData>> fetchAndSaveAddons() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/addon/getactive',
      data: {'status': 'ACTIVE'},
    );

    final apiResponse = ApiResponseModel<List<AddonDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => AddonDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData ?? const <AddonDto>[];

    await _dao.replaceAddons([
      for (final r in records)
        AddonTableCompanion.insert(
          id: Value(r.id),
          name: Value(r.name),
          addonType: Value(r.type),
          price: Value(r.price),
          isProduct: Value(r.isProduct),
          status: Value(r.status),
          createdBy: Value(r.createdBy),
          createdDate: Value(r.createdDate),
        ),
    ]);

    return _dao.getAllAddons();
  }

  /// Locally stored addons. No network call.
  Future<List<AddonTableData>> getLocalAddons() {
    return _dao.getAllAddons();
  }
}
