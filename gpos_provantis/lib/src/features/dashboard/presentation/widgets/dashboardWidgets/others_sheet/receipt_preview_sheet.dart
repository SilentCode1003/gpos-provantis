import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show
        ReceiptPrintException,
        ReceiptSaleData,
        ReceiptLineItem,
        receiptGeneratorProvider;
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/receipt_reprint_controller.dart';

/// Shows a preview of a saved receipt with a REPRINT button.
///
/// [show] returns `true` if the receipt was printed, otherwise `null`/`false`.
class ReceiptPreviewSheet extends ConsumerStatefulWidget {
  const ReceiptPreviewSheet({super.key, this.sale, this.saleData})
    : assert(
        sale != null || saleData != null,
        'Provide either a local sale row or ready-made receipt data.',
      );

  /// A sale saved on this device. Converted with [receiptSaleDataFromSaleRow].
  final SalesTableData? sale;

  /// Ready-made receipt data, e.g. built from a receipt pulled from the
  /// server. Takes priority over [sale].
  final ReceiptSaleData? saleData;

  static Future<bool?> show(
    BuildContext context, {
    SalesTableData? sale,
    ReceiptSaleData? saleData,
  }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => ReceiptPreviewSheet(sale: sale, saleData: saleData),
    );
  }

  @override
  ConsumerState<ReceiptPreviewSheet> createState() =>
      _ReceiptPreviewSheetState();
}

class _ReceiptPreviewSheetState extends ConsumerState<ReceiptPreviewSheet> {
  bool _printing = false;

  Future<void> _reprint(ReceiptSaleData saleData) async {
    if (_printing) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() => _printing = true);

    final generator = ref.read(receiptGeneratorProvider);

    try {
      await generator.printForSale(saleData);
      navigator.pop(true);
      messenger.showSnackBar(
        const SnackBar(content: Text('Receipt reprinted.')),
      );
    } on ReceiptPrintException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } finally {
      if (mounted) setState(() => _printing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final saleData =
        widget.saleData ?? receiptSaleDataFromSaleRow(widget.sale!);

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

class _ReceiptPreviewTicket extends StatelessWidget {
  const _ReceiptPreviewTicket({required this.saleData});

  final ReceiptSaleData saleData;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final mono = AppTypography.ui(color: colors.textPrimary, fontSize: 13);

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
          if (saleData.paymentType == 'E2E') ...[
            _row('REF#', saleData.referenceId, mono),
            _row('TYPE', saleData.paymentName, mono),
            _row('REF#', saleData.secondReferenceId, mono),
            _row('TYPE', saleData.secondPaymentName, mono),
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
          if (saleData.paymentType == 'E2E') ...[
            _amountRow(saleData.paymentName, saleData.ecash, mono),
            _amountRow(saleData.secondPaymentName, saleData.secondAmount, mono),
          ],
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
