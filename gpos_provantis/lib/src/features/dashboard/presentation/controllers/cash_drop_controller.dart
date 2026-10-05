import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:gpos_provantis/src/core/database/domain/cash_drop_dto.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptPrintException;
import 'package:gpos_provantis/src/services/cash_drop_service.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/widgets/dashboardWidgets/others_sheet/cash_drop_sheet.dart'
    show CashDropResult;

part 'cash_drop_controller.g.dart';

enum CashDropNoticeLevel { success, warning, error }

/// A message for the UI to show (e.g. in a snackbar).
class CashDropNotice {
  const CashDropNotice(
    this.message, {
    this.level = CashDropNoticeLevel.success,
  });

  final String message;
  final CashDropNoticeLevel level;

  bool get isError => level == CashDropNoticeLevel.error;
}

class CashDropState {
  const CashDropState({this.isSubmitting = false, this.notice});

  final bool isSubmitting;

  /// Result of the last attempt.
  final CashDropNotice? notice;
}

// Kept alive so a sheet closing mid-print can't leave this disposed while the
// service is still working.
@Riverpod(keepAlive: true)
class CashDropController extends _$CashDropController {
  @override
  CashDropState build() => const CashDropState();

  /// Records the drop returned by [CashDropSheet.show] and prints its slip.
  ///
  /// Never throws: every outcome comes back as a [CashDropNotice] for the UI.
  Future<CashDropNotice> submit(CashDropResult result) async {
    // Double-tap guard.
    if (state.isSubmitting) {
      return const CashDropNotice(
        'A cash drop is already being recorded.',
        level: CashDropNoticeLevel.warning,
      );
    }

    // Everything from `ref` is read before the first await.
    final service = ref.read(cashDropServiceProvider);

    state = const CashDropState(isSubmitting: true);

    CashDropNotice notice;
    try {
      // One-line adapter between two deliberately separate types: the sheet's
      // UI result and the service's own line type.
      final outcome = await service.recordCashDrop(
        lines: [
          for (final line in result.lines)
            CashDropLineDto(
              denominationId: line.denominationId,
              label: line.label,
              value: line.value,
              quantity: line.quantity,
            ),
        ],
      );

      final amount = outcome.record.amount.toStringAsFixed(2);
      notice = outcome.printed
          ? CashDropNotice('Cash drop of ₱$amount recorded and printed.')
          : CashDropNotice(
              'Cash drop of ₱$amount was recorded, but the slip could not be '
              'printed: ${_describe(outcome.printError!)}',
              level: CashDropNoticeLevel.warning,
            );
    } catch (e) {
      notice = CashDropNotice(_describe(e), level: CashDropNoticeLevel.error);
    }

    state = CashDropState(notice: notice);
    return notice;
  }

  /// Prints a saved drop again (marked REPRINT).
  Future<CashDropNotice> reprint(String cashDropId) async {
    if (state.isSubmitting) {
      return const CashDropNotice(
        'Please wait for the current cash drop to finish.',
        level: CashDropNoticeLevel.warning,
      );
    }

    final service = ref.read(cashDropServiceProvider);
    state = const CashDropState(isSubmitting: true);

    CashDropNotice notice;
    try {
      await service.reprintCashDrop(cashDropId);
      notice = const CashDropNotice('Cash drop slip reprinted.');
    } catch (e) {
      notice = CashDropNotice(_describe(e), level: CashDropNoticeLevel.error);
    }

    state = CashDropState(notice: notice);
    return notice;
  }

  String _describe(Object e) {
    if (e is CashDropException) return e.message;
    if (e is CashDropIdentityException) return e.message;
    if (e is ReceiptPrintException) return e.message;
    return e.toString().replaceFirst('Exception: ', '');
  }
}
