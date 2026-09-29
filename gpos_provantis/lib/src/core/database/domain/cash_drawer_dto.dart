import 'dart:convert';

/// What the `activity` field is called by the server. Its name ('endshift')
/// is what the server sends for BOTH start-shift and end-shift drawer
/// activity — there is no separate 'startshift' value.
class CashDrawerActivity {
  static const String shiftDrawer = 'endshift';
  static const String transaction = 'transaction';
}

/// One line of a denomination count, e.g. "8 pieces of the ₱100 bill".
/// [denominationId] matches a row's id in the denominations table.
class DenominationCountLine {
  const DenominationCountLine({
    required this.denominationId,
    required this.value,
    required this.quantity,
  });

  final int denominationId;
  final int value;
  final int quantity;

  Map<String, Object> toJson() => {
    'id': denominationId,
    'value': value,
    // Quantity is sent as a STRING ("0", "8", ...), matching the server's
    // own sample payloads.
    'quantity': quantity.toString(),
  };
}

/// One transaction's cash tender, sent right after the sale completes.
class CashTransactionLine {
  const CashTransactionLine({
    required this.detailId,
    required this.cash,
    required this.total,
  });

  /// The sale's detail id (receipt number), as a string per the sample
  /// payload (`"detailid":"100000053"`).
  final String detailId;
  final double cash;
  final double total;

  Map<String, Object> toJson() => {
    'detailid': detailId,
    'cash': cash,
    'total': total,
  };
}

/// The body of a cash-drawer activity request.
///
/// [denomination] is pre-encoded to the exact JSON STRING the API expects
/// (the field is a JSON-encoded string, not a nested array — confirmed by
/// every sample payload). Building it here, in one place, is what keeps
/// every caller from hand-writing that encoding themselves.
class CashDrawerActivityPayload {
  const CashDrawerActivityPayload._({
    required this.shift,
    required this.cashier,
    required this.shiftDate,
    required this.branchId,
    required this.posId,
    required this.denomination,
    required this.activity,
  });

  final String shift;
  final String cashier;
  final String shiftDate;
  final String branchId;
  final String posId;

  /// Already-encoded JSON string.
  final String denomination;
  final String activity;

  /// The very first request of start/end shift: tells the server the drawer
  /// was opened, before any counts are sent. MUST be sent before
  /// [CashDrawerActivityPayload.denominationCount] in the same shift change.
  factory CashDrawerActivityPayload.openDrawer({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
  }) {
    return CashDrawerActivityPayload._(
      shift: shift,
      cashier: cashier,
      shiftDate: shiftDate,
      branchId: branchId,
      posId: posId,
      denomination: jsonEncode([
        {'status': 'open drawer'},
      ]),
      activity: CashDrawerActivity.shiftDrawer,
    );
  }

  /// The denomination count itself, sent right after [openDrawer] at both
  /// start and end of shift.
  factory CashDrawerActivityPayload.denominationCount({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required List<DenominationCountLine> lines,
  }) {
    return CashDrawerActivityPayload._(
      shift: shift,
      cashier: cashier,
      shiftDate: shiftDate,
      branchId: branchId,
      posId: posId,
      denomination: jsonEncode(lines.map((l) => l.toJson()).toList()),
      activity: CashDrawerActivity.shiftDrawer,
    );
  }

  /// A single transaction's cash tender.
  factory CashDrawerActivityPayload.transaction({
    required String shift,
    required String cashier,
    required String shiftDate,
    required String branchId,
    required String posId,
    required CashTransactionLine line,
  }) {
    return CashDrawerActivityPayload._(
      shift: shift,
      cashier: cashier,
      shiftDate: shiftDate,
      branchId: branchId,
      posId: posId,
      denomination: jsonEncode([line.toJson()]),
      activity: CashDrawerActivity.transaction,
    );
  }

  /// The exact request body sent to `/mobile-api/cashdrawer-activity`.
  Map<String, String> toRequestBody() => {
    'shift': shift,
    'cashier': cashier,
    'shiftdate': shiftDate,
    'branchid': branchId,
    'posid': posId,
    'denomination': denomination,
    'activity': activity,
  };
}
