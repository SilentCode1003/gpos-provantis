import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'pos_form_sheet.dart';
import 'package:gpos_provantis/src/core/database/providers/denominations_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart';

/// A denomination-by-denomination cash count: coins, bills, and anything
/// else, each with a stepper and quantity field, adding up to a total.
///
/// This is the shared shape behind cash drop, the start-shift drawer count,
/// and the end-shift drawer count — everywhere the POS needs "how much cash,
/// broken down by denomination". What differs between those screens is only
/// the header copy, the submit button label, and what happens with the
/// result; all of that is customized through the constructor, so the
/// counting UI itself (and its bugs, if any) lives in exactly one place.
///
/// [CashDropSheet] should become a thin wrapper around this widget rather
/// than a parallel copy — see the bottom of this file for that wrapper.
class DenominationCountSheet extends ConsumerStatefulWidget {
  const DenominationCountSheet({
    super.key,
    required this.title,
    required this.subtitle,
    required this.totalLabel,
    required this.submitLabel,
    this.allowZeroTotal = false,
    this.icon = Icons.point_of_sale_rounded,
  });

  /// e.g. "Cash drop", "Start-of-shift count", "End-of-shift count".
  final String title;

  /// e.g. "Count the cash you're removing from the drawer".
  final String subtitle;

  /// e.g. "Total to drop", "Total counted".
  final String totalLabel;

  /// e.g. "CONFIRM CASH DROP", "CONFIRM COUNT".
  final String submitLabel;

  /// Cash drop requires a positive total (there must be something to drop).
  /// A shift drawer count is a legitimate zero (an empty float), so
  /// start/end-shift screens should pass true here.
  final bool allowZeroTotal;

  final IconData icon;

  /// Opens the sheet and returns the counted breakdown, or null if dismissed
  /// without submitting.
  static Future<DenominationCountResult?> show(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String totalLabel,
    required String submitLabel,
    bool allowZeroTotal = false,
    IconData icon = Icons.point_of_sale_rounded,
  }) {
    return showPosFormSheet<DenominationCountResult>(
      context,
      child: DenominationCountSheet(
        title: title,
        subtitle: subtitle,
        totalLabel: totalLabel,
        submitLabel: submitLabel,
        allowZeroTotal: allowZeroTotal,
        icon: icon,
      ),
    );
  }

  @override
  ConsumerState<DenominationCountSheet> createState() =>
      _DenominationCountSheetState();
}

