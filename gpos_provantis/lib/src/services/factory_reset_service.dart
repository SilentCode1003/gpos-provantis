import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'pos_restart_service.dart';

class FactoryResetException implements Exception {
  const FactoryResetException(this.message);

  final String message;

  @override
  String toString() => message;
}

/// Wipes all local data, then restarts the app so it comes back up in a
/// first-launch state.
class FactoryResetService {
  FactoryResetService(this._ref);

  final Ref _ref;

  Future<void> resetAndRestart() async {
    // 1. Erase every row. If this throws, nothing is restarted.
    await _ref.read(appDatabaseProvider).wipeAllData();

    // 2. Restart only after the wipe succeeded. On success the process is
    //    replaced and this future never completes; if we get a result back,
    //    the restart did not happen.
    final result = await _ref.read(posRestartServiceProvider).restart();

    throw FactoryResetException(
      'Data was erased, but the app could not restart '
      '(${result.message ?? result.code ?? 'unknown error'}). '
      'Please close and reopen the app manually.',
    );
  }
}

final factoryResetServiceProvider = Provider<FactoryResetService>(
  FactoryResetService.new,
);
