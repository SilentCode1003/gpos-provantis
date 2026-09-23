// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/catalog_panel.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:phosphoricons_flutter/phosphoricons_flutter.dart';
import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'category_visibility.dart';
import 'others_sheet.dart';
import 'top_bar.dart';

/// --- Catalog panel (right): top bar + actions row + category grid ---------
///
/// No product grid here anymore — tapping a category opens `CatalogSheet`
/// instead, which is stacked on top of this panel by
/// `CatalogPanelWithSheet`. The category rail was removed in favor of a
/// single full grid of categories (`_CategoryGrid`) filling the space
/// below the actions row — no need for two presentations of the same
/// list once the grid covers every category without scrolling.
///
/// The actions row (Start/End shift, Cash drop, Reprint, Settings,
/// Others) used to live inside `TopBar` itself. It's a second row here
/// now so the top bar can be status-only (branch, time, shift, OR
/// number) — see `top_bar.dart`'s doc comment. Same buttons, same
/// behavior, same touchscreen-sized pill styling; only the location and
/// the widget names (`_ActionsRail`/`_ActionButton`, not
/// `_TopBarButton`) changed.

class CatalogPanel extends ConsumerWidget {
  const CatalogPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Container(
      color: colors.background,
      child: const Column(
        children: [
          TopBar(),
          _ActionsRail(),
          Expanded(child: _CategoryGrid()),
        ],
      ),
    );
  }
}

/// --- Actions row: shift toggle, cash drop, reprint, settings, others -----
///
/// Relocated from `TopBar` — same five actions, same behavior, same
/// touchscreen pill sizing (`_actionsRailTapTarget`, a step above
/// `primaryTapTarget` for the same reason the old top bar row was: this
/// cluster is tapped constantly mid-shift). Only the surrounding chrome
/// (own row, own background) is new, since it's no longer sharing space
/// with the profile icon.
class _ActionsRail extends ConsumerWidget {
  const _ActionsRail();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final state = ref.watch(dashboardControllerProvider);
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isShiftOpen = state.shiftStatus == ShiftStatus.open;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 12),
      decoration: BoxDecoration(
        color: colors.surface,
        border: Border(bottom: BorderSide(color: colors.borderSubtle)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _ActionButton(
              icon: isShiftOpen ? PhosphorIcons.stop : PhosphorIcons.play,
              label: isShiftOpen ? 'End shift' : 'Start shift',
              emphasized: !isShiftOpen,
              onTap: notifier.toggleShift,
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.cashRegister,
              label: 'Cash drop',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.printer,
              label: 'Reprint',
              enabled: isShiftOpen,
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.gear,
              label: 'Settings',
              onTap: () {},
            ),
            const SizedBox(width: 10),
            _ActionButton(
              icon: PhosphorIcons.gridNine,
              label: 'Others',
              enabled: isShiftOpen,
              onTap: () => OthersSheet.show(context),
            ),
          ],
        ),
      ),
    );
  }
}

