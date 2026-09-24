// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/reprint_sheet.dart
import 'package:flutter/material.dart';
import 'pos_form_sheet.dart';

/// --- Re-print sheet: asks the cashier for the OR Number --------------------
///
/// PLACEHOLDER: submit currently does nothing (just a TODO). Wire the real
/// re-print call into [_onSubmit] later.
class ReprintSheet extends StatefulWidget {
  const ReprintSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showPosFormSheet(context, child: const ReprintSheet());
  }

  @override
  State<ReprintSheet> createState() => _ReprintSheetState();
}

class _ReprintSheetState extends State<ReprintSheet> {
  final _orController = TextEditingController();

  @override
  void initState() {
    super.initState();
    // Rebuild on every keystroke so the submit button enables/disables.
    _orController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _orController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _orController.text.trim().isNotEmpty;

  void _onSubmit() {
    // TODO: implement re-print using `_orController.text.trim()`.
    // Intentionally a no-op for now — the sheet stays open.
  }

  @override
  Widget build(BuildContext context) {
    return PosFormSheet(
      title: 'Re-print receipt',
      subtitle: 'Enter the OR number of the receipt to print again',
      icon: Icons.print_rounded,
      submitLabel: 'RE-PRINT',
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
          onSubmitted: (_) {
            if (_canSubmit) _onSubmit();
          },
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
