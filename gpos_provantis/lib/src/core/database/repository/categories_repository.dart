import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/categories_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';

import '../domain/categories_dto.dart';

part 'categories_repository.g.dart';

@Riverpod(keepAlive: true)
CategoriesRepository categoriesRepository(Ref ref) {
  final dao = ref.watch(categoriesDaoProvider);
  return CategoriesRepository(ref, dao);
}

class CategoriesRepository {
  final Ref _ref;
  final CategoriesDao _dao;

  CategoriesRepository(this._ref, this._dao);

  Future<void> fetchAndSaveCategories() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);

    late final Response response;
    try {
      response = await dio.get('/category/active');
    } on DioException catch (e) {
      debugPrint(
        '[CategoriesRepository] GET /category/active failed: '
        '${e.type} — ${e.message}',
      );
      if (e.response != null) {
        debugPrint(
          '[CategoriesRepository] Server responded with status '
          '${e.response?.statusCode}: ${e.response?.data}',
        );
      }
      rethrow;
    }

    debugPrint(
      '[CategoriesRepository] Raw response (status '
      '${response.statusCode}): ${response.data}',
    );

    late final ApiResponseModel<List<CategoriesDto>> apiResponse;
    try {
      apiResponse = ApiResponseModel<List<CategoriesDto>>.fromDioResponse(
        response,
        fromJson: (data) => (data as List)
            .map((x) => CategoriesDto.fromJson(x as Map<String, dynamic>))
            .toList(),
      );
    } catch (e, st) {
      debugPrint('[CategoriesRepository] Failed to parse response: $e');
      debugPrint('[CategoriesRepository] $st');
      rethrow;
    }

    debugPrint(
      '[CategoriesRepository] Parsed ${apiResponse.responseData?.length ?? 0} '
      'categories. responseMessage: ${apiResponse.responseMessage}',
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      debugPrint(
        '[CategoriesRepository] Empty result. Full raw body was: '
        '${response.data}',
      );
      throw Exception(
        'No categories returned from server: ${apiResponse.responseMessage}',
      );
    }

    final companions = records
        .map(
          (category) => CategoriesTableCompanion.insert(
            categoryCode: Value(category.categoryCode),
            categoryName: Value(category.categoryName),
            status: Value(category.status),
            createdBy: Value(category.createdBy),
            createdDate: Value(category.createdDate),
            isDisplay: Value(category.isDisplay),
          ),
        )
        .toList();

    await _dao.replaceCategories(companions);
  }
}
