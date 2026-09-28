import 'package:flutter/material.dart';

import 'denomination_count_sheet.dart';

class CashDropSheet {
  const CashDropSheet._();

  static Future<CashDropResult?> show(BuildContext context) async {
    final result = await DenominationCountSheet.show(
      context,
      title: 'Cash drop',
      subtitle: 'Count the cash you\'re removing from the drawer',
      totalLabel: 'Total to drop',
      submitLabel: 'CONFIRM CASH DROP',
      // A drop of nothing isn't a valid drop.
      allowZeroTotal: false,
    );
    if (result == null) return null;

    return CashDropResult(
      total: result.total,
      lines: [
        for (final entry in result.lines)
          CashDropLine(
            denominationId: entry.denominationId,
            label: entry.label,
            value: entry.value,
            quantity: entry.quantity,
          ),
      ],
    );
  }
}

class CashDropLine {
  const CashDropLine({
    required this.denominationId,
    required this.label,
    required this.value,
    required this.quantity,
  });

  final int denominationId;
  final String label;
  final int value;
  final int quantity;

  int get lineTotal => value * quantity;
}

class CashDropResult {
  const CashDropResult({required this.total, required this.lines});

  final int total;
  final List<CashDropLine> lines;
}
