import 'package:flutter/foundation.dart' show debugPrint;
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:gpos_provantis/src/core/database/app_database.dart';
import 'package:gpos_provantis/src/core/database/daos/branch_config_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_config_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/pos_shift_dao.dart';
import 'package:gpos_provantis/src/core/database/daos/user_data_dao.dart';
import 'package:gpos_provantis/src/core/database/domain/cash_drop_dto.dart';
import 'package:gpos_provantis/src/core/database/providers/branch_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_config_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/pos_shift_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/user_data_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/repository/cash_drop_repository.dart';
import 'package:gpos_provantis/src/core/printutil/cash_drop_generator.dart';

part 'cash_drop_service.g.dart';

/// The drop itself is invalid (nothing counted).
class CashDropException implements Exception {
  const CashDropException(this.message);
  final String message;

  @override
  String toString() => 'CashDropException: $message';
}

/// The device doesn't know who/where it is yet (no user, branch, POS or shift),
/// so the drop can't be attributed.
class CashDropIdentityException implements Exception {
  const CashDropIdentityException(this.message);
  final String message;

  @override
  String toString() => 'CashDropIdentityException: $message';
}

/// Result of recording a drop. The drop is saved even if printing failed, so a
/// print problem is carried here instead of thrown: the UI can say "recorded,
/// but the slip didn't print" and offer a reprint.
class CashDropOutcome {
  const CashDropOutcome({required this.record, this.printError});

  final CashDropTableData record;

  /// Set only when the drop was saved but the slip did not print.
  final Object? printError;

  bool get printed => printError == null;
}

class _Identity {
  const _Identity({
    required this.posId,
    required this.shift,
    required this.cashierId,
    required this.cashierName,
    required this.branchId,
    required this.businessDate,
  });

  final String posId;
  final String shift;
  final String cashierId;
  final String cashierName;
  final String branchId;
  final String businessDate;
}

@Riverpod(keepAlive: true)
CashDropService cashDropService(Ref ref) {
  return CashDropService(
    repository: ref.watch(cashDropRepositoryProvider),
    generator: ref.watch(cashDropGeneratorProvider),
    posConfigDao: ref.watch(posConfigDaoProvider),
    posShiftDao: ref.watch(posShiftDaoProvider),
    userDao: ref.watch(userDataDaoProvider),
    branchDao: ref.watch(branchConfigDaoProvider),
  );
}

class CashDropService {
  CashDropService({
    required CashDropRepository repository,
    required CashDropGenerator generator,
    required PosConfigDao posConfigDao,
    required PosShiftDao posShiftDao,
    required UserDataDao userDao,
    required BranchConfigDao branchDao,
  }) : _repository = repository,
       _generator = generator,
       _posConfigDao = posConfigDao,
       _posShiftDao = posShiftDao,
       _userDao = userDao,
       _branchDao = branchDao;

  final CashDropRepository _repository;
  final CashDropGenerator _generator;
  final PosConfigDao _posConfigDao;
  final PosShiftDao _posShiftDao;
  final UserDataDao _userDao;
  final BranchConfigDao _branchDao;

  /// Records a cash drop and prints its slip.
  ///
  /// 1. Works out who/where (cashier, branch, POS, shift, business date).
  /// 2. Saves the drop on this device. From here it can't be lost.
  /// 3. Tries to hand it to the server (a placeholder until there is an API;
  ///    it never blocks or fails the drop).
  /// 4. Prints the slip. A print failure is reported on the returned
  ///    [CashDropOutcome], not thrown.
  ///
  /// Throws [CashDropException] for an empty drop and
  /// [CashDropIdentityException] if the device isn't set up.
  Future<CashDropOutcome> recordCashDrop({
    required List<CashDropLineDto> lines,
  }) async {
    final dropped = [
      for (final line in lines)
        if (line.quantity > 0) line,
    ];
    final total = dropped.fold<double>(0, (sum, l) => sum + l.lineTotal);
    if (dropped.isEmpty || total <= 0) {
      throw const CashDropException('A cash drop must be more than zero.');
    }

    final identity = await _resolveIdentity();

    final drop = CashDropDto(
      id: const Uuid().v4(),
      branchId: identity.branchId,
      posId: identity.posId,
      shift: identity.shift,
      shiftDate: identity.businessDate,
      cashierId: identity.cashierId,
      cashierName: identity.cashierName,
      lines: dropped,
      createdAt: DateTime.now(),
    );

    final record = await _repository.saveCashDrop(drop);

    await _syncQuietly();

    Object? printError;
    try {
      await _generator.printCashDrop(CashDropSlipData.fromTable(record));
    } catch (e) {
      debugPrint('CashDrop: slip did not print: $e');
      printError = e;
    }

    return CashDropOutcome(record: record, printError: printError);
  }

  /// Prints a saved drop again, marked REPRINT. Throws [CashDropException] if
  /// it isn't on this device; printer errors propagate.
  Future<CashDropTableData> reprintCashDrop(String id) async {
    final record = await _repository.getCashDrop(id);
    if (record == null) {
      throw const CashDropException('That cash drop was not found.');
    }
    await _generator.printCashDrop(
      CashDropSlipData.fromTable(record, isReprint: true),
    );
    return record;
  }

  /// Sends any drops the server hasn't received. Safe to call any time (e.g.
  /// on start-up or alongside the catalog sync); does nothing until the server
  /// API exists. Returns how many were sent.
  Future<int> syncPending() => _repository.syncPending();

  Future<void> _syncQuietly() async {
    try {
      await _repository.syncPending();
    } catch (e) {
      // The drop is already saved; it will be retried later.
      debugPrint('CashDrop: sync failed: $e');
    }
  }

  /// Resolves who/where the drop belongs to, the same way the dashboard does
  /// for sales and shift reports.
  Future<_Identity> _resolveIdentity() async {
    final config = await _posConfigDao.getPos();
    final shiftRows = await _posShiftDao.getAllPosShifts();
    final shiftRow = shiftRows.isNotEmpty ? shiftRows.first : null;

    final configPosId = config?.posId;
    final shiftPosId = shiftRow?.posId;
    final String posId;
    if (configPosId != null && configPosId != 0) {
      posId = configPosId.toString();
    } else if (shiftPosId != null &&
        shiftPosId.isNotEmpty &&
        shiftPosId != 'UNREGISTERED') {
      posId = shiftPosId;
    } else {
      throw const CashDropIdentityException(
        'No POS ID is configured, so the cash drop cannot be recorded.',
      );
    }

    final shift = shiftRow?.shift;
    if (shift == null || shift.isEmpty || shift == 'UNREGISTERED') {
      throw const CashDropIdentityException(
        'No shift is open, so the cash drop cannot be recorded.',
      );
    }

    final user = await _userDao.getUser();
    final cashierName = user?.fullName;
    if (cashierName == null ||
        cashierName.isEmpty ||
        cashierName == 'INVALID USER') {
      throw const CashDropIdentityException(
        'No user is logged in, so the cash drop cannot be attributed to a '
        'cashier.',
      );
    }

    final branch = await _branchDao.getBranch();
    final branchId = branch?.branchId;
    if (branchId == null || branchId.isEmpty || branchId == 'UNREGISTERED') {
      throw const CashDropIdentityException(
        'No branch is configured, so the cash drop cannot be recorded.',
      );
    }

    return _Identity(
      posId: posId,
      shift: shift,
      cashierId: user!.employeeId,
      cashierName: cashierName,
      branchId: branchId,
      businessDate: _formatBusinessDate(DateTime.now()),
    );
  }

  String _formatBusinessDate(DateTime d) {
    String two(int n) => n.toString().padLeft(2, '0');
    return '${d.year}-${two(d.month)}-${two(d.day)}';
  }
}
