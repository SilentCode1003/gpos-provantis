import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'pos_form_sheet.dart';

class RefundSheet extends StatefulWidget {
  const RefundSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showPosFormSheet(context, child: const RefundSheet());
  }

  @override
  State<RefundSheet> createState() => _RefundSheetState();
}

class _RefundSheetState extends State<RefundSheet> {
  final _orController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _descriptionFocus = FocusNode();

  @override
  void initState() {
    super.initState();
    _orController.addListener(_refresh);
    _descriptionController.addListener(_refresh);
  }

  void _refresh() => setState(() {});

  @override
  void dispose() {
    _orController.dispose();
    _descriptionController.dispose();
    _descriptionFocus.dispose();
    super.dispose();
  }

  bool get _canSubmit =>
      _orController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  void _onSubmit() {}

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return PosFormSheet(
      title: 'Refund',
      subtitle: 'Enter the OR number and the reason for the refund',
      icon: Icons.assignment_return_rounded,
      accent: colors.refund,
      onAccent: colors.onRefund,
      submitLabel: 'PROCESS REFUND',
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
          textInputAction: TextInputAction.next,

          onSubmitted: (_) => _descriptionFocus.requestFocus(),
        ),
        const SizedBox(height: 20),
        PosTextField(
          label: 'DESCRIPTION',
          hint: 'Reason for the refund',
          icon: Icons.notes_rounded,
          controller: _descriptionController,
          focusNode: _descriptionFocus,
          keyboardType: TextInputType.multiline,
          textCapitalization: TextCapitalization.sentences,

          textInputAction: TextInputAction.newline,
          minLines: 3,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