class _DenominationCountSheetState
    extends ConsumerState<DenominationCountSheet> {
  final Map<int, TextEditingController> _controllers = {};
  final Map<int, int> _quantities = {};

  @override
  void dispose() {
    for (final controller in _controllers.values) {
      controller.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(int denominationId) {
    return _controllers.putIfAbsent(
      denominationId,
      () => TextEditingController(),
    );
  }

  void _onQuantityChanged(int denominationId, String raw) {
    final qty = int.tryParse(raw) ?? 0;
    setState(() => _quantities[denominationId] = qty);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final keyboardInset = MediaQuery.of(context).viewInsets.bottom;
    final denominationsAsync = ref.watch(denominationsProvider);

    return Align(
      alignment: Alignment.bottomCenter,
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 560),
        child: AnimatedPadding(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeOut,
          padding: EdgeInsets.only(bottom: keyboardInset),
          child: Container(
            constraints: BoxConstraints(
              maxHeight: MediaQuery.of(context).size.height * 0.86,
            ),
            decoration: BoxDecoration(
              color: colors.surface,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _Header(
                  colors: colors,
                  title: widget.title,
                  subtitle: widget.subtitle,
                  icon: widget.icon,
                ),
                Flexible(
                  child: denominationsAsync.when(
                    loading: () => const _InlineState(
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 40),
                        child: Center(child: CircularProgressIndicator()),
                      ),
                    ),
                    error: (error, _) =>
                        _InlineState(child: _ErrorContent(colors: colors)),
                    data: (rows) {
                      final active = rows
                          .where((row) => row.status == 'ACTIVE')
                          .toList();
                      if (active.isEmpty) {
                        return _InlineState(
                          child: _EmptyContent(colors: colors),
                        );
                      }
                      return _buildCountingBody(context, colors, active);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountingBody(
    BuildContext context,
    AppColors colors,
    List<DenominationsTableData> active,
  ) {
    final coins =
        active
            .where((row) => row.description.toLowerCase().contains('coin'))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));
    final bills =
        active
            .where((row) => row.description.toLowerCase().contains('bill'))
            .toList()
          ..sort((a, b) => a.value.compareTo(b.value));

    final counted = {...coins, ...bills};
    final other = active.where((row) => !counted.contains(row)).toList()
      ..sort((a, b) => a.value.compareTo(b.value));

    final totalAmount = active.fold<int>(
      0,
      (sum, row) => sum + row.value * (_quantities[row.id] ?? 0),
    );

    final canSubmit = widget.allowZeroTotal || totalAmount > 0;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Expanded(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (coins.isNotEmpty) ...[
                  _SectionLabel(label: 'Coins', colors: colors),
                  const SizedBox(height: 10),
                  _DenominationGrid(
                    rows: coins,
                    controllerFor: _controllerFor,
                    onChanged: _onQuantityChanged,
                    quantities: _quantities,
                  ),
                  const SizedBox(height: 20),
                ],
                if (bills.isNotEmpty) ...[
                  _SectionLabel(label: 'Bills', colors: colors),
                  const SizedBox(height: 10),
                  _DenominationGrid(
                    rows: bills,
                    controllerFor: _controllerFor,
                    onChanged: _onQuantityChanged,
                    quantities: _quantities,
                  ),
                  const SizedBox(height: 20),
                ],
                if (other.isNotEmpty) ...[
                  _SectionLabel(label: 'Other', colors: colors),
                  const SizedBox(height: 10),
                  _DenominationGrid(
                    rows: other,
                    controllerFor: _controllerFor,
                    onChanged: _onQuantityChanged,
                    quantities: _quantities,
                  ),
                ],
              ],
            ),
          ),
        ),
        _Footer(
          colors: colors,
          totalLabel: widget.totalLabel,
          submitLabel: widget.submitLabel,
          total: totalAmount,
          onSubmit: canSubmit
              ? () {
                  final breakdown = <DenominationCountEntry>[
                    for (final row in active)
                      if ((_quantities[row.id] ?? 0) > 0)
                        DenominationCountEntry(
                          denominationId: row.id,
                          label: row.description,
                          value: row.value,
                          quantity: _quantities[row.id]!,
                        ),
                  ];
                  Navigator.of(context).pop(
                    DenominationCountResult(
                      total: totalAmount,
                      lines: breakdown,
                      // Zero-count rows still matter to the server: an empty
                      // denomination table is a real count ("nothing of this
                      // bill in the drawer"), not the absence of one, so
                      // every ACTIVE row is included here even at quantity 0.
                      allActiveLines: [
                        for (final row in active)
                          DenominationCountEntry(
                            denominationId: row.id,
                            label: row.description,
                            value: row.value,
                            quantity: _quantities[row.id] ?? 0,
                          ),
                      ],
                    ),
                  );
                }
              : null,
        ),
      ],
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({
    required this.colors,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final AppColors colors;
  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: colors.border,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: colors.primary.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, size: 26, color: colors.primary),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTypography.display(
                        color: colors.textPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: AppTypography.ui(
                        color: colors.textSecondary,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                width: 48,
                height: 48,
                child: IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: Icon(
                    Icons.close_rounded,
                    size: 26,
                    color: colors.textSecondary,
                  ),
                  tooltip: 'Close',
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label, required this.colors});

  final String label;
  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: AppTypography.ui(
        color: colors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.4,
      ),
    );
  }
}

class _DenominationGrid extends StatelessWidget {
  const _DenominationGrid({
    required this.rows,
    required this.controllerFor,
    required this.onChanged,
    required this.quantities,
  });

  final List<DenominationsTableData> rows;
  final TextEditingController Function(int) controllerFor;
  final void Function(int, String) onChanged;
  final Map<int, int> quantities;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: rows.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        mainAxisExtent: 122,
      ),
      itemBuilder: (context, index) {
        final row = rows[index];
        return _DenominationCell(
          label: row.description,
          unitValue: row.value,
          controller: controllerFor(row.id),
          onChanged: (raw) => onChanged(row.id, raw),
        );
      },
    );
  }
}

class _DenominationCell extends StatelessWidget {
  const _DenominationCell({
    required this.label,
    required this.unitValue,
    required this.controller,
    required this.onChanged,
  });

