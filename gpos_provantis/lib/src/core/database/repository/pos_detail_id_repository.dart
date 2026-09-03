import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_detail_id_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_detail_id_dao_provider.dart';

part 'pos_detail_id_repository.g.dart';

@Riverpod(keepAlive: true)
PosDetailIdRepository posDetailIdRepository(Ref ref) {
  final dao = ref.watch(posDetailIdDaoProvider);
  return PosDetailIdRepository(ref, dao);
}

class PosDetailIdRepository {
  final Ref _ref;
  final PosDetailIdDao _dao;

  PosDetailIdRepository(this._ref, this._dao);

  // Fetch the pos detail id from the API and save it to the database.
  // Server returns "data" as a plain string, e.g. {"msg":"success","data":"100012264"}
  // — not a list of objects — so no DTO/list mapping is needed here.
  Future<void> fetchAndSavePosDetailId() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final posConfigDao = _ref.read(posConfigDaoProvider);
    final posConfig = await posConfigDao.getPos();

    if (posConfig == null) {
      throw Exception('No pos config found — cannot resolve posId');
    }

    final response = await dio.post(
      '/salesdetails/getdetailid',
      data: {'posid': posConfig.posId},
    );

    debugPrint('PosDetailId: $response');

    final apiResponse = ApiResponseModel<String>.fromDioResponse(
      response,
      fromJson: (data) => data.toString(),
    );

    final detailId = apiResponse.responseData;
    if (detailId == null || detailId.isEmpty) {
      throw Exception(
        'No pos detail id returned from server: ${apiResponse.responseMessage}',
      );
    }

    final companion = PosDetailIdTableCompanion.insert(
      posDetailId: Value(detailId),
    );

    await _dao.savePosDetailId(companion);
  }
}
