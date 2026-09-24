// Location: src/features/dashboard/presentation/screens/sold_items_screen.dart
//
// Lets a cashier/manager look up what sold in a given window, filtered
// by date range, category, and/or a single product. Visually this
// mirrors receipts_screen.dart on purpose (same card shape, spacing,
// typography, date badge) so the two screens read as one family, but
// the interaction model is different: receipts is a live, unfiltered
// feed; sold items is a query the person builds and then runs.
//
// TOUCHSCREEN POS LAYOUT: same rules as ReceiptsScreen — every tappable
// thing here is sized for a finger on a fixed terminal, not a mouse.
// Date range is chip presets (Today / This Week / This Month / Custom)
// rather than typing dates. Category and Product are big bottom-sheet
// pickers rather than native Material dropdowns, because a
// DropdownButton's menu renders with small, mouse-scaled touch targets
// that are easy to mis-tap on a POS screen. Filters do NOT auto-apply —
// changing a chip or picker only stages the filter; results only
// refresh when the cashier taps "Apply Filters", so a stray tap while
// scrolling never fires a query, and switching several filters in a
// row (date, then category, then product) doesn't reload the list on
// every intermediate step.
//
// DATA SOURCE: there is no sold-items query in the DAO layer yet — see
// the TODO on `_SoldItemsResults`. The filter chrome below is complete
// and real (wired to `categoriesProvider` / `productPriceProvider` for
// the picker options); only the final "run the query" call is a stub,
// so plugging in a real DAO method later is a single-method swap, not
// a screen rewrite.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show CategoriesTableData, ProductPriceTableData;
import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';

enum _DatePreset { today, thisWeek, thisMonth, custom }

class _DateRange {
  const _DateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

/// Staged filter state — what the person has picked but not yet run.
class _SoldItemsFilters {
  const _SoldItemsFilters({
    this.preset = _DatePreset.today,
    this.customRange,
    this.category,
    this.product,
  });

  final _DatePreset preset;
  final _DateRange? customRange;
  final CategoriesTableData? category;
  final ProductPriceTableData? product;

  _DateRange resolveRange() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    switch (preset) {
      case _DatePreset.today:
        return _DateRange(
          start: today,
          end: today.add(const Duration(days: 1)),
        );
      case _DatePreset.thisWeek:
        final startOfWeek = today.subtract(Duration(days: today.weekday - 1));
        return _DateRange(
          start: startOfWeek,
          end: startOfWeek.add(const Duration(days: 7)),
        );
      case _DatePreset.thisMonth:
        final startOfMonth = DateTime(now.year, now.month, 1);
        final startOfNextMonth = DateTime(now.year, now.month + 1, 1);
        return _DateRange(start: startOfMonth, end: startOfNextMonth);
      case _DatePreset.custom:
        return customRange ??
            _DateRange(start: today, end: today.add(const Duration(days: 1)));
    }
  }

  _SoldItemsFilters copyWith({
    _DatePreset? preset,
    _DateRange? customRange,
    bool clearCustomRange = false,
    CategoriesTableData? category,
    bool clearCategory = false,
    ProductPriceTableData? product,
    bool clearProduct = false,
  }) {
    return _SoldItemsFilters(
      preset: preset ?? this.preset,
      customRange: clearCustomRange ? null : (customRange ?? this.customRange),
      category: clearCategory ? null : (category ?? this.category),
      product: clearProduct ? null : (product ?? this.product),
    );
  }
}

/// What's actually been searched for. Null until "Apply Filters" is
/// tapped the first time.
class _AppliedQuery {
  const _AppliedQuery({required this.range, this.category, this.product});
  final _DateRange range;
  final CategoriesTableData? category;
  final ProductPriceTableData? product;
}

class SoldItemsScreen extends ConsumerStatefulWidget {
  const SoldItemsScreen({super.key});

  @override
  ConsumerState<SoldItemsScreen> createState() => _SoldItemsScreenState();
}

class _SoldItemsScreenState extends ConsumerState<SoldItemsScreen> {
  _SoldItemsFilters _filters = const _SoldItemsFilters();
  _AppliedQuery? _applied;

