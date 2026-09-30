import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show SalesTableData;
import 'package:gpos_provantis/src/core/database/providers/sales_dao_provider.dart';
import 'package:gpos_provantis/src/core/printutil/receipt_generator.dart'
    show ReceiptPrintException, receiptGeneratorProvider;
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/receipt_reprint_controller.dart';
import 'receipt_preview_sheet.dart';
import 'pos_form_sheet.dart';

class ReprintSheet extends ConsumerStatefulWidget {
  const ReprintSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showPosFormSheet(context, child: const ReprintSheet());
  }

  @override
  ConsumerState<ReprintSheet> createState() => _ReprintSheetState();
}

class _ReprintSheetState extends ConsumerState<ReprintSheet> {
  final _orController = TextEditingController();
  bool _busy = false;
  bool _printing = false;
  String? _error;

  @override
  void initState() {
    super.initState();

    _orController.addListener(() {
      setState(() => _error = null);
    });
  }

  @override
  void dispose() {
    _orController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _orController.text.trim().isNotEmpty && !_busy;

  Future<SalesTableData?> _findSale(String orNumber) async {
    final sale = await ref.read(salesDaoProvider).getSaleByDetailId(orNumber);
    if (sale == null && mounted) {
      setState(() => _error = 'OR number not found.');
    }
    return sale;
  }

  Future<void> _onPreview() async {
    if (!_canSubmit) return;

    final navigator = Navigator.of(context);

    setState(() {
      _busy = true;
      _error = null;
    });

    SalesTableData? sale;
    try {
      sale = await _findSale(_orController.text.trim());
    } finally {
      if (mounted) setState(() => _busy = false);
    }

    if (sale == null || !mounted) return;

    final printed = await ReceiptPreviewSheet.show(context, sale: sale);

    // If they printed from the preview, there's nothing left to do here.
    if (printed == true && mounted) navigator.pop();
  }

  Future<void> _onSubmit() async {
    if (!_canSubmit) return;

    final navigator = Navigator.of(context);
    final messenger = ScaffoldMessenger.of(context);

    setState(() {
      _busy = true;
      _printing = true;
      _error = null;
    });

    try {
      final sale = await _findSale(_orController.text.trim());
      if (sale == null) return;

      final saleData = receiptSaleDataFromSaleRow(sale);
      await ref.read(receiptGeneratorProvider).printForSale(saleData);

      navigator.pop();
      messenger.showSnackBar(
        const SnackBar(content: Text('Receipt reprinted.')),
      );
    } on ReceiptPrintException catch (e) {
      if (mounted) setState(() => _error = e.message);
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          _printing = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PosFormSheet(
      title: 'Re-print receipt',
      subtitle: 'Enter the OR number of the receipt to print again',
      icon: Icons.print_rounded,
      submitLabel: _printing ? 'PRINTING…' : 'RE-PRINT',
      submitEnabled: _canSubmit,
      onSubmit: _onSubmit,
      children: [
        PosTextField(
          label: 'OR NUMBER',
          hint: 'e.g. 000123',
          icon: Icons.tag_rounded,
          controller: _orController,
          autofocus: true,
          keyboardType: TextInputType.text,
          textCapitalization: TextCapitalization.characters,
          textInputAction: TextInputAction.done,
          errorText: _error,
          onSubmitted: (_) => _onSubmit(),
        ),
        const SizedBox(height: 16),
        PosSheetButton(
          label: 'PREVIEW RECEIPT',
          onPressed: _canSubmit ? _onPreview : null,
          background: colors.surfaceVariant,
          foreground: colors.textPrimary,
        ),
        const SizedBox(height: 12),
      ],
    );
  }
}
