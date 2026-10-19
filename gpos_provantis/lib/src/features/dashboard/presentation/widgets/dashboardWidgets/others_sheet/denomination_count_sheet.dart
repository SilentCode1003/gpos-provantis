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

  /// Body height measured while the keyboard is closed. The layout is planned
  /// from this so it stays put while the keyboard is open.
  double? _stableBodyHeight;

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
              maxHeight: MediaQuery.of(context).size.height * 0.92,
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
                  keyboardOpen: keyboardInset > 0,
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
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Decide the layout from the keyboard-closed height and keep it
              // while the keyboard is open. Otherwise the grid would reshuffle
              // as the keyboard slides up, rebuilding the field being typed
              // into and dismissing the keyboard. With the keyboard up the
              // same layout simply scrolls.
              final keyboardOpen = MediaQuery.viewInsetsOf(context).bottom > 0;
              if (!keyboardOpen || _stableBodyHeight == null) {
                _stableBodyHeight = constraints.maxHeight;
              }

              final sections = <_DenominationSection>[
                if (coins.isNotEmpty)
                  _DenominationSection(label: 'Coins', rows: coins),
                if (bills.isNotEmpty)
                  _DenominationSection(label: 'Bills', rows: bills),
                if (other.isNotEmpty)
                  _DenominationSection(label: 'Other', rows: other),
              ];

              final plan = _planLayout(
                width: constraints.maxWidth - 48,
                height: _stableBodyHeight!,
                sectionSizes: [for (final s in sections) s.rows.length],
              );

              return SingleChildScrollView(
                // The iOS number pad has no Done key, so let a drag dismiss it.
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.fromLTRB(24, 4, 24, 4),
                child: _DenominationSections(
                  sections: sections,
                  plan: plan,
                  colors: colors,
                  controllerFor: _controllerFor,
                  onChanged: _onQuantityChanged,
                ),
              );
            },
          ),
        ),
        _Footer(
          colors: colors,
          keyboardOpen: MediaQuery.viewInsetsOf(context).bottom > 0,
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
    required this.keyboardOpen,
  });

  final AppColors colors;
  final String title;
  final String subtitle;
  final IconData icon;

  /// While the keyboard is up, drop the handle and subtitle so the counting
  /// grid keeps as much room as possible.
  final bool keyboardOpen;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 12, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (!keyboardOpen)
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
                    if (!keyboardOpen) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTypography.ui(
                          color: colors.textSecondary,
                          fontSize: 14,
                        ),
                      ),
                    ],
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

// ---------------------------------------------------------------------------
// Fit-to-screen layout
//
// Every active denomination is shown at once, without scrolling. The body
// measures the room it has, then picks the fewest columns (and the cell
// style) at which all rows still fit, and stretches the cells to use the
// space. Only if the screen is genuinely too small (e.g. a phone in
// landscape) does it fall back to the smallest cells and scroll.
// ---------------------------------------------------------------------------

enum _CellStyle {
  /// Label on the left, stepper on the right.
  row,

  /// Label on top, stepper underneath (narrower cells).
  stacked,
}

const double _kCellGap = 8;
const double _kSectionGap = 14;
const double _kLabelHeight = 16;
const double _kLabelGap = 8;
const double _kBodyVerticalPadding = 8;
const double _kControlSize = 42;
const double _kControlMaxSize = 56;
const int _kMaxColumns = 4;

const double _kRowMinWidth = 240;
const double _kRowMinHeight = 54;
const double _kRowMaxHeight = 68;

const double _kStackedMinWidth = 160;
const double _kStackedMinHeight = 84;
const double _kStackedMaxHeight = 108;

class _DenominationSection {
  const _DenominationSection({required this.label, required this.rows});

  final String label;
  final List<DenominationsTableData> rows;
}

class _FitPlan {
  const _FitPlan({
    required this.columns,
    required this.style,
    required this.cellHeight,
    required this.fits,
  });

  final int columns;
  final _CellStyle style;
  final double cellHeight;

