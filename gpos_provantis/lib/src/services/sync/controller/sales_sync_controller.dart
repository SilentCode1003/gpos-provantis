import 'dart:async';

import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/repository/sales_repository.dart';

part 'sales_sync_controller.g.dart';

const salesSyncInterval = Duration(seconds: 30);

enum SalesSyncStatus { idle, syncing, failed }

class SalesSyncState {
  const SalesSyncState({
    this.status = SalesSyncStatus.idle,
    this.lastError,
    this.lastRunAt,
    this.lastSyncedCount = 0,
  });

  final SalesSyncStatus status;

  final String? lastError;

  final DateTime? lastRunAt;

  final int lastSyncedCount;

  SalesSyncState copyWith({
    SalesSyncStatus? status,
    String? lastError,
    bool clearError = false,
    DateTime? lastRunAt,
    int? lastSyncedCount,
  }) {
    return SalesSyncState(
      status: status ?? this.status,
      lastError: clearError ? null : (lastError ?? this.lastError),
      lastRunAt: lastRunAt ?? this.lastRunAt,
      lastSyncedCount: lastSyncedCount ?? this.lastSyncedCount,
    );
  }
}

@Riverpod(keepAlive: true)
class SalesSyncController extends _$SalesSyncController {
  Timer? _timer;

  @override
  SalesSyncState build() {
    debugPrint('SalesSyncController: starting (interval=$salesSyncInterval)');

    ref.onDispose(() {
      debugPrint('SalesSyncController: disposed, timer cancelled');
      _timer?.cancel();
    });

    _timer = Timer.periodic(salesSyncInterval, (_) {
      debugPrint('SalesSyncController: timer tick');
      _runOnce();
    });

    Future.microtask(_runOnce);

    return const SalesSyncState();
  }

  Future<void> _runOnce() async {
    if (state.status == SalesSyncStatus.syncing) {
      debugPrint('SalesSyncController: skipped — a pass is already running');

      return;
    }

    state = state.copyWith(
      status: SalesSyncStatus.syncing,
      clearError: true,
      lastRunAt: DateTime.now(),
    );

    try {
      final syncedCount = await ref.read(salesRepositoryProvider).uploadSales();
      state = state.copyWith(
        status: SalesSyncStatus.idle,
        lastSyncedCount: syncedCount,
      );
    } catch (error) {
      state = state.copyWith(
        status: SalesSyncStatus.failed,
        lastError: error.toString(),
      );
    }
  }

  Future<void> syncNow() => _runOnce();
}
