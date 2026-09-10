import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/promo_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/promo_dao_provider.dart';

import '../domain/promo_dto.dart';

part 'promo_repository.g.dart';

@Riverpod(keepAlive: true)
PromoRepository promoRepository(Ref ref) {
  final dao = ref.watch(promoDaoProvider);
  return PromoRepository(ref, dao);
}

class PromoRepository {
  final Ref _ref;
  final PromoDao _dao;

  PromoRepository(this._ref, this._dao);

  // Fetch promos from the API and save them to the database.
  Future<void> fetchAndSavePromos() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post('/promo/getactive');
    final apiResponse = ApiResponseModel<List<PromoDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => PromoDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null) {
      // Missing/malformed responseData is a real problem (bad response
      // shape, parsing didn't produce a list at all) — still an error.
      throw Exception(
        'No promos returned from server: ${apiResponse.responseMessage}',
      );
    }

    if (records.isEmpty) {
      await _dao.replacePromos(const []);
      return;
    }

    final companions = records
        .map(
          (promo) => PromoTableCompanion.insert(
            promoId: Value(promo.promoId),
            name: Value(promo.name),
            description: Value(promo.description),
            condition: Value(promo.condition),
            startDate: Value(promo.startDate),
            endDate: Value(promo.endDate),
            status: Value(promo.status),
            createdBy: Value(promo.createdBy),
            createdDate: Value(promo.createdDate),
          ),
        )
        .toList();

    await _dao.replacePromos(companions);
  }
}
