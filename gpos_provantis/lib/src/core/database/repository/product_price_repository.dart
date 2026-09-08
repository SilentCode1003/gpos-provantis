import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/product_price_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/categories_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';

import '../domain/product_price_dto.dart';

part 'product_price_repository.g.dart';

@Riverpod(keepAlive: true)
ProductPriceRepository productPriceRepository(Ref ref) {
  final productPriceDao = ref.watch(productPriceDaoProvider);
  final categoriesDao = ref.watch(categoriesDaoProvider);
  return ProductPriceRepository(ref, productPriceDao, categoriesDao);
}

class ProductPriceRepository {
  final Ref _ref;
  final ProductPriceDao _dao;
  final CategoriesDao _categoriesDao;

  ProductPriceRepository(this._ref, this._dao, this._categoriesDao);

  // Fetch product prices from the API, one category at a time, and save
  // the combined result to the database.
  //
  // Mirrors v1's getProductPrice(): the endpoint only accepts a single
  // category per request, so this loops over every locally-synced category
  // (via CategoriesDao — must be populated first, e.g. by calling
  // fetchAndSaveCategories() beforehand) and merges all results before
  // doing a single replace at the end.
  //
  // The 'Material' category is intentionally skipped, matching v1 behavior.
  Future<void> fetchAndSaveProductPrices() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final branchConfigDao = _ref.read(branchConfigDaoProvider);
    final branchId = await branchConfigDao.getBranch();

    if (branchId == null) {
      throw Exception(
        'No branch config found locally — fetchAndSaveBranchConfig() must run before fetchAndSaveProductPrices().',
      );
    }

    final categories = await _categoriesDao.getAllCategories();
    if (categories.isEmpty) {
      throw Exception(
        'No categories found locally — fetchAndSaveCategories() must run before fetchAndSaveProductPrices().',
      );
    }

    final allRecords = <ProductPriceDto>[];

    // v1 also filters out rows belonging to the 'Material' category from
    // each response (defensive, since that category is never requested
    // above either) — cross-reference by code since ProductPriceDto only
    // carries the category code, not its name.
    final materialCategoryCodes = categories
        .where((c) => c.categoryName == 'Material')
        .map((c) => c.categoryCode)
        .toSet();

    for (final category in categories) {
      if (category.categoryName == 'Material') {
        continue;
      }

      final requestBody = {
        'category': category.categoryCode.toString(),
        'branchid': branchId.branchId,
      };
      // debugPrint('Request body: $requestBody');
      // debugPrint('Request body length: ${requestBody.toString().length}');

      final response = await dio.post(
        '/productprice/getcategory',
        data: requestBody,
      );

      // debugPrint('ProductPrice (${category.categoryCode}): $response');

      final apiResponse =
          ApiResponseModel<List<ProductPriceDto>>.fromDioResponse(
            response,
            fromJson: (data) => (data as List)
                .map((x) => ProductPriceDto.fromJson(x as Map<String, dynamic>))
                .toList(),
          );

      final records = apiResponse.responseData;
      if (records == null) {
        debugPrint(
          'No product prices for category ${category.categoryCode}: ${apiResponse.responseMessage}',
        );
        continue;
      }

      // v1 also filters out 'Material'-category rows within the response itself.
      allRecords.addAll(
        records.where((r) => !materialCategoryCodes.contains(r.category)),
      );
    }

    if (allRecords.isEmpty) {
      throw Exception(
        'No product prices returned from server for any category.',
      );
    }

    // Confirmed against ProductPriceDto/ProductPriceTable: all fields match directly.
    final companions = allRecords
        .map(
          (price) => ProductPriceTableCompanion.insert(
            productId: Value(price.productId),
            description: Value(price.description),
            barcode: Value(price.barcode),
            price: Value(price.price),
            category: Value(price.category),
            quantity: Value(price.quantity),
          ),
        )
        .toList();

    await _dao.replaceProductPrices(companions);
  }
}
