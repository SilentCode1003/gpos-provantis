import 'package:flutter/material.dart';
import 'pos_form_sheet.dart';

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

    _orController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _orController.dispose();
    super.dispose();
  }

  bool get _canSubmit => _orController.text.trim().isNotEmpty;

  void _onSubmit() {}

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
