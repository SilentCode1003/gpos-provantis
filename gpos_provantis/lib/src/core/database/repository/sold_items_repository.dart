import 'package:dio/dio.dart';
import 'package:drift/drift.dart' show Value;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:flutter/foundation.dart';
import 'package:gpos_provantis/src/core/models/api_response_model.dart';
import 'package:gpos_provantis/src/core/network/api_client.dart';
import 'package:gpos_provantis/src/core/network/domain_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/sold_items_dao.dart';
import 'package:gpos_provantis/src/core/database/providers/sold_items_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';

import '../domain/sold_items_dto.dart';

part 'sold_items_repository.g.dart';

/// The value the API (and the local cache) uses for "no filter".
const String kSoldItemsAll = 'ALL';

/// How long a cached sold-items snapshot is kept, counted from when it was
/// last fetched. Older snapshots are deleted after the next successful fetch
/// to keep the device's storage small.
const Duration kSoldItemsRetention = Duration(days: 7);

/// Thrown when this device has no registered branch, so sold items can't be
/// requested (the API is scoped by branch).
class BranchNotConfiguredException implements Exception {
  const BranchNotConfiguredException(this.message);
  final String message;

  @override
  String toString() => 'BranchNotConfiguredException: $message';
}

/// One sold-items query: a date range plus optional category/product filters.
///
/// Immutable and comparable, so it can be used as a Riverpod family key and so
/// two identical queries always map to the same cached rows.
@immutable
class SoldItemsQuery {
  SoldItemsQuery({
    required DateTime startDate,
    DateTime? endDate,
    String? category,
    String? product,
  }) : dateRange = formatDateRange(startDate, endDate),
       category = _normalize(category),
       product = _normalize(product);

  /// "2026-09-28" for a single day, "2026-09-21 - 2026-09-28" for a range.
  final String dateRange;

  /// Category to show, or [kSoldItemsAll]. Applied on the device, not sent to
  /// the server (see [SoldItemsRepository.fetchAndSaveSoldItems]).
  final String category;

  /// Product to show, or [kSoldItemsAll]. Applied on the device, not sent to
  /// the server.
  final String product;

  /// Blank or null means "no filter" -> 'ALL'.
  static String _normalize(String? value) {
    final trimmed = value?.trim() ?? '';
    return trimmed.isEmpty ? kSoldItemsAll : trimmed;
  }

  /// Formats dates for the API. Both bounds are INCLUSIVE calendar days.
  /// If [end] is null or the same day as [start], a single date is produced;
  /// otherwise "start - end".
  static String formatDateRange(DateTime start, DateTime? end) {
    final s = _day(start);
    if (end == null) return s;
    final e = _day(end);
    return s == e ? s : '$s - $e';
  }

  static String _day(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }

  @override
  bool operator ==(Object other) =>
      other is SoldItemsQuery &&
      other.dateRange == dateRange &&
      other.category == category &&
      other.product == product;

  @override
  int get hashCode => Object.hash(dateRange, category, product);

  @override
  String toString() =>
      'SoldItemsQuery(dateRange: $dateRange, category: $category, '
      'product: $product)';
}

@Riverpod(keepAlive: true)
SoldItemsRepository soldItemsRepository(Ref ref) {
  final dao = ref.watch(soldItemsDaoProvider);
  return SoldItemsRepository(ref, dao);
}

class SoldItemsRepository {
  final Ref _ref;
  final SoldItemsDao _dao;

  SoldItemsRepository(this._ref, this._dao);

