// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/refund_sheet.dart
import 'package:flutter/material.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'pos_form_sheet.dart';

/// --- Refund sheet: OR number + description ---------------------------------
///
/// Uses the theme's `refund` / `onRefund` roles (orange) for the header chip
/// and submit button so it reads as a distinct, consequential action rather
/// than a routine one.
///
/// PLACEHOLDER: submit currently does nothing. Wire the real refund call
/// into [_onSubmit] later.
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

  /// Both fields are required — a refund with no reason on record is exactly
  /// what an audit trail is meant to prevent.
  bool get _canSubmit =>
      _orController.text.trim().isNotEmpty &&
      _descriptionController.text.trim().isNotEmpty;

  void _onSubmit() {
    // TODO: implement refund using:
    //   orNumber:    _orController.text.trim()
    //   description: _descriptionController.text.trim()
    // Intentionally a no-op for now — the sheet stays open.
  }

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
          // "Next" on the keyboard jumps to description instead of closing.
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
          // Multiline field: Enter inserts a newline, so "action" here is
          // the newline key. The big button below is the submit path.
          textInputAction: TextInputAction.newline,
          minLines: 3,
          maxLines: 4,
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