  /// False when even the smallest cells don't fit, so the body must scroll.
  final bool fits;
}

/// Picks the most comfortable layout (fewest columns) in which every row of
/// every section fits inside [width] x [height].
_FitPlan _planLayout({
  required double width,
  required double height,
  required List<int> sectionSizes,
}) {
  final sections = sectionSizes.length;
  _FitPlan? densest;

  for (var columns = 1; columns <= _kMaxColumns; columns++) {
    final cellWidth = (width - (columns - 1) * _kCellGap) / columns;

    final _CellStyle style;
    if (cellWidth >= _kRowMinWidth) {
      style = _CellStyle.row;
    } else if (cellWidth >= _kStackedMinWidth) {
      style = _CellStyle.stacked;
    } else {
      break;
    }

    final minHeight = style == _CellStyle.row
        ? _kRowMinHeight
        : _kStackedMinHeight;
    final maxHeight = style == _CellStyle.row
        ? _kRowMaxHeight
        : _kStackedMaxHeight;

    final rows = sectionSizes.fold<int>(
      0,
      (sum, size) => sum + (size / columns).ceil(),
    );
    if (rows == 0) continue;

    final chrome =
        _kBodyVerticalPadding +
        sections * (_kLabelHeight + _kLabelGap) +
        (sections > 0 ? sections - 1 : 0) * _kSectionGap +
        (rows - sections) * _kCellGap;

    // Floor so rounding can never push the content a hair past the viewport.
    final perRow = ((height - chrome) / rows).floorToDouble();

    final plan = _FitPlan(
      columns: columns,
      style: style,
      cellHeight: perRow.clamp(minHeight, maxHeight).toDouble(),
      fits: perRow >= minHeight,
    );
    if (plan.fits) return plan;
    densest = plan;
  }

  return densest ??
      const _FitPlan(
        columns: 1,
        style: _CellStyle.stacked,
        cellHeight: _kStackedMinHeight,
        fits: false,
      );
}

class _DenominationSections extends StatelessWidget {
  const _DenominationSections({
    required this.sections,
    required this.plan,
    required this.colors,
    required this.controllerFor,
    required this.onChanged,
  });

  final List<_DenominationSection> sections;
  final _FitPlan plan;
  final AppColors colors;
  final TextEditingController Function(int) controllerFor;
  final void Function(int, String) onChanged;