  void _applyFilters() {
    setState(() {
      _applied = _AppliedQuery(
        range: _filters.resolveRange(),
        category: _filters.category,
        product: _filters.product,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Scaffold(
      backgroundColor: colors.background,
      appBar: AppBar(
        title: Text(
          'Sold Items',
          style: AppTypography.display(
            color: colors.textPrimary,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
        backgroundColor: colors.surface,
      ),
      body: Column(
        children: [
          _FiltersPanel(
            filters: _filters,
            onChanged: (next) => setState(() => _filters = next),
            onApply: _applyFilters,
          ),
          Expanded(
            child: _applied == null
                ? const _SoldItemsMessage(
                    icon: Icons.filter_alt_outlined,
                    text:
                        'Choose a date range and tap Apply Filters\nto see sold items.',
                  )
                : _SoldItemsResults(query: _applied!),
          ),
        ],
      ),
    );
  }
}

/// Sticky filter panel: date presets, category picker, product picker,
/// Apply button. Kept as one card so it reads as a single control
/// surface separate from the results feed below it.
class _FiltersPanel extends StatelessWidget {
  const _FiltersPanel({
    required this.filters,
    required this.onChanged,
    required this.onApply,
  });

  final _SoldItemsFilters filters;
  final ValueChanged<_SoldItemsFilters> onChanged;
  final VoidCallback onApply;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'DATE RANGE',
            style: AppTypography.ui(
              color: colors.textSecondary,
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          _DatePresetRow(filters: filters, onChanged: onChanged),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: _PickerField(
                  label: 'CATEGORY',
                  value: filters.category?.categoryName,
                  placeholder: 'All categories',
                  onTap: () => _openCategoryPicker(context),
                  onClear: filters.category == null
                      ? null
                      : () => onChanged(
                          filters.copyWith(
                            clearCategory: true,
                            clearProduct: true,
                          ),
                        ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _PickerField(
                  label: 'PRODUCT',
                  value: filters.product?.description,
                  placeholder: 'All products',
                  onTap: () => _openProductPicker(context),
                  onClear: filters.product == null
                      ? null
                      : () => onChanged(filters.copyWith(clearProduct: true)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 56,
            child: FilledButton.icon(
              onPressed: onApply,
              icon: const Icon(Icons.search_rounded),
              label: Text(
                'APPLY FILTERS',
                style: AppTypography.ui(
                  fontSize: 15,
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
        ],
      ),
    );
  }

  Future<void> _openCategoryPicker(BuildContext context) async {
    final selected = await _CategoryPickerSheet.show(context);
    if (selected != null) {
      // A fresh category invalidates whatever product was picked under
      // the old one, so the two filters never silently disagree.
      onChanged(filters.copyWith(category: selected, clearProduct: true));
    }
  }

  Future<void> _openProductPicker(BuildContext context) async {
    final selected = await _ProductPickerSheet.show(
      context,
      categoryFilter: filters.category,
    );
    if (selected != null) {
      onChanged(filters.copyWith(product: selected));
    }
  }
}

/// Four large chips, one row, equal width — the whole chip is the tap
/// target, not a radio dot inside it.
class _DatePresetRow extends StatelessWidget {
  const _DatePresetRow({required this.filters, required this.onChanged});

  final _SoldItemsFilters filters;
  final ValueChanged<_SoldItemsFilters> onChanged;

  static const _labels = {
    _DatePreset.today: 'Today',
    _DatePreset.thisWeek: 'This Week',
    _DatePreset.thisMonth: 'This Month',
    _DatePreset.custom: 'Custom',
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      children: _DatePreset.values.map((preset) {
        final isLast = preset == _DatePreset.values.last;
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(right: isLast ? 0 : 8),
            child: _PresetChip(
              label: _labels[preset]!,
              selected: filters.preset == preset,
              onTap: () async {
                if (preset == _DatePreset.custom) {
                  final range = await _pickCustomRange(context, filters);
                  if (range != null) {
                    onChanged(
                      filters.copyWith(preset: preset, customRange: range),
                    );
                  }
                } else {
                  onChanged(filters.copyWith(preset: preset));
                }
              },
            ),
          ),
        );
      }).toList(),
    );
  }

  Future<_DateRange?> _pickCustomRange(
    BuildContext context,
    _SoldItemsFilters filters,
  ) async {
    final now = DateTime.now();
    final initial = filters.customRange;
    final result = await showDateRangePicker(
      context: context,
      firstDate: DateTime(now.year - 2),
      lastDate: DateTime(now.year + 1),
      initialDateRange: initial == null
          ? null
          : DateTimeRange(
              start: initial.start,
              end: initial.end.subtract(const Duration(days: 1)),
            ),
    );
    if (result == null) return null;
    // End is exclusive internally (start of the day *after* the picked
    // end date) so range comparisons downstream stay half-open.
    return _DateRange(
      start: DateTime(result.start.year, result.start.month, result.start.day),
      end: DateTime(
        result.end.year,
        result.end.month,
        result.end.day,
      ).add(const Duration(days: 1)),
    );
  }
}

class _PresetChip extends StatelessWidget {
  const _PresetChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: selected ? colors.textPrimary : colors.surfaceVariant,
      borderRadius: BorderRadius.circular(12),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Container(
          height: 48,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: selected ? null : Border.all(color: colors.border),
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: AppTypography.ui(
              color: selected ? colors.surface : colors.textPrimary,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      ),
    );
  }
}

/// Looks like a dropdown but opens a full bottom-sheet picker instead
/// of a native menu — same reasoning as the preset chips: bigger,
/// more forgiving tap targets than a compact Material dropdown menu.
class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.onClear,
  });

  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;
  final VoidCallback? onClear;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final hasValue = value != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.ui(
            color: colors.textSecondary,
            fontSize: 12,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Material(
          color: colors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: onTap,
            child: Container(
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: colors.border),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(
                      value ?? placeholder,
                      overflow: TextOverflow.ellipsis,
                      style: AppTypography.ui(
                        color: hasValue
                            ? colors.textPrimary
                            : colors.textSecondary,
                        fontSize: 14,
                        fontWeight: hasValue
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
                  ),
                  if (onClear != null)
                    InkWell(
                      onTap: onClear,
                      borderRadius: BorderRadius.circular(999),
                      child: Padding(
                        padding: const EdgeInsets.all(4),
                        child: Icon(
                          Icons.close_rounded,
                          size: 18,
                          color: colors.textSecondary,
                        ),
                      ),
                    )
                  else
                    Icon(
                      Icons.expand_more_rounded,
                      size: 20,
                      color: colors.textSecondary,
                    ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

/// Full-height list picker, same sheet chrome (grabber, title, close)
/// as ReceiptsScreen's preview sheet, so pickers feel like the same app.
class _CategoryPickerSheet extends ConsumerWidget {
  const _CategoryPickerSheet();

  static Future<CategoriesTableData?> show(BuildContext context) {
    return showModalBottomSheet<CategoriesTableData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _CategoryPickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final categoriesAsync = ref.watch(categoriesProvider);

    return _PickerSheetScaffold(
      title: 'Select category',
      builder: (context, scrollController) {
        return categoriesAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SoldItemsMessage(
            icon: Icons.error_outline_rounded,
            text: 'Could not load categories.\n$error',
          ),
          data: (categories) {
            final visible = categories.where((c) => c.isDisplay != 0).toList()
              ..sort((a, b) => a.categoryName.compareTo(b.categoryName));

            if (visible.isEmpty) {
              return const _SoldItemsMessage(
                icon: Icons.category_outlined,
                text: 'No categories yet.',
              );
            }

            return ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              itemCount: visible.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final category = visible[index];
                return _PickerTile(
                  title: category.categoryName,
                  onTap: () => Navigator.of(context).pop(category),
                );
              },
            );
          },
        );
      },
    );
  }
}

class _ProductPickerSheet extends ConsumerWidget {
  const _ProductPickerSheet({this.categoryFilter});

  final CategoriesTableData? categoryFilter;

  static Future<ProductPriceTableData?> show(
    BuildContext context, {
    CategoriesTableData? categoryFilter,
  }) {
    return showModalBottomSheet<ProductPriceTableData>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _ProductPickerSheet(categoryFilter: categoryFilter),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productPriceProvider);

    return _PickerSheetScaffold(
      title: categoryFilter == null
          ? 'Select product'
          : 'Select product · ${categoryFilter!.categoryName}',
      builder: (context, scrollController) {
        return productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SoldItemsMessage(
            icon: Icons.error_outline_rounded,
            text: 'Could not load products.\n$error',
          ),
          data: (products) {
            final filtered =
                (categoryFilter == null
                      ? products
                      : products
                            .where(
                              (p) => p.category == categoryFilter!.categoryCode,
                            )
                            .toList())
                  ..sort((a, b) => a.description.compareTo(b.description));

            if (filtered.isEmpty) {
              return const _SoldItemsMessage(
                icon: Icons.inventory_2_outlined,
                text: 'No products in this category.',
              );
            }

            return ListView.separated(
              controller: scrollController,
              padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
              itemCount: filtered.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final product = filtered[index];
                return _PickerTile(
                  title: product.description,
                  subtitle: product.barcode,
                  onTap: () => Navigator.of(context).pop(product),
                );
              },
            );
          },
        );
      },
    );
  }
}

/// Sheet chrome (grabber, title, close) around a scrollable body.
///
/// `builder` receives the sheet's own `ScrollController` and must hand
/// it to exactly one scrollable widget (typically a `ListView`) inside
/// an `Expanded`. Do NOT nest that list inside another `ListView` or
/// `SingleChildScrollView` here — a sliver-based list placed as a lone
/// child of another sliver list has no bounded height to lay out
/// against, which is what was throwing `child.hasSize` / repaint
/// boundary layout errors when this scaffold used to wrap `child` in
/// its own outer `ListView`.
class _PickerSheetScaffold extends StatelessWidget {
  const _PickerSheetScaffold({required this.title, required this.builder});