/// A step above [primaryTapTarget] — touchscreen POS, and every button in
/// this row (shift toggle, cash drop, reprint, others) is a
/// high-frequency action, so it errs on the side of bigger rather than
/// sitting at the shared cross-app floor. Scoped to this row only, same
/// as the old `_topBarTapTarget` it replaces — deliberately not a change
/// to `primaryTapTarget` itself, which other screens still rely on at
/// its original size.
const double _actionsRailTapTarget = 72;

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    this.emphasized = false,
    this.enabled = true,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool emphasized;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final fill = emphasized ? AppPalette.teal500 : colors.surfaceVariant;
    final foreground = emphasized ? colors.onPrimary : colors.textPrimary;

    return Material(
      color: enabled ? fill : colors.disabledFill,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: enabled ? onTap : null,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          height: _actionsRailTapTarget,
          padding: const EdgeInsets.symmetric(horizontal: 20),
          alignment: Alignment.center,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 26,
                color: enabled ? foreground : colors.textDisabled,
              ),
              const SizedBox(width: 10),
              Text(
                label,
                style: AppTypography.ui(
                  color: enabled ? foreground : colors.textDisabled,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Fills the space below the actions row with every category, split into
/// two labeled groups: "Paint" (any category whose name contains "Paint")
/// and "Products" (everything else). This is a purely presentational
/// grouping — `Category` has no group/type field of its own, so the split
/// is done here by inspecting `category.name`, not by anything stored in
/// the controller/model. If a real category-group concept is ever added
/// server-side, this is the place to swap the name-sniffing below for a
/// real field.
///
/// Tiles are flat/uniform (see `_CategoryTile`), not highlighted-on-
/// selection like the old rail: tapping one always opens `CatalogSheet`,
/// it's an action rather than a togglable filter, so there's no
/// "currently active" state worth drawing attention to here.
///
/// LOADING: gated on `controller.categoriesStatus`, not on
/// `categories.isEmpty` — right after login the Drift stream hasn't
/// emitted yet, which used to read (incorrectly) as "no categories" and
/// fall back to placeholder data. Now that gap shows `_CatalogLoadingState`
/// instead, and `_CatalogEmptyState` only appears once the stream has
/// actually confirmed there's nothing there.
///
/// HIDDEN CATEGORIES: categories the user switched off in Settings >
/// Counter Display are filtered out before grouping (see
/// `category_visibility.dart`). If that leaves nothing, `_CatalogAllHiddenState`
/// says so — deliberately different from "No categories yet" so it never
/// reads as a failed sync.
class _CategoryGrid extends ConsumerWidget {
  const _CategoryGrid();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    // Watching state so this rebuilds as the categories stream moves
    // from loading -> data (or -> error) after login/sync.
    ref.watch(dashboardControllerProvider);
    final controller = ref.watch(dashboardControllerProvider.notifier);
    final status = controller.categoriesStatus;
    final hidden = ref.watch(hiddenCategoryCodesProvider);
    // Wait for the settings row too, so a hidden category never flashes
    // on screen for a frame before the setting has loaded.
    final settingsLoading = ref.watch(
      appSettingsProvider.select((s) => s.isLoading && !s.hasValue),
    );
    final allCategories = controller.categories;
    final categories = filterVisibleCategories(allCategories, hidden);

    // Still syncing from the API into Drift — show a spinner rather than
    // "No categories yet", which previously got shown (briefly, or not
    // so briefly on a slow connection) right after login before the
    // first batch of categories had synced.
    if (status == CatalogLoadStatus.loading || settingsLoading) {
      return _CatalogLoadingState(colors: colors);
    }

    if (status == CatalogLoadStatus.error) {
      return _CatalogErrorState(colors: colors);
    }

    if (categories.isEmpty) {
      // Categories exist, but every one of them is switched off.
      return allCategories.isEmpty
          ? _CatalogEmptyState(colors: colors)
          : _CatalogAllHiddenState(colors: colors);
    }

    // Artificial grouping: anything with "Paint" in its name goes in the
    // Paint group; everything else falls into Products. Case-insensitive
    // so 'paint', 'Paint', 'PAINT' all match the same way.
    final paintCategories = <Category>[];
    final productCategories = <Category>[];
    for (final category in categories) {
      if (category.name.toLowerCase().contains('paint')) {
        paintCategories.add(category);
      } else {
        productCategories.add(category);
      }
    }

    return CustomScrollView(
      slivers: [
        if (paintCategories.isNotEmpty) ...[
          _GroupHeader(label: 'Paint'),
          _CategorySliverGrid(
            categories: paintCategories,
            onTap: controller.selectCategory,
          ),
        ],
        if (productCategories.isNotEmpty) ...[
          _GroupHeader(label: 'Products'),
          _CategorySliverGrid(
            categories: productCategories,
            onTap: controller.selectCategory,
          ),
        ],
        // Trailing breathing room so the last row isn't flush with the
        // bottom edge of the panel.
        const SliverToBoxAdapter(child: SizedBox(height: 20)),
      ],
    );
  }
}

/// Section label above each group ("Paint" / "Products") — plain text,
/// no card/background, just enough to separate the two groups visually.
class _GroupHeader extends StatelessWidget {
  const _GroupHeader({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;

    return SliverToBoxAdapter(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
        child: Text(
          label,
          style: AppTypography.ui(
            color: colors.textSecondary,
            fontSize: 13,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.4,
          ),
        ),
      ),
    );
  }
}

/// The grid of tiles for one group — same sizing/spacing as the old
/// single grid, just scoped to whichever subset of categories belongs to
/// this group.
class _CategorySliverGrid extends StatelessWidget {
  const _CategorySliverGrid({required this.categories, required this.onTap});

  final List<Category> categories;
  final ValueChanged<String> onTap;

  @override
  Widget build(BuildContext context) {
    return SliverPadding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
          maxCrossAxisExtent: 160,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: 1.1,
        ),
        delegate: SliverChildBuilderDelegate((context, index) {
          final category = categories[index];
          return _CategoryTile(
            category: category,
            onTap: () => onTap(category.id),
          );
        }, childCount: categories.length),
      ),
    );
  }
}