  @override
  Widget build(BuildContext context) {
    final columns = plan.columns;
    final children = <Widget>[];

    for (var s = 0; s < sections.length; s++) {
      final section = sections[s];

      if (s > 0) children.add(const SizedBox(height: _kSectionGap));
      children.add(
        SizedBox(
          height: _kLabelHeight,
          child: Align(
            alignment: Alignment.centerLeft,
            child: _SectionLabel(label: section.label, colors: colors),
          ),
        ),
      );
      children.add(const SizedBox(height: _kLabelGap));

      for (var i = 0; i < section.rows.length; i += columns) {
        if (i > 0) children.add(const SizedBox(height: _kCellGap));
        children.add(
          SizedBox(
            height: plan.cellHeight,
            child: Row(
              children: [
                for (var j = 0; j < columns; j++) ...[
                  if (j > 0) const SizedBox(width: _kCellGap),
                  Expanded(
                    child: i + j < section.rows.length
                        ? _cellFor(section.rows[i + j])
                        : const SizedBox.shrink(),
                  ),
                ],
              ],
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: children,
    );
  }

  Widget _cellFor(DenominationsTableData row) {
    return _DenominationCell(
      key: ValueKey(row.id),
      style: plan.style,
      dense: plan.columns > 1,
      height: plan.cellHeight,
      label: row.description,
      controller: controllerFor(row.id),
      onChanged: (raw) => onChanged(row.id, raw),
    );
  }
}

class _DenominationCell extends StatelessWidget {
  const _DenominationCell({
    super.key,
    required this.style,
    required this.dense,
    required this.height,
    required this.label,
    required this.controller,
    required this.onChanged,
  });

  final _CellStyle style;

  /// Multi-column layouts use slightly smaller label text.
  final bool dense;

  /// The height this cell is given. The quantity box and the +/- buttons grow
  /// to use it, so they fill the cell instead of sitting at the top.
  final double height;
  final String label;
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
    final stacked = style == _CellStyle.stacked;

    final labelText = Text(
      label,
      maxLines: stacked ? 1 : 2,
      overflow: TextOverflow.ellipsis,
      style: AppTypography.ui(
        color: colors.textPrimary,
        fontSize: (dense || stacked) ? 14 : 15,
        fontWeight: FontWeight.w600,
      ),
    );

    // Size the controls to the room the cell actually has: its height minus
    // the vertical padding (and, when stacked, the label row above them).
    final verticalPadding = stacked ? 8.0 : 6.0;
    final labelAllowance = stacked ? 22.0 : 0.0;
    final controlHeight = (height - verticalPadding * 2 - labelAllowance)
        .clamp(_kControlSize, _kControlMaxSize)
        .toDouble();
    final buttonWidth = controlHeight.clamp(_kControlSize, 52.0).toDouble();

    Widget buildField({double? width}) {
      return SizedBox(
        width: width,
        height: controlHeight,
        child: TextField(
          controller: controller,
          onChanged: onChanged,
          textAlign: TextAlign.center,
          // Without `expands`, the field's filled box is only as tall as one
          // line of text and sits at the top of the SizedBox. Expanding makes
          // it fill the full height, and the number is centred inside it.
          expands: true,
          maxLines: null,
          minLines: null,
          textAlignVertical: TextAlignVertical.center,
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
      );
    }

    final minus = _StepperButton(
      icon: Icons.remove_rounded,
      width: buttonWidth,
      height: controlHeight,
      onPressed: _quantity > 0 ? () => _setQuantity(_quantity - 1) : null,
    );
    final plus = _StepperButton(
      icon: Icons.add_rounded,
      width: buttonWidth,
      height: controlHeight,
      onPressed: () => _setQuantity(_quantity + 1),
    );

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: verticalPadding),
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
      child: stacked
          ? Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                labelText,
                const SizedBox(height: 4),
                Row(
                  children: [
                    minus,
                    const SizedBox(width: 6),
                    Expanded(child: buildField()),
                    const SizedBox(width: 6),
                    plus,
                  ],
                ),
              ],
            )
          : Row(
              children: [
                Expanded(child: labelText),
                const SizedBox(width: 8),
                minus,
                const SizedBox(width: 4),
                buildField(width: 48),
                const SizedBox(width: 4),
                plus,
              ],
            ),
    );
  }
}

class _StepperButton extends StatelessWidget {
  const _StepperButton({
    required this.icon,
    required this.onPressed,
    required this.width,
    required this.height,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double width;
  final double height;

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
          width: width,
          height: height,
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
    required this.keyboardOpen,
  });

  final bool keyboardOpen;
  final AppColors colors;
  final String totalLabel;
  final String submitLabel;
  final int total;
  final VoidCallback? onSubmit;

  @override
  Widget build(BuildContext context) {
    return Container(
      // Clear the home indicator / gesture bar unless the keyboard is up.
      padding: EdgeInsets.fromLTRB(
        24,
        12,
        24,
        keyboardOpen ? 12 : 24 + MediaQuery.viewPaddingOf(context).bottom,
      ),
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
                Flexible(
                  child: Text(
                    totalLabel,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.ui(
                      color: colors.textPrimary,
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Flexible(
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      _peso(total),
                      style: AppTypography.display(
                        color: colors.textPrimary,
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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

/// 12500 -> "₱12,500"
String _peso(int value) {
  final digits = value.abs().toString().replaceAllMapped(
    RegExp(r'\B(?=(\d{3})+(?!\d))'),
    (_) => ',',
  );
  return '${value < 0 ? '-' : ''}₱$digits';
}
