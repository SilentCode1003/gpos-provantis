import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/theme/organic_pattern_background.dart';
import '../controllers/setup_controller.dart';

class SetupScreen extends ConsumerStatefulWidget {
  const SetupScreen({super.key});

  @override
  ConsumerState<SetupScreen> createState() => _SetupScreenState();
}

class _SetupScreenState extends ConsumerState<SetupScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _branchController;
  late final TextEditingController _posController;
  late final TextEditingController _addressController;
  late final TextEditingController _portController;

  @override
  void initState() {
    super.initState();
    _branchController = TextEditingController();
    _posController = TextEditingController();
    _addressController = TextEditingController();
    _portController = TextEditingController();
  }

  @override
  void dispose() {
    _branchController.dispose();
    _posController.dispose();
    _addressController.dispose();
    _portController.dispose();
    super.dispose();
  }

  void _onAddressChanged(String value) {
    ref.read(setupControllerProvider.notifier).setAddress(value);
  }

  void _onPortChanged(String value) {
    ref.read(setupControllerProvider.notifier).setPort(value);
  }

  void _onProtocolChanged(String protocol) {
    ref.read(setupControllerProvider.notifier).setProtocol(protocol);
  }

  Future<void> _handleSubmit() async {
    if (_formKey.currentState?.validate() ?? false) {
      final success = await ref
          .read(setupControllerProvider.notifier)
          .saveSetup();
      if (success && mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:
                ref.read(setupControllerProvider).errorMessage != null
                ? context.colors.danger
                : context.colors.primary,
            content: Text(
              'Terminal setup saved successfully.',
              style: AppTypography.ui(color: context.colors.onPrimary),
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final state = ref.watch(setupControllerProvider);
    final controller = ref.read(setupControllerProvider.notifier);

    final inputDecorationTheme = InputDecorationTheme(
      filled: true,
      fillColor: colors.surfaceVariant,
      hintStyle: AppTypography.ui(fontSize: 14, color: colors.textDisabled),
      prefixIconColor: WidgetStateColor.resolveWith((states) {
        if (states.contains(WidgetState.focused)) return colors.primary;
        return colors.textSecondary;
      }),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.primary, width: 2.0),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.danger),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide(color: colors.danger, width: 2.0),
      ),
    );

    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: Theme.of(
          context,
        ).colorScheme.copyWith(primary: colors.primary),
        textSelectionTheme: TextSelectionThemeData(
          cursorColor: colors.primary,
          selectionColor: colors.primary.withValues(alpha: 0.3),
          selectionHandleColor: colors.primary,
        ),
      ),
      child: Scaffold(
        backgroundColor: colors.background,
        body: OrganicPatternBackground(
          lineColor: colors.primary,
          opacity: 0.16,
          child: Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 560),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: colors.border),
                ),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Text(
                        'Terminal Setup',
                        style: AppTypography.display(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: colors.textPrimary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Enter your store credentials to configure this device.',
                        style: AppTypography.ui(
                          fontSize: 14,
                          color: colors.textSecondary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),

                      if (state.errorMessage != null) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: colors.dangerContainer,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            state.errorMessage!,
                            style: AppTypography.ui(
                              fontSize: 13,
                              color: colors.onDangerContainer,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ),
                        const SizedBox(height: 16),
                      ],

                      // Domain row: HTTP/HTTPS dropdown + Address + Port,
                      // all under one label. Port is visually de-emphasized
                      // (smaller, "Optional" hint as its hint text rather
                      // than a separate labeled section) since most users
                      // will never need to touch it.
                      _buildFieldLabel('Domain / Server Address', colors),
                      const SizedBox(height: 6),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 7,
                            child: TextFormField(
                              controller: _addressController,
                              enabled: !state.isLoading,
                              style: AppTypography.ui(
                                fontSize: 15,
                                color: colors.textPrimary,
                              ),
                              decoration: inputDecorationTheme
                                  .toInputDecoration()
                                  .copyWith(
                                    hintText: 'domain.server.com',
                                    prefixIcon: Container(
                                      padding: const EdgeInsets.only(
                                        left: 12,
                                        right: 8,
                                      ),
                                      margin: const EdgeInsets.only(right: 8),
                                      decoration: BoxDecoration(
                                        border: Border(
                                          right: BorderSide(
                                            color: colors.border,
                                          ),
                                        ),
                                      ),
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          value: state.protocol,
                                          isDense: true,
                                          icon: Icon(
                                            Icons.arrow_drop_down,
                                            color: colors.textSecondary,
                                          ),
                                          style: AppTypography.ui(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w600,
                                            color: colors.primary,
                                          ),
                                          dropdownColor: colors.surface,
                                          onChanged: state.isLoading
                                              ? null
                                              : (String? newValue) {
                                                  if (newValue != null) {
                                                    _onProtocolChanged(
                                                      newValue,
                                                    );
                                                  }
                                                },
                                          items: <String>['https://', 'http://']
                                              .map<DropdownMenuItem<String>>((
                                                String value,
                                              ) {
                                                return DropdownMenuItem<String>(
                                                  value: value,
                                                  child: Text(
                                                    value,
                                                    style: AppTypography.ui(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: colors.textPrimary,
                                                    ),
                                                  ),
                                                );
                                              })
                                              .toList(),
                                        ),
                                      ),
                                    ),
                                  ),
                              validator: (val) {
                                if (val == null || val.trim().isEmpty) {
                                  return 'Domain is required';
                                }
                                if (val.contains('://')) {
                                  return 'Remove http:// or https:// prefix';
                                }
                                if (val.contains('/')) {
                                  return 'Remove any "/" from the address';
                                }
                                return null;
                              },
                              onChanged: _onAddressChanged,
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            flex: 3,
                            child: TextFormField(
                              controller: _portController,
                              enabled: !state.isLoading,
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              // Belt-and-suspenders alongside controller
                              // -side validation: restrict input at the
                              // keyboard level too, since a pasted value
                              // can bypass keyboardType alone. Real
                              // enforcement still happens in
                              // SetupController.validatePort.
                              inputFormatters: [
                                FilteringTextInputFormatter.digitsOnly,
                                LengthLimitingTextInputFormatter(5),
                              ],
                              style: AppTypography.ui(
                                fontSize: 15,
                                color: colors.textPrimary,
                              ),
                              decoration: inputDecorationTheme
                                  .toInputDecoration()
                                  .copyWith(
                                    hintText: 'Port',
                                    helperText: 'Optional',
                                    helperStyle: AppTypography.ui(
                                      fontSize: 11,
                                      color: colors.textSecondary,
                                    ),
                                  ),
                              validator: controller.validatePort,
                              onChanged: _onPortChanged,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),

                      // Branch ID Field
                      _buildFieldLabel('Branch ID', colors),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _branchController,
                        enabled: !state.isLoading,
                        style: AppTypography.ui(
                          fontSize: 15,
                          color: colors.textPrimary,
                        ),
                        decoration: inputDecorationTheme
                            .toInputDecoration()
                            .copyWith(
                              hintText: 'e.g., BR-001',
                              prefixIcon: const Icon(Icons.store_rounded),
                            ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'Branch ID is required'
                            : null,
                        onChanged: (val) => ref
                            .read(setupControllerProvider.notifier)
                            .setBranchId(val),
                      ),
                      const SizedBox(height: 20),

                      // POS ID Field
                      _buildFieldLabel('POS ID', colors),
                      const SizedBox(height: 6),
                      TextFormField(
                        controller: _posController,
                        enabled: !state.isLoading,
                        style: AppTypography.ui(
                          fontSize: 15,
                          color: colors.textPrimary,
                        ),
                        decoration: inputDecorationTheme
                            .toInputDecoration()
                            .copyWith(
                              hintText: 'e.g., POS-01',
                              prefixIcon: const Icon(Icons.devices_rounded),
                            ),
                        validator: (val) => (val == null || val.trim().isEmpty)
                            ? 'POS ID is required'
                            : null,
                        onChanged: (val) => ref
                            .read(setupControllerProvider.notifier)
                            .setPosId(val),
                      ),
                      const SizedBox(height: 32),

                      // Submit Button
                      SizedBox(
                        height: 48,
                        child: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: colors.primary,
                            foregroundColor: colors.onPrimary,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                            elevation: 0,
                          ),
                          onPressed: state.isLoading ? null : _handleSubmit,
                          child: state.isLoading
                              ? SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: colors.onPrimary,
                                  ),
                                )
                              : Text(
                                  'Proceed',
                                  style: AppTypography.ui(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                    color: colors.onPrimary,
                                  ),
                                ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildFieldLabel(String label, AppColors colors) {
    return Text(
      label,
      style: AppTypography.ui(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: colors.textPrimary,
      ),
    );
  }
}

extension on InputDecorationTheme {
  InputDecoration toInputDecoration() {
    return InputDecoration(
      filled: filled,
      fillColor: fillColor,
      hintStyle: hintStyle,
      prefixIconColor: prefixIconColor,
      enabledBorder: enabledBorder,
      focusedBorder: focusedBorder,
      errorBorder: errorBorder,
      focusedErrorBorder: focusedErrorBorder,
    );
  }
}