  final String title;
  final Widget Function(BuildContext context, ScrollController scrollController)
  builder;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return DraggableScrollableSheet(
      initialChildSize: 0.75,
      minChildSize: 0.4,
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
                        title,
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
              Expanded(child: builder(context, scrollController)),
            ],
          ),
        );
      },
    );
  }
}

/// One row in a picker sheet — 56px tall minimum, full-width tap area,
/// matching the receipts list tile's "whole card is the button" rule.
class _PickerTile extends StatelessWidget {
  const _PickerTile({required this.title, this.subtitle, required this.onTap});

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: onTap,
        child: Container(
          constraints: const BoxConstraints(minHeight: 56),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: AppTypography.ui(
                        color: colors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (subtitle != null && subtitle!.isNotEmpty) ...[
                      const SizedBox(height: 2),
                      Text(
                        subtitle!,
                        style: AppTypography.ui(
                          color: colors.textSecondary,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: colors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Results for the applied query. There is no sold-items DAO yet, so
/// this renders the empty state until that lands.
///
/// TODO(sold-items-data): replace this stub with a real query, e.g. a
/// `SoldItemsDao.watchSoldItems({range, categoryCode, productId})`
/// built the same way `SalesDao` / `ProductPriceDao` are — a Drift
/// query joining sales line items to `product_price_table` /
/// `categories_table`, filtered by `query.range`, `query.category`,
/// and `query.product`. Once that exists, swap the `data: []` below
/// for `ref.watch(soldItemsProvider(query))` and feed real rows into
/// `_SoldItemTile`.
class _SoldItemsResults extends ConsumerWidget {
  const _SoldItemsResults({required this.query});

  final _AppliedQuery query;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Stub result set — always empty until the DAO exists.
    final List<Never> data = const [];

    if (data.isEmpty) {
      return _SoldItemsMessage(
        icon: Icons.inventory_2_outlined,
        text: 'No sold items found for this filter.',
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
      itemCount: data.length,
      separatorBuilder: (_, _) => const SizedBox(height: 12),
      itemBuilder: (context, index) => const SizedBox.shrink(),
    );
  }
}

class _SoldItemsMessage extends StatelessWidget {
  const _SoldItemsMessage({required this.icon, required this.text});

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 48, color: colors.textSecondary),
            const SizedBox(height: 16),
            Text(
              text,
              textAlign: TextAlign.center,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
