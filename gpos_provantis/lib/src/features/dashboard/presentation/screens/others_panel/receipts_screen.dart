// Location: src/features/dashboard/presentation/screens/receipts_screen.dart
//
// Lists every saved sale (newest first) so a cashier can find one,
// preview it, and reprint its ticket. Reads live off `salesProvider` (a
// StreamNotifierProvider already watching `SalesDao.watchAllSales()`),
// so a sale saved anywhere else in the app shows up here without this
// screen needing its own polling or refresh button.
//
// TOUCHSCREEN POS LAYOUT: this screen is operated by tapping a finger on
// a fixed POS terminal, not a mouse — every row is a single large tap
// target (the whole card, not a small icon buried in a corner) and the
// only action inside the preview (Reprint) is a full-width, thumb-height
// button, not an icon button. No control on this screen is sized for
// pointer precision.
//
// PREVIEW BEFORE PRINT: tapping a sale opens a bottom sheet laid out like
// the actual thermal ticket (monospace, same section order as
// `_buildTicketBytes` in receipt_generator.dart: header, transaction
// info, items, totals) so a cashier can confirm it's the right sale
// before committing paper to it, instead of finding out only after
// reprinting. The sheet and the print both build their content from the
// exact same `receiptSaleDataFromSaleRow(sale)` call (see
// receipt_reprint_controller.dart) — the preview is never at risk of
// showing something different from what the printer produces, because
// there's only one place that does the row-to-ticket-data translation.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        ReceiptPrintException,
        ReceiptSaleData,
        ReceiptLineItem,
        receiptGeneratorProvider;
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/receipt_reprint_controller.dart';

class ReceiptsScreen extends ConsumerWidget {
  const ReceiptsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final salesAsync = ref.watch(salesProvider);

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Receipts',
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colors.surface,
      ),
      body: salesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, _) => _ReceiptsMessage(
          icon: Icons.error_outline_rounded,
          text: 'Could not load receipts.\n$error',
        ),
        data: (sales) {
          if (sales.isEmpty) {
            return const _ReceiptsMessage(
              icon: Icons.receipt_long_rounded,
              text: 'No receipts yet.',
            );
          }

          // Newest first — `watchAllSales()` carries no ORDER BY of its
          // own (unlike `getUnsyncedSales()`, which sorts ascending for
          // upload order), so sorting for *display* is this screen's
          // own concern, deliberately the opposite direction from the
          // upload queue's oldest-first order.
          final sorted = [...sales]
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

          return ListView.separated(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            itemCount: sorted.length,
            separatorBuilder: (_, _) => const SizedBox(height: 12),
            itemBuilder: (context, index) => _SaleTile(sale: sorted[index]),
          );
        },
      ),
    );
  }
}

class _ReceiptsMessage extends StatelessWidget {
  const _ReceiptsMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One sale row. The entire card is the tap target (min 72px tall) —
/// tapping anywhere opens the preview sheet, where Reprint actually
/// lives. There's deliberately no separate print icon out here: a small
/// icon at the edge of a card is the easiest kind of control to miss or
/// mis-tap on a fixed touchscreen, and printing straight from the list
/// with no preview is exactly the "wasted paper" problem this screen
/// exists to avoid.
class _SaleTile extends StatelessWidget {
  const _SaleTile({required this.sale});

