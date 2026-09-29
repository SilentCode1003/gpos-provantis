import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/core/database/app_database.dart'
    show CategoriesTableData, ProductPriceTableData, SoldItemsTableData;
import 'package:gpos_provantis/src/core/database/providers/categories_dao_provider.dart';
import 'package:gpos_provantis/src/core/database/providers/product_price_dao_provider.dart';

import 'package:gpos_provantis/src/core/database/repository/sold_items_repository.dart';

import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/sold_items_controller.dart';

enum _DatePreset { today, thisWeek, thisMonth, custom }

class _DateRange {
  const _DateRange({required this.start, required this.end});
  final DateTime start;
  final DateTime end;
}

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

class SoldItemsScreen extends ConsumerStatefulWidget {
  const SoldItemsScreen({super.key});

  @override
  ConsumerState<SoldItemsScreen> createState() => _SoldItemsScreenState();
}

class _SoldItemsScreenState extends ConsumerState<SoldItemsScreen> {
  _SoldItemsFilters _filters = const _SoldItemsFilters();

  void _applyFilters() {
    final range = _filters.resolveRange();

    // The screen's range end is EXCLUSIVE (Today = 28th -> 29th), but the API
    // wants INCLUSIVE calendar days, so step the end back by one day. For a
    // single day, start == end and SoldItemsQuery sends just "2026-09-28".
    final inclusiveEnd = range.end.subtract(const Duration(days: 1));

    ref
        .read(soldItemsControllerProvider.notifier)
        .applyQuery(
          SoldItemsQuery(
            startDate: range.start,
            endDate: inclusiveEnd,
            // Names, not codes: that's what the API's category/productname
            // fields match. Null falls back to 'ALL'.
            category: _filters.category?.categoryName,
            product: _filters.product?.description,
          ),
        );
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
            child:
                ref.watch(soldItemsControllerProvider.select((s) => s.query)) ==
                    null
                ? const _SoldItemsMessage(
                    icon: Icons.filter_alt_outlined,
                    text:
                        'Choose a date range and tap Apply Filters\nto see sold items.',
                  )
                : const _SoldItemsResults(),
          ),
        ],
      ),
    );
  }
}

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
                  onAll: filters.category == null
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
                  onAll: filters.product == null
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
    final result = await _CategoryPickerSheet.show(context);
    if (result == null) return; // dismissed without choosing anything
    final category = result.value; // null means the user chose ALL
    onChanged(
      filters.copyWith(
        category: category,
        clearCategory: category == null,
        // The product list is scoped by category, so an earlier product
        // choice no longer applies.
        clearProduct: true,
      ),
    );
  }

  Future<void> _openProductPicker(BuildContext context) async {
    final result = await _ProductPickerSheet.show(
      context,
      categoryFilter: filters.category,
    );
    if (result == null) return; // dismissed without choosing anything
    final product = result.value; // null means the user chose ALL
    onChanged(
      filters.copyWith(product: product, clearProduct: product == null),
    );
  }
}

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

class _PickerField extends StatelessWidget {
  const _PickerField({
    required this.label,
    required this.value,
    required this.placeholder,
    required this.onTap,
    this.onAll,
  });

  final String label;
  final String? value;
  final String placeholder;
  final VoidCallback onTap;

  /// Resets this filter to ALL. Null while the filter is already ALL.
  final VoidCallback? onAll;

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
                  if (onAll != null)
                    Material(
                      color: colors.textPrimary,
                      borderRadius: BorderRadius.circular(999),
                      child: InkWell(
                        onTap: onAll,
                        borderRadius: BorderRadius.circular(999),
                        child: Container(
                          height: 36,
                          padding: const EdgeInsets.symmetric(horizontal: 14),
                          alignment: Alignment.center,
                          child: Text(
                            'ALL',
                            style: AppTypography.ui(
                              color: colors.surface,
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
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

class _CategoryPickerSheet extends ConsumerWidget {
  const _CategoryPickerSheet();

  /// Returns null if dismissed, or a [_PickerResult] whose value is the chosen
  /// category (null value = the user chose ALL).
  static Future<_PickerResult<CategoriesTableData>?> show(
    BuildContext context,
  ) {
    return showModalBottomSheet<_PickerResult<CategoriesTableData>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const _KeyboardSafe(child: _CategoryPickerSheet()),
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

            return _SearchablePicker<CategoriesTableData>(
              items: visible,
              scrollController: scrollController,
              titleOf: (category) => category.categoryName,
              searchHint: 'Search categories',
              allTitle: 'ALL CATEGORIES',
              allSubtitle: 'Show sold items from every category',
              emptyText: 'No categories yet.',
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

  /// Returns null if dismissed, or a [_PickerResult] whose value is the chosen
  /// product (null value = the user chose ALL).
  static Future<_PickerResult<ProductPriceTableData>?> show(
    BuildContext context, {
    CategoriesTableData? categoryFilter,
  }) {
    return showModalBottomSheet<_PickerResult<ProductPriceTableData>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => _KeyboardSafe(
        child: _ProductPickerSheet(categoryFilter: categoryFilter),
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productsAsync = ref.watch(productPriceProvider);
    final category = categoryFilter;

    return _PickerSheetScaffold(
      title: category == null
          ? 'Select product'
          : 'Select product · ${category.categoryName}',
      builder: (context, scrollController) {
        return productsAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (error, _) => _SoldItemsMessage(
            icon: Icons.error_outline_rounded,
            text: 'Could not load products.\n$error',
          ),
          data: (products) {
            // Copy before sorting so the provider's own list isn't mutated.
            final filtered = List.of(
              category == null
                  ? products
                  : products.where((p) => p.category == category.categoryCode),
            )..sort((a, b) => a.description.compareTo(b.description));

            return _SearchablePicker<ProductPriceTableData>(
              items: filtered,
              scrollController: scrollController,
              titleOf: (product) => product.description,
              subtitleOf: (product) => product.barcode,
              searchHint: 'Search name or barcode',
              allTitle: 'ALL PRODUCTS',
              allSubtitle: category == null
                  ? 'Show sold items for every product'
                  : 'Every product in ${category.categoryName}',
              emptyText: category == null
                  ? 'No products yet.'
                  : 'No products in this category.',
            );
          },
        );
      },
    );
  }
}

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

class _PickerTile extends StatelessWidget {
  const _PickerTile({
    required this.title,
    this.subtitle,
    required this.onTap,
    this.emphasized = false,
  });

  final String title;
  final String? subtitle;
  final VoidCallback onTap;

  /// Draws an outline and bolder title. Used for the ALL option so it stands
  /// apart from the regular choices.
  final bool emphasized;

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
          decoration: emphasized
              ? BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: colors.textPrimary, width: 1.5),
                )
              : null,
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
                        fontWeight: emphasized
                            ? FontWeight.w700
                            : FontWeight.w600,
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

/// What a picker sheet returns.
///
/// `showModalBottomSheet` yields null when the sheet is dismissed, which must
/// mean "change nothing". Choosing ALL is a real choice, so it is returned as
/// a [_PickerResult] whose [value] is null.
class _PickerResult<T> {
  const _PickerResult(this.value);

  /// The chosen item, or null for ALL.
  final T? value;
}

/// Lifts a bottom sheet above the on-screen keyboard so the search field and
/// results stay visible while typing.
class _KeyboardSafe extends StatelessWidget {
  const _KeyboardSafe({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.viewInsetsOf(context).bottom),
      child: child,
    );
  }
}

/// Search box + pinned ALL option + filtered list, shared by the category and
/// product pickers.
class _SearchablePicker<T> extends StatefulWidget {
  const _SearchablePicker({
    required this.items,
    required this.scrollController,
    required this.titleOf,
    required this.searchHint,
    required this.allTitle,
    required this.allSubtitle,
    required this.emptyText,
    this.subtitleOf,
  });

  final List<T> items;
  final ScrollController scrollController;
  final String Function(T item) titleOf;

  /// Also searched, e.g. a product's barcode.
  final String? Function(T item)? subtitleOf;
  final String searchHint;
  final String allTitle;
  final String allSubtitle;

  /// Shown when there is nothing to pick at all (not when a search has no hits).
  final String emptyText;

  @override
  State<_SearchablePicker<T>> createState() => _SearchablePickerState<T>();
}

class _SearchablePickerState<T> extends State<_SearchablePicker<T>> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String get _query => _searchController.text.trim();

  List<T> _visibleItems() {
    final q = _query.toLowerCase();
    if (q.isEmpty) return widget.items;
    return widget.items.where((item) {
      final title = widget.titleOf(item).toLowerCase();
      final subtitle = widget.subtitleOf?.call(item)?.toLowerCase() ?? '';
      return title.contains(q) || subtitle.contains(q);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final visible = _visibleItems();
    final hasQuery = _query.isNotEmpty;

    OutlineInputBorder border(Color color, {double width = 1}) {
      return OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: color, width: width),
      );
    }

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 12),
          child: TextField(
            controller: _searchController,
            onChanged: (_) => setState(() {}),
            textInputAction: TextInputAction.search,
            style: AppTypography.ui(color: colors.textPrimary, fontSize: 15),
            decoration: InputDecoration(
              hintText: widget.searchHint,
              hintStyle: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 15,
              ),
              prefixIcon: Icon(
                Icons.search_rounded,
                color: colors.textSecondary,
              ),
              suffixIcon: hasQuery
                  ? IconButton(
                      onPressed: () {
                        _searchController.clear();
                        setState(() {});
                      },
                      icon: Icon(
                        Icons.close_rounded,
                        color: colors.textSecondary,
                      ),
                    )
                  : null,
              filled: true,
              fillColor: colors.surfaceVariant,
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 14,
              ),
              border: border(colors.border),
              enabledBorder: border(colors.border),
              focusedBorder: border(colors.textPrimary, width: 1.5),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 8),
          child: _PickerTile(
            title: widget.allTitle,
            subtitle: widget.allSubtitle,
            emphasized: true,
            onTap: () => Navigator.of(context).pop(_PickerResult<T>(null)),
          ),
        ),
        Expanded(
          child: visible.isEmpty
              ? _SoldItemsMessage(
                  icon: hasQuery
                      ? Icons.search_off_rounded
                      : Icons.inventory_2_outlined,
                  text: hasQuery
                      ? 'No matches for "$_query".'
                      : widget.emptyText,
                )
              : ListView.separated(
                  controller: widget.scrollController,
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 20),
                  itemCount: visible.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final item = visible[index];
                    return _PickerTile(
                      title: widget.titleOf(item),
                      subtitle: widget.subtitleOf?.call(item),
                      onTap: () =>
                          Navigator.of(context).pop(_PickerResult<T>(item)),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

class _SoldItemsResults extends ConsumerWidget {
  const _SoldItemsResults();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(soldItemsControllerProvider);
    final itemsAsync = ref.watch(soldItemsListProvider);

    return Column(
      children: [
        _StatusBanner(state: controller),
        Expanded(
          child: itemsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, _) => _SoldItemsMessage(
              icon: Icons.error_outline_rounded,
              text: 'Could not read saved sold items.\n$error',
            ),
            data: (items) {
              // First fetch for this query and nothing saved yet.
              if (items.isEmpty && controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              }
              if (items.isEmpty) {
                return _SoldItemsMessage(
                  icon: controller.status == SoldItemsFetchStatus.offlineNoData
                      ? Icons.cloud_off_rounded
                      : Icons.inventory_2_outlined,
                  text: switch (controller.status) {
                    SoldItemsFetchStatus.offlineNoData =>
                      'You are offline and this filter has not been\nsaved on this device yet.',
                    SoldItemsFetchStatus.failed =>
                      'Could not load sold items.\n${controller.error}',
                    _ => 'No sold items found for this filter.',
                  },
                );
              }

              return RefreshIndicator(
                onRefresh: () =>
                    ref.read(soldItemsControllerProvider.notifier).refresh(),
                child: ListView.separated(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                  itemCount: items.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) =>
                      _SoldItemTile(item: items[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Thin banner above the list: says when the data is a saved copy, or when a
/// refresh failed but older data is still being shown.
class _StatusBanner extends StatelessWidget {
  const _StatusBanner({required this.state});

  final SoldItemsState state;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    final String? message = switch (state.status) {
      SoldItemsFetchStatus.offlineCached =>
        'Offline - showing saved data${_updatedSuffix(state.lastFetchedAt)}',
      SoldItemsFetchStatus.failed => 'Could not refresh - showing saved data',
      _ => null,
    };

    if (state.isLoading) {
      return const LinearProgressIndicator(minHeight: 3);
    }
    if (message == null) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      color: colors.surfaceVariant,
      child: Row(
        children: [
          Icon(Icons.cloud_off_rounded, size: 18, color: colors.textSecondary),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: AppTypography.ui(
                color: colors.textSecondary,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }

  static String _updatedSuffix(DateTime? t) {
    if (t == null) return '';
    String two(int n) => n.toString().padLeft(2, '0');
    return ' (updated ${t.year}-${two(t.month)}-${two(t.day)} '
        '${two(t.hour)}:${two(t.minute)})';
  }
}

class _SoldItemTile extends StatelessWidget {
  const _SoldItemTile({required this.item});

  final SoldItemsTableData item;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: colors.border),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: AppTypography.ui(
                    color: colors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  item.category,
                  style: AppTypography.ui(
                    color: colors.textSecondary,
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${item.quantity}',
            style: AppTypography.display(
              color: item.quantity == 0
                  ? colors.textSecondary
                  : colors.textPrimary,
              fontSize: 20,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
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