/// Shown while the categories stream hasn't emitted its first value yet —
/// the gap right after login before the initial API-to-Drift sync has
/// written anything. This is what used to be masked by falling back to
/// placeholder categories; now it's an honest loading state instead.
class _CatalogLoadingState extends StatelessWidget {
  const _CatalogLoadingState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: colors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Loading categories…',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown if the categories stream itself errors (e.g. the local Drift
/// query fails) — distinct from `_CatalogEmptyState` so a real failure
/// doesn't silently read as "there just aren't any categories".
class _CatalogErrorState extends StatelessWidget {
  const _CatalogErrorState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              PhosphorIcons.exclamationMark,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load categories.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown only if the category list itself is empty — an edge case the old
/// placeholder never had to distinguish from "sheet just isn't open yet",
/// since that's now the grid's default (non-empty) state.
class _CatalogEmptyState extends StatelessWidget {
  const _CatalogEmptyState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(PhosphorIcons.shapes, size: 40, color: colors.textDisabled),
            const SizedBox(height: 12),
            Text(
              'No categories yet',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when categories exist but the user has turned every one of them
/// off in Settings > Counter Display.
class _CatalogAllHiddenState extends StatelessWidget {
  const _CatalogAllHiddenState({required this.colors});

  final AppColors colors;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.visibility_off_rounded,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'All categories are hidden.\n'
              'Turn them on in Settings > Counter Display.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  static const _iconMap = {
    'water_drop_rounded': PhosphorIcons.chatTeardrop,
    'account_balance_rounded': PhosphorIcons.money,
    'landscape_rounded': PhosphorIcons.island,
    'chair_rounded': PhosphorIcons.chair,
    'yard_rounded': PhosphorIcons.park,
    'park_rounded': PhosphorIcons.park,
    'format_paint_rounded': PhosphorIcons.paintBrush,
  };

  @override
  Widget build(BuildContext context) {
    final colors = context.colors;
    final icon = _iconMap[category.icon] ?? PhosphorIcons.shapes;

    // Flat, uniform styling — no "selected" state. Every tile does the
    // same thing (opens the catalog sheet for that category), so there's
    // nothing here that should read as toggled on/off the way a product
    // card or a filter chip would.
    return Material(
      color: colors.surfaceVariant,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          width: 116,
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 26, color: colors.textSecondary),
              const SizedBox(height: 8),
              Text(
                category.name,
                textAlign: TextAlign.center,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: colors.textSecondary,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  height: 1.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
