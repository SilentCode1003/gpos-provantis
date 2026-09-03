import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/product_price_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';

import '../domain/product_price_dto.dart';

part 'product_price_repository.g.dart';

@Riverpod(keepAlive: true)
ProductPriceRepository productPriceRepository(Ref ref) {
  final dao = ref.watch(productPriceDaoProvider);
  return ProductPriceRepository(ref, dao);
}

class ProductPriceRepository {
  final Ref _ref;
  final ProductPriceDao _dao;

  ProductPriceRepository(this._ref, this._dao);

  // Fetch product prices from the API and save them to the database.
  Future<void> fetchAndSaveProductPrices() async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post('/productprice/getcategory');

    final apiResponse = ApiResponseModel<List<ProductPriceDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => ProductPriceDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final records = apiResponse.responseData;
    if (records == null || records.isEmpty) {
      throw Exception(
        'No product prices returned from server: ${apiResponse.responseMessage}',
      );
    }

    // TODO: confirm ProductPriceTableCompanion field names match ProductPriceDto fields
    final companions = records
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