  final String label;
  final int unitValue;
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  int get _quantity => int.tryParse(controller.text) ?? 0;

  void _setQuantity(int next) {
    final clamped = next < 0 ? 0 : next;
    controller.text = clamped.toString();
    onChanged(controller.text);
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final active = _quantity > 0;

    return Container(
      padding: const EdgeInsets.fromLTRB(12, 10, 12, 10),
      decoration: BoxDecoration(
        color: active
            ? colors.primary.withValues(alpha: 0.08)
            : colors.surfaceVariant,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: active ? colors.primary.withValues(alpha: 0.4) : colors.border,
          width: active ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: AppTypography.ui(
              color: colors.textPrimary,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StepperButton(
                icon: Icons.remove_rounded,
                onPressed: _quantity > 0
                    ? () => _setQuantity(_quantity - 1)
                    : null,
              ),
              SizedBox(
                width: 52,
                height: 44,
                child: TextField(
                  controller: controller,
                  onChanged: onChanged,
                  textAlign: TextAlign.center,
                  keyboardType: TextInputType.number,
                  inputFormatters: [FilteringTextInputFormatter.digitsOnly],
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: colors.surface,
                    contentPadding: EdgeInsets.zero,
                    hintText: '0',
                    hintStyle: AppTypography.ui(
                      color: colors.textDisabled,
                      fontSize: 18,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.border),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: colors.primary, width: 2),
                    ),
                  ),
                ),
              ),
              _StepperButton(
                icon: Icons.add_rounded,
                onPressed: () => _setQuantity(_quantity + 1),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({required this.icon, required this.onPressed});

  final IconData icon;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final enabled = onPressed != null;

    return Material(
      color: enabled
          ? colors.primary.withValues(alpha: 0.12)
          : colors.disabledFill,
      borderRadius: BorderRadius.circular(10),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(10),
        child: SizedBox(
          width: 44,
          height: 44,
          child: Icon(
            icon,
            size: 20,
            color: enabled ? colors.primary : colors.textDisabled,
          ),
        ),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  const _Footer({
    required this.colors,
    required this.totalLabel,
    required this.submitLabel,
    required this.total,
    required this.onSubmit,
  });

  final AppColors colors;
  final String totalLabel;
  final String submitLabel;
  final int total;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 24),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(top: BorderSide(color: colors.border)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: colors.primary.withValues(alpha: 0.10),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  totalLabel,
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  '₱${total.toString()}',
                  style: AppTypography.display(
                    color: colors.textPrimary,
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          PosSheetButton(
            label: submitLabel,
            onPressed: onSubmit,
            background: colors.primary,
            foreground: colors.onPrimary,
          ),
        ],
      ),
    );
  }
}

class _InlineState extends StatelessWidget {
  const _InlineState({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 4, 24, 28),
      child: child,
    );
  }
}

class _ErrorContent extends StatelessWidget {
  const _ErrorContent({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.error_outline_rounded, size: 40, color: colors.danger),
        const SizedBox(height: 12),
        Text(
          'Couldn\'t load denominations',
          style: AppTypography.ui(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

class _EmptyContent extends StatelessWidget {
  const _EmptyContent({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.inbox_rounded, size: 40, color: colors.textSecondary),
        const SizedBox(height: 12),
        Text(
          'No active denominations set up yet',
          textAlign: TextAlign.center,
          style: AppTypography.ui(
            color: colors.textPrimary,
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}

/// One denomination's count in a submitted result.
class DenominationCountEntry {
  const DenominationCountEntry({
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

/// What [DenominationCountSheet.show] resolves with on submit.
class DenominationCountResult {
  const DenominationCountResult({
    required this.total,
    required this.lines,
    required this.allActiveLines,
  });

  /// Sum of all counted denominations.
  final int total;

  /// Only the denominations the user actually entered a quantity for
  /// (quantity > 0). This is what a cash-drop confirmation should show.
  final List<DenominationCountEntry> lines;

  /// EVERY active denomination, including ones counted as zero. This is what
  /// the server's shift-drawer-count payload needs: the sample payload lists
  /// all ten denominations with `"quantity":"0"` for the ones not present in
  /// the drawer, not just the nonzero ones.
  final List<DenominationCountEntry> allActiveLines;
}