// Location: src/features/settings/panels/pos_config_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/database/domain/settings_dto.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import '../controllers/app_settings_controller.dart';
import '../screens/settings_shared.dart';

/// =========================================================================
/// POS CONFIG PANEL — company/BIR receipt-compliance fields.
///
/// Saved to the database through `appSettingsProvider` when the cashier
/// taps "Save configuration". Nothing is written while typing, so a
/// half-finished edit never reaches the receipt.
///
/// The database stores the text `UNREGISTERED` in any field that has not
/// been filled in yet. That word is only a placeholder for the database,
/// so this panel shows those fields as empty and writes `UNREGISTERED`
/// back if a field is saved blank (see `_fromDb` / `_toDb`).
/// =========================================================================

const _unregistered = 'UNREGISTERED';

/// Database value -> what the text box should show.
String _fromDb(String value) => value == _unregistered ? '' : value;

/// What the text box holds -> database value.
String _toDb(String text) {
  final trimmed = text.trim();
  return trimmed.isEmpty ? _unregistered : trimmed;
}

class PosConfigPanel extends ConsumerStatefulWidget {
  const PosConfigPanel();

  @override
  ConsumerState<PosConfigPanel> createState() => _PosConfigPanelState();
}

class _PosConfigPanelState extends ConsumerState<PosConfigPanel> {
  final _formKey = GlobalKey<FormState>();

  final _companyNameController = TextEditingController();
  final _addressController = TextEditingController();
  final _accreditationNoController = TextEditingController();
  final _validUntilController = TextEditingController();
  final _vatRegController = TextEditingController();
  final _permitToUseController = TextEditingController();
  final _machineIdController = TextEditingController();

  /// True once the boxes have been filled from the database. The fill
  /// happens only once, so later database updates cannot overwrite what
  /// the cashier is in the middle of typing.
  bool _filled = false;

  bool _saving = false;

  @override
  void initState() {
    super.initState();

    // Fields might already have data (opening the panel a second time).
    final current = ref.read(appSettingsProvider).value;
    if (current != null) _fillFrom(current);

    // Or the data may still be loading. Fill as soon as it arrives.
    ref.listenManual(appSettingsProvider, (previous, next) {
      final data = next.value;
      if (!_filled && data != null) _fillFrom(data);
    });
  }

  void _fillFrom(SettingsDto s) {
    _companyNameController.text = _fromDb(s.companyName);
    _addressController.text = _fromDb(s.address);
    _accreditationNoController.text = _fromDb(s.accreditationNo);
    _validUntilController.text = _fromDb(s.validUntil);
    _vatRegController.text = _fromDb(s.vatReg);
    _permitToUseController.text = _fromDb(s.permitToUse);
    _machineIdController.text = _fromDb(s.machineIdentificationNumber);
    _filled = true;
  }

  @override
  void dispose() {
    _companyNameController.dispose();
    _addressController.dispose();
    _accreditationNoController.dispose();
    _validUntilController.dispose();
    _vatRegController.dispose();
    _permitToUseController.dispose();
    _machineIdController.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (_saving) return;
    if (!_formKey.currentState!.validate()) return;

    setState(() => _saving = true);

    try {
      await ref
          .read(appSettingsProvider.notifier)
          .saveChanges(
            (s) => s.copyWith(
              companyName: _toDb(_companyNameController.text),
              address: _toDb(_addressController.text),
              accreditationNo: _toDb(_accreditationNoController.text),
              validUntil: _toDb(_validUntilController.text),
              vatReg: _toDb(_vatRegController.text),
              permitToUse: _toDb(_permitToUseController.text),
              machineIdentificationNumber: _toDb(_machineIdController.text),
            ),
          );

      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('POS configuration saved.')));
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Could not save. Please try again.')),
      );
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(
        Space.xxxl,
        Space.xxl,
        Space.xxxl,
        Space.xxxl,
      ),
      children: [
        const PanelHeader(
          title: 'POS Config',
          subtitle: 'Company and BIR details printed on official receipts',
        ),
        const SizedBox(height: Space.xxl),
        Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const _ConfigFieldLabel('Company Name'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _companyNameController,
                hintText: 'Provantis Trading Corp.',
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('Address'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _addressController,
                hintText: '123 Rizal St., Makati City',
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('Accreditation No.'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _accreditationNoController,
                hintText: 'FP123456789012345678',
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('Valid Until'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _validUntilController,
                hintText: 'MM/DD/YYYY',
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('VAT Reg. TIN'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _vatRegController,
                hintText: '000-000-000-000',
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('Permit to Use'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _permitToUseController,
                hintText: 'PTU number',
              ),
              const SizedBox(height: Space.xxl),

              const _ConfigFieldLabel('Machine Identification Number'),
              const SizedBox(height: Space.sm),
              _ConfigTextField(
                controller: _machineIdController,
                hintText: 'MIN-000000000000',
              ),
              const SizedBox(height: Space.xxxl),

              _SaveConfigButton(onPressed: _save, saving: _saving),
            ],
          ),
        ),
      ],
    );
  }
}

class _ConfigFieldLabel extends StatelessWidget {
  const _ConfigFieldLabel(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Text(
      text,
      style: AppTypography.ui(
        fontSize: 15,
        fontWeight: FontWeight.w600,
        color: colors.textSecondary,
      ),
    );
  }
}

class _ConfigTextField extends StatelessWidget {
  const _ConfigTextField({required this.controller, required this.hintText});

  final TextEditingController controller;
  final String hintText;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return TextFormField(
      controller: controller,
      textInputAction: TextInputAction.next,
      style: AppTypography.ui(fontSize: 18, color: colors.textPrimary),
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: AppTypography.ui(fontSize: 18, color: colors.textDisabled),
        filled: true,
        fillColor: colors.surfaceVariant,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: Space.xl,
          vertical: Space.xl,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: colors.primary, width: 2.5),
        ),
      ),
    );
  }
}

class _SaveConfigButton extends StatelessWidget {
  const _SaveConfigButton({required this.onPressed, required this.saving});

  final VoidCallback onPressed;
  final bool saving;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: saving ? colors.primary.withValues(alpha: 0.6) : colors.primary,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        onTap: saving ? null : onPressed,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          height: 72,
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (saving)
                SizedBox(
                  width: 22,
                  height: 22,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: colors.onPrimary,
                  ),
                )
              else
                Icon(Icons.check_rounded, size: 24, color: colors.onPrimary),
              const SizedBox(width: Space.md),
              Text(
                saving ? 'Saving...' : 'Save configuration',
                style: AppTypography.ui(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: colors.onPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