  final SalesTableData sale;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final total = double.tryParse(sale.total) ?? 0;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: () => _ReceiptPreviewSheet.show(context, sale: sale),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          child: Row(
            children: [
              _DateBadge(dateTime: sale.createdAt),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'OR# ${sale.detailId}',
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${sale.paymentType} · ${sale.cashier}',
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    total.toStringAsFixed(2),
                    style: AppTypography.ui(
                      color: colors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Icon(
                    Icons.chevron_right_rounded,
                    size: 20,
                    color: colors.textSecondary,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Compact day/time block standing in for a "list thumbnail" — lets a
/// cashier scan a long list by date at a glance instead of reading a
/// full timestamp string on every row.
class _DateBadge extends StatelessWidget {
  const _DateBadge({required this.dateTime});

  final DateTime dateTime;

  static const _months = [
    'JAN',
    'FEB',
    'MAR',
    'APR',
    'MAY',
    'JUN',
    'JUL',
    'AUG',
    'SEP',
    'OCT',
    'NOV',
    'DEC',
  ];

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final twoDigitHour = ((dateTime.hour % 12 == 0) ? 12 : dateTime.hour % 12)
        .toString();
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final meridiem = dateTime.hour >= 12 ? 'PM' : 'AM';

    return Container(
      width: 56,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _months[dateTime.month - 1],
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 11,
              fontWeight: FontWeight.w700,
            ),
          ),
          Text(
            '${dateTime.day}',
            style: AppTypography.display(
              color: colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '$twoDigitHour:$minute $meridiem',
            style: AppTypography.ui(color: colors.textSecondary, fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// Bottom sheet previewing a sale in the same shape it'll actually
/// print in — header, transaction info, items, totals, in the same
/// order `_buildTicketBytes` lays them out — with one large Reprint
/// button pinned at the bottom. Opening this costs nothing (no paper,
/// no printer round trip); only the button at the bottom does.
class _ReceiptPreviewSheet extends ConsumerStatefulWidget {
  const _ReceiptPreviewSheet({required this.sale});

  final SalesTableData sale;

  static Future<void> show(
    BuildContext context, {
    required SalesTableData sale,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ReceiptPreviewSheet(sale: sale),
    );
  }

  @override
  ConsumerState<_ReceiptPreviewSheet> createState() =>
      _ReceiptPreviewSheetState();
}

class _ReceiptPreviewSheetState extends ConsumerState<_ReceiptPreviewSheet> {
  bool _printing = false;

  Future<void> _reprint(ReceiptSaleData saleData) async {
    if (_printing) return;
    setState(() => _printing = true);

    final generator = ref.read(receiptGeneratorProvider);

    try {
      await generator.printForSale(saleData);
      if (mounted) {
        Navigator.of(context).pop();
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Receipt reprinted.')));
      }
    } on ReceiptPrintException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text(e.message)));
      }
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    // Same translation the actual print uses (see this file's header
    // comment) — the preview below is built from the identical
    // `ReceiptSaleData` that would be handed to the printer, not a
    // second, separately-maintained summary of the row.
    final saleData = receiptSaleDataFromSaleRow(widget.sale);

    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      expand: false,
      builder: (context, scrollController) {
        return Container(
          decoration: BoxDecoration(
            color: colors.surface,
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 12, bottom: 4),
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: colors.border,
                    borderRadius: BorderRadius.circular(999),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 4),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Receipt preview',
                        style: AppTypography.display(
                          color: colors.textPrimary,
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    // Large, unambiguous close target — matches the
                    // Reprint button's touch-target height rather than
                    // the default small IconButton hit area.
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.close_rounded),
                      iconSize: 26,
                      color: colors.textSecondary,
                      style: IconButton.styleFrom(
                        minimumSize: const Size(48, 48),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 8),
                  child: _ReceiptPreviewTicket(saleData: saleData),
                ),
              ),
              SafeArea(
                top: false,
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
                  child: SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton.icon(
                      onPressed: _printing ? null : () => _reprint(saleData),
                      icon: _printing
                          ? const SizedBox(
                              width: 20,
                              height: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Colors.white,
                              ),
                            )
                          : const Icon(Icons.print_rounded),
                      label: Text(
                        _printing ? 'Printing…' : 'REPRINT',
                        style: AppTypography.ui(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      style: FilledButton.styleFrom(
                        backgroundColor: colors.textPrimary,
                        foregroundColor: colors.surface,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// Renders a `ReceiptSaleData` as a mock ticket — monospace, dashed
/// rules, same section order as `_buildTicketBytes` in
/// receipt_generator.dart (REPRINT marker → transaction info → items →
/// totals → payment) — so what a cashier sees here reads as "this is
/// what will come out of the printer," not a generic detail screen.
class _ReceiptPreviewTicket extends StatelessWidget {
  const _ReceiptPreviewTicket({required this.saleData});

  final ReceiptSaleData saleData;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mono = AppTypography.ui(
      color: colors.textPrimary,
      fontSize: 13,
      // fontFamily: 'monospace',
    );

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surfaceVariant,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: colors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (saleData.isReprint) ...[
            Center(
              child: Text(
                'REPRINT',
                style: mono.copyWith(fontWeight: FontWeight.w800, fontSize: 15),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Center(
            child: Text(
              'OR# ${saleData.detailId}',
              style: mono.copyWith(fontWeight: FontWeight.w700),
            ),
          ),
          Center(child: Text(_formatDateTime(saleData.dateTime), style: mono)),
          _dashedDivider(colors.border),
          _row('CASHIER', saleData.cashier, mono),
          _row('POS', saleData.posId, mono),
          _row('SHIFT', saleData.shift, mono),
          _row('BRANCH', saleData.branchId, mono),
          if (saleData.paymentType == 'EPAYMENT' ||
              saleData.paymentType == 'SPLIT') ...[
            _row('REF#', saleData.referenceId, mono),
            _row('TYPE', saleData.paymentName, mono),
          ],
          _row('PAYMENT TYPE', saleData.paymentType, mono),
          _dashedDivider(colors.border),
          for (final item in saleData.items) _itemRow(item, mono),
          _dashedDivider(colors.border),
          Text(
            '--Total Items ${saleData.totalItemCount}--',
            textAlign: TextAlign.center,
            style: mono,
          ),
          _dashedDivider(colors.border),
          _amountRow('TOTAL AMOUNT', saleData.total, mono, emphasize: true),
          if (saleData.discountLabel != null)
            _amountRow(
              'DISCOUNT (${saleData.discountLabel})',
              -saleData.discountAmount,
              mono,
            ),
          if (saleData.paymentType == 'CASH' || saleData.paymentType == 'SPLIT')
            _amountRow('CASH', saleData.cash, mono),
          if (saleData.paymentType == 'EPAYMENT')
            _amountRow(saleData.paymentName, saleData.cash, mono),
          if (saleData.paymentType == 'SPLIT')
            _amountRow(saleData.paymentName, saleData.ecash, mono),
          _amountRow('CHANGE', saleData.changeDue, mono),
        ],
      ),
    );
  }

  Widget _dashedDivider(Color dividerColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: LayoutBuilder(
        builder: (context, constraints) {
          const dashWidth = 4.0;
          const dashSpace = 4.0;
          final count = (constraints.maxWidth / (dashWidth + dashSpace))
              .floor();
          return Row(
            children: List.generate(
              count,
              (_) => Expanded(
                child: Container(
                  height: 1,
                  margin: const EdgeInsets.symmetric(horizontal: dashSpace / 2),
                  color: dividerColor,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _row(String label, String value, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text('$label: ', style: style),
          Expanded(
            child: Text(
              value,
              textAlign: TextAlign.right,
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _itemRow(ReceiptLineItem item, TextStyle style) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: Row(
        children: [
          Expanded(
            child: Text(
              '${item.name} x${item.quantity}',
              style: style,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Text(_formatCurrency(item.lineTotal), style: style),
        ],
      ),
    );
  }

  Widget _amountRow(
    String label,
    double amount,
    TextStyle style, {
    bool emphasize = false,
  }) {
    final resolvedStyle = emphasize
        ? style.copyWith(fontWeight: FontWeight.w800)
        : style;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(label, style: resolvedStyle),
          const Spacer(),
          Text(_formatCurrency(amount), style: resolvedStyle),
        ],
      ),
    );
  }

  String _formatCurrency(double value) => value.toStringAsFixed(2);

  String _formatDateTime(DateTime dateTime) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    return '${dateTime.year}-${twoDigits(dateTime.month)}-${twoDigits(dateTime.day)} '
        '${twoDigits(dateTime.hour)}:${twoDigits(dateTime.minute)}';
  }
}