  /// Fetches the sold items for [query]'s date range and stores them locally,
  /// replacing everything previously cached for that range.
  ///
  /// The category/product filters are deliberately NOT sent: the server
  /// answers a filter with every product anyway (zeroing the ones that don't
  /// match), so filtering server-side saves nothing. Fetching the whole range
  /// once and filtering on the device keeps one copy of each product per date
  /// range, and lets any filter be shown offline once the range is cached.
  ///
  /// Returns the number of rows saved. An empty result is valid (nothing sold
  /// in that range) and clears the cache for that range. Network failures
  /// ([DioException]) propagate so the caller can decide to fall back to the
  /// cache; anything else means the server answered with something unusable.
  Future<int> fetchAndSaveSoldItems(SoldItemsQuery query) async {
    await _ref.read(domainConfigDaoProvider).cacheReady;

    // Read from local config, so this works offline. If it fails we stop here
    // instead of sending a request the server can't scope to a branch.
    final branchId = await _resolveBranchId();

    final dio = _ref.read(apiClientProvider);
    final response = await dio.post(
      '/mobile-api/get-solditems-by-date',
      data: {
        'branch': branchId,
        'daterange': query.dateRange,
        'category': kSoldItemsAll,
        'productname': kSoldItemsAll,
      },
    );

    debugPrint('SoldItems API response: ${response.data}');

    final apiResponse = ApiResponseModel<List<SoldItemsDto>>.fromDioResponse(
      response,
      fromJson: (data) => (data as List)
          .map((x) => SoldItemsDto.fromJson(x as Map<String, dynamic>))
          .toList(),
    );

    final dtos = apiResponse.responseData;
    if (dtos == null) {
      // No data list at all (as opposed to an empty one) means the server
      // reported a problem rather than "nothing sold".
      throw Exception(
        'Sold items request failed: ${apiResponse.responseMessage}',
      );
    }

    final now = DateTime.now().millisecondsSinceEpoch;
    final rows = dtos
        .map(
          (dto) => SoldItemsTableCompanion.insert(
            dateRange: query.dateRange,
            fetchedAt: now,
            branch: Value(dto.branch),
            category: Value(dto.category),
            name: Value(dto.name),
            quantity: Value(dto.quantity),
          ),
        )
        .toList();

    await _dao.replaceSnapshot(dateRange: query.dateRange, rows: rows);

    await _pruneOldSnapshots();

    return rows.length;
  }

  /// Deletes snapshots last fetched more than [kSoldItemsRetention] ago.
  ///
  /// Runs only after a successful fetch-and-save, which means:
  ///  - the snapshot just written (fetched "now") can never be removed, and
  ///  - it never runs while offline, so a device without connectivity keeps
  ///    whatever it has instead of losing its only copy.
  ///
  /// A failure here is logged and ignored: the fetch itself already succeeded,
  /// and pruning will simply be retried after the next one.
  Future<void> _pruneOldSnapshots() async {
    try {
      final cutoff = DateTime.now().subtract(kSoldItemsRetention);
      final removed = await _dao.deleteOlderThan(cutoff);
      if (removed > 0) {
        debugPrint(
          'SoldItems: pruned $removed cached rows older than '
          '${kSoldItemsRetention.inDays} days',
        );
      }
    } catch (e, st) {
      debugPrint('SoldItems: cache pruning failed: $e\n$st');
    }
  }

  /// The branch this device is registered to (from local config).
  Future<String> _resolveBranchId() async {
    final branch = await _ref.read(branchConfigDaoProvider).getBranch();
    final branchId = branch?.branchId;
    if (branchId == null || branchId.isEmpty || branchId == 'UNREGISTERED') {
      throw const BranchNotConfiguredException(
        'No branch is configured on this device. Run branch setup before '
        'loading sold items.',
      );
    }
    return branchId;
  }

  /// Live view of the locally stored rows for [query]. This is what the UI
  /// displays; it re-emits after every [fetchAndSaveSoldItems].
  Stream<List<SoldItemsTableData>> watchSoldItems(SoldItemsQuery query) {
    return _dao
        .watchSnapshot(query.dateRange)
        .map((rows) => _matchingRows(rows, query));
  }

  Future<List<SoldItemsTableData>> getLocalSoldItems(
    SoldItemsQuery query,
  ) async {
    final rows = await _dao.getSnapshot(query.dateRange);
    return _matchingRows(rows, query);
  }

  /// Keeps only the rows that match the query's category/product. The cache
  /// holds the whole date range, so this is where the filters take effect.
  ///
  /// Comparison ignores case and surrounding spaces. [kSoldItemsAll] means
  /// "no filter" and matches everything.
  List<SoldItemsTableData> _matchingRows(
    List<SoldItemsTableData> rows,
    SoldItemsQuery query,
  ) {
    if (query.category == kSoldItemsAll && query.product == kSoldItemsAll) {
      return rows;
    }

    bool same(String a, String b) =>
        a.trim().toLowerCase() == b.trim().toLowerCase();

    return rows.where((row) {
      final categoryOk =
          query.category == kSoldItemsAll || same(row.category, query.category);
      final productOk =
          query.product == kSoldItemsAll || same(row.name, query.product);
      return categoryOk && productOk;
    }).toList();
  }
}
