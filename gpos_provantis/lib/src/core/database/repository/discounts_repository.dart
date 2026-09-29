import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/discounts_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/discounts_dao_provider.dart';

import '../domain/discounts_dto.dart';

part 'discounts_repository.g.dart';

@Riverpod(keepAlive: true)
DiscountsRepository discountsRepository(Ref ref) {
  final dao = ref.watch(discountsDaoProvider);
  return DiscountsRepository(ref, dao);
}

class DiscountsRepository {
  final Ref _ref;
  final DiscountsDao _dao;

  DiscountsRepository(this._ref, this._dao);

  Future<void> fetchAndSaveDiscounts() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post('discount/getactive');

    final apiResponse = ApiResponseModel<List<DiscountsDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => DiscountsDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No discounts returned from server: ${apiResponse.responseMessage}',
      );
    }

    final discounts = records
        .map(
          (discount) => DiscountsTableCompanion.insert(
            discountId: Value(discount.discountId),
            name: Value(discount.name),
            description: Value(discount.description),
            rate: Value(discount.rate),
            status: Value(discount.status),
            createdBy: Value(discount.createdBy),
            createdDate: Value(discount.createdDate),
          ),
        )
        .toList();

    await _dao.replaceDiscounts(discounts);
  }
}
