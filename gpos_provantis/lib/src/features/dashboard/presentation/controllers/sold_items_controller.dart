import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SoldItemsTableData;

import 'package:gpos_provantis/src/core/database/repository/sold_items_repository.dart';
import 'package:gpos_provantis/src/shared/widgets/toast_emitter.dart';

part 'sold_items_controller.g.dart';

/// Why the last fetch didn't refresh the data from the server.
enum SoldItemsFetchStatus {
  /// Nothing fetched yet for the current query.
  idle,

  /// A fetch is in progress.
  loading,

  /// Fetched from the server and saved; the list shows fresh data.
  fresh,

  /// Server unreachable; the list shows the previously saved copy.
  offlineCached,

  /// Server unreachable and nothing was ever saved for this query.
  offlineNoData,

  /// The server answered but the request failed (see [SoldItemsState.error]).
  failed,
}

@immutable
class SoldItemsState {
  const SoldItemsState({
    this.query,
    this.status = SoldItemsFetchStatus.idle,
    this.error,
    this.lastFetchedAt,
  });

  /// The query currently applied; null until the user taps Apply.
  final SoldItemsQuery? query;
  final SoldItemsFetchStatus status;
  final Object? error;

  /// When the rows now displayed were last fetched from the server.
  final DateTime? lastFetchedAt;

  bool get isLoading => status == SoldItemsFetchStatus.loading;

  bool get isShowingOfflineCopy =>
      status == SoldItemsFetchStatus.offlineCached ||
      status == SoldItemsFetchStatus.offlineNoData;

  SoldItemsState copyWith({
    SoldItemsQuery? query,
    SoldItemsFetchStatus? status,
    Object? error,
    bool clearError = false,
    DateTime? lastFetchedAt,
    bool clearLastFetchedAt = false,
  }) {
    return SoldItemsState(
      query: query ?? this.query,
      status: status ?? this.status,
      error: clearError ? null : (error ?? this.error),
      lastFetchedAt: clearLastFetchedAt
          ? null
          : (lastFetchedAt ?? this.lastFetchedAt),
    );
  }
}

/// Drives the Sold Items screen.
///
/// Flow when the user taps Apply:
///   1. [applyQuery] sets the query and asks the server for it.
///   2. The repository saves the response to the local DB.
///   3. The screen watches [soldItemsListProvider], which reads ONLY from the
///      local DB, so it updates automatically after the save.
///
/// If the server can't be reached, step 1-2 are skipped and the screen simply
/// shows whatever was saved earlier for that same query.
@riverpod
class SoldItemsController extends _$SoldItemsController {
  /// Incremented on every apply. A slow response for an old query must not
  /// overwrite the status of a newer one the user has since applied.
  int _requestId = 0;

  @override
  SoldItemsState build() => const SoldItemsState();

  /// Applies [query] and refreshes it from the server.
  Future<void> applyQuery(SoldItemsQuery query) async {
    state = SoldItemsState(query: query, status: SoldItemsFetchStatus.loading);
    await _fetch(query);
  }

  /// Re-fetches the currently applied query (pull-to-refresh / retry).
  Future<void> refresh() async {
    final query = state.query;
    if (query == null) return;
    state = state.copyWith(
      status: SoldItemsFetchStatus.loading,
      clearError: true,
    );
    await _fetch(query);
  }

  Future<void> _fetch(SoldItemsQuery query) async {
    final requestId = ++_requestId;
    final repository = ref.read(soldItemsRepositoryProvider);
    final toast = ref.read(toastEmitterProvider);

    SoldItemsState next;
    try {
      await repository.fetchAndSaveSoldItems(query);
      next = SoldItemsState(
        query: query,
        status: SoldItemsFetchStatus.fresh,
        lastFetchedAt: DateTime.now(),
      );
    } on DioException catch (e) {
      // Only connectivity-type failures fall back to the saved copy.
      debugPrint('SoldItems: server unreachable (${e.type}); using saved copy');
      final saved = await repository.getLocalSoldItems(query);
      if (saved.isEmpty) {
        next = SoldItemsState(
          query: query,
          status: SoldItemsFetchStatus.offlineNoData,
          error: e,
        );
      } else {
        next = SoldItemsState(
          query: query,
          status: SoldItemsFetchStatus.offlineCached,
          error: e,
          lastFetchedAt: DateTime.fromMillisecondsSinceEpoch(
            saved.first.fetchedAt,
          ),
        );
      }
    } catch (e, st) {
      debugPrint('SoldItems: fetch failed: $e\n$st');
      next = SoldItemsState(
        query: query,
        status: SoldItemsFetchStatus.failed,
        error: e,
      );
    }

    // A newer apply/refresh started while this one was in flight: drop this
    // result rather than overwrite the newer state.
    if (requestId != _requestId) return;
    state = next;

    // A normal load is silent; only tell the cashier when it didn't go well.
    switch (next.status) {
      case SoldItemsFetchStatus.offlineCached:
        toast.warning(
          'Could not reach the server. Showing sold items saved on this '
          'device.',
        );
      case SoldItemsFetchStatus.offlineNoData:
        toast.error(
          'Could not reach the server, and no sold items were saved for this '
          'search.',
        );
      case SoldItemsFetchStatus.failed:
        toast.error(
          'Could not load sold items: '
          '${next.error.toString().replaceFirst('Exception: ', '')}',
        );
      case SoldItemsFetchStatus.idle:
      case SoldItemsFetchStatus.loading:
      case SoldItemsFetchStatus.fresh:
        break;
    }
  }
}

/// The rows for the applied query, straight from the local DB.
///
/// The UI displays THIS, never the API response, so what's on screen is always
/// exactly what's stored on the device. Empty until a query has been applied.
///
/// Written as a manual provider on purpose. `SoldItemsTableData` is generated
/// by Drift, and riverpod_generator throws `InvalidTypeException` when a
/// @riverpod signature contains a type that another generator produces (see
/// rrousselGit/riverpod#4363 and #4370). The other providers in this file are
/// unaffected because their signatures only use hand-written types.
final soldItemsListProvider =
    StreamNotifierProvider<SoldItemsListNotifier, List<SoldItemsTableData>>(
      SoldItemsListNotifier.new,
    );

class SoldItemsListNotifier extends StreamNotifier<List<SoldItemsTableData>> {
  @override
  Stream<List<SoldItemsTableData>> build() {
    final query = ref.watch(soldItemsControllerProvider.select((s) => s.query));
    if (query == null) return Stream.value(const []);
    return ref.watch(soldItemsRepositoryProvider).watchSoldItems(query);
  }
}
