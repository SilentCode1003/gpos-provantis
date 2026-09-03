import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_detail_id_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_detail_id_dao_provider.dart';

import '../domain/pos_detail_id_dto.dart';

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
  Future<void> fetchAndSavePosDetailId() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post('/posshiftlog/getposshift');

    final apiResponse = ApiResponseModel<List<PosDetailDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PosDetailDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No pos detail id returned from server: ${apiResponse.responseMessage}',
      );
    }

    final detail = records.first;

    final companion = PosDetailIdTableCompanion.insert(
      posDetailId: Value(detail.posDetailId),
    );

    await _dao.savePosDetailId(companion);
  }
}
