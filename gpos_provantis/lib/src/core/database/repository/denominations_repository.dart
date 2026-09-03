import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/denominations_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/denominations_dao_provider.dart';

import '../domain/denominations_dto.dart';

part 'denominations_repository.g.dart';

@Riverpod(keepAlive: true)
DenominationsRepository denominationsRepository(Ref ref) {
  final dao = ref.watch(denominationsDaoProvider);
  return DenominationsRepository(ref, dao);
}

class DenominationsRepository {
  final Ref _ref;
  final DenominationsDao _dao;

  DenominationsRepository(this._ref, this._dao);

  Future<void> fetchAndSaveDenominations() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post('/denomination/active');

    // debugPrint('Response: ${response.data}');

    final apiResponse =
        ApiResponseModel<List<DenominationsDto>>.fromDioResponse(
          response,
          fromJson: (data) => (data as List)
              .map((x) => DenominationsDto.fromJson(x as Map<String, dynamic>))
              .toList(),
        );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No denominations returned from server: ${apiResponse.responseMessage}',
      );
    }

    final denominations = records
        .map(
          (denomination) => DenominationsTableCompanion.insert(
            id: Value(denomination.id),
            code: Value(denomination.code),
            description: Value(denomination.description),
            value: Value(denomination.value),
            status: Value(denomination.status),
            createdBy: Value(denomination.createdBy),
            createdDate: Value(denomination.createdDate),
          ),
        )
        .toList();

    await _dao.replaceDenominations(denominations);
  }
}
