import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';

import '../domain/pos_config_dto.dart';

part 'pos_config_repository.g.dart';

@Riverpod(keepAlive: true)
PosRepository posRepository(Ref ref) {
  final dao = ref.watch(posConfigDaoProvider);
  return PosRepository(ref, dao);
}

class PosRepository {
  final Ref _ref;
  final PosConfigDao _dao;

  PosRepository(this._ref, this._dao);

  /// Calls POST /pos/getposconfig with the given posId, and saves the
  /// first matching record to POSConfigTable. Throws on network/parse
  /// failure — callers (InitialSyncService) decide how to surface that.
  Future<void> fetchAndSavePos(String posId) async {
    // See BranchRepository.fetchAndSaveBranch for why this wait matters —
    // closes the brief window right after app restart where the domain
    // cache hasn't loaded from disk yet.
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/pos/getposconfig',
      data: {'posid': posId},
    );

    final apiResponse = ApiResponseModel<List<PosConfigDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PosConfigDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception('No POS config returned for posId "$posId".');
    }

    final pos = records.first;
    await _dao.savePos(
      POSConfigTableCompanion.insert(
        posId: Value(pos.posId),
        posName: Value(pos.posName),
        serial: Value(pos.serial),
        min: Value(pos.min),
        ptu: Value(pos.ptu),
        status: Value(pos.status),
        createdBy: Value(pos.createdBy),
        createdDate: Value(DateTime.tryParse(pos.createdDate) ?? DateTime.now()),
      ),
    );
  }
}