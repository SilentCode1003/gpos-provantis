import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/repository/cash_drawer_repository.dart';
import 'package:gpos_provantis/src/core/database/domain/cash_drawer_dto.dart';

part 'cash_drawer_service.g.dart';

@Riverpod(keepAlive: true)
CashDrawerService cashDrawerService(Ref ref) {
  return CashDrawerService(ref.watch(cashDrawerRepositoryProvider));
}

/// What the controller calls for cash-drawer activity. Nothing above this
/// (the controller, the UI) talks to [CashDrawerRepository] directly.
///
/// This is the layer that knows the SHAPE of a shift's drawer activity —
/// specifically, that opening the drawer must be sent before its
/// denomination count — so that ordering rule lives in exactly one place
/// instead of being repeated at every call site.
class CashDrawerService {
  CashDrawerService(this._repository);

  final CashDrawerRepository _repository;

  /// Records the drawer count taken at the start of a shift.
  ///
  /// Sends "open drawer" first, then the counted denominations, as two
  /// separate queued activities — matching the two requests the server log
  /// shows for every shift change. Both calls queue locally before any
  /// network attempt, so this completes (and the shift can proceed) even
  /// with no connectivity; the sends themselves happen in the background via
  /// the outbox and are retried automatically by later queue/drain calls.
  Future<void> recordStartShiftCount({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required List<DenominationCountLine> lines,
  }) => _recordShiftDrawerCount(
    shift: shift,
    cashier: cashier,
    shiftDate: shiftDate,
    branchId: branchId,
    posId: posId,
    lines: lines,
  );

  /// Records the drawer count taken at the end of a shift. Same shape and
  /// ordering as [recordStartShiftCount] — the server does not distinguish
  /// start from end, both are sent as `activity: 'endshift'`.
  Future<void> recordEndShiftCount({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required List<DenominationCountLine> lines,
  }) => _recordShiftDrawerCount(
    shift: shift,
    cashier: cashier,
    shiftDate: shiftDate,
    branchId: branchId,
    posId: posId,
    lines: lines,
  );

  Future<void> _recordShiftDrawerCount({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required List<DenominationCountLine> lines,
  }) async {
    // Queued and sent in this order, awaited one at a time: the "open
    // drawer" notice must reach the server (or at least be queued ahead in
    // the outbox) before its denomination count is queued behind it, since
    // the outbox drains oldest-first.
    await _repository.queueAndSend(
      CashDrawerActivityPayload.openDrawer(
        shift: shift,
        cashier: cashier,
        shiftDate: shiftDate,
        branchId: branchId,
        posId: posId,
      ),
    );
    await _repository.queueAndSend(
      CashDrawerActivityPayload.denominationCount(
        shift: shift,
        cashier: cashier,
        shiftDate: shiftDate,
        branchId: branchId,
        posId: posId,
        lines: lines,
      ),
    );
  }

  /// Records the cash tendered for one completed sale. Called once per
  /// transaction, right after the sale is saved.
  Future<void> recordTransaction({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required String detailId,
    required double cash,
    required double total,
  }) {
    return _repository.queueAndSend(
      CashDrawerActivityPayload.transaction(
        shift: shift,
        cashier: cashier,
        shiftDate: shiftDate,
        branchId: branchId,
        posId: posId,
        line: CashTransactionLine(detailId: detailId, cash: cash, total: total),
      ),
    );
  }

  /// Retries anything still queued from a previous session (e.g. the device
  /// was offline when a shift ended). Safe to call at any time, including
  /// with an empty queue. A good place to call this is app startup and
  /// whenever connectivity is restored, though neither is wired up yet.
  Future<bool> retryPending() => _repository.drainPendingActivities();
}
