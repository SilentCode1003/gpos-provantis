// Location: src/features/dashboard/presentation/widgets/dashboardWidgets/product_grid.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'dashboard_constants.dart';

/// --- Product grid: label-forward, no image placeholders --------------------

/// Lives inside `CatalogSheet` now (not the always-visible panel) —
/// reads `productsForCatalogSheet()`, which is already filtered by both
/// the sheet's open category and its search query.
///
/// LOADING: gated on `controller.productsStatus`, not on
/// `products.isEmpty` — right after login the product-price stream
/// hasn't emitted its first synced batch yet, which used to read
/// (incorrectly) as "no products in this category" and fall back to
/// placeholder inventory. Now that gap shows `_ProductGridLoadingState`
/// instead, and `_EmptyCatalog` only appears once the stream has
/// actually confirmed the (filtered) category has nothing in it.
class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider.notifier);
    // Watching state so the grid rebuilds on category swap, on every
    // keystroke in the sheet's search field, and as the products stream
    // moves from loading -> data (or -> error) after login/sync.
    ref.watch(dashboardControllerProvider);
    final status = controller.productsStatus;
    final products = controller.productsForCatalogSheet();

    if (status == CatalogLoadStatus.loading) {
      return const _ProductGridLoadingState();
    }

    if (status == CatalogLoadStatus.error) {
      return const _ProductGridErrorState();
    }

    if (products.isEmpty) {
      return const _EmptyCatalog();
    }

    return GridView.builder(
      padding: const EdgeInsets.all(20),
      gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
        maxCrossAxisExtent: 220,
        mainAxisSpacing: 16,
        crossAxisSpacing: 16,
        childAspectRatio: 1.05,
      ),
      itemCount: products.length,
      itemBuilder: (context, index) {
        return _ProductCard(product: products[index]);
      },
    );
  }
}

/// Shown while the product-price stream hasn't emitted its first value
/// yet — the gap right after login before the initial API-to-Drift sync
/// has written anything. This is what used to be masked by falling back
/// to placeholder products; now it's an honest loading state instead.
class _ProductGridLoadingState extends ConsumerWidget {
  const _ProductGridLoadingState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

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
              'Loading products…',
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown if the product-price stream itself errors — distinct from
/// `_EmptyCatalog` so a real failure doesn't silently read as "there's
/// just nothing in this category".
class _ProductGridErrorState extends ConsumerWidget {
  const _ProductGridErrorState();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'Couldn\'t load products.',
              textAlign: TextAlign.center,
              style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyCatalog extends ConsumerWidget {
  const _EmptyCatalog();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final hasQuery = ref
        .watch(dashboardControllerProvider)
        .catalogSearchQuery
        .trim()
        .isNotEmpty;

    return Center(
      child: Text(
        hasQuery
            ? 'No products match your search.'
            : 'No products in this category yet.',
        style: AppTypography.ui(color: colors.textDisabled, fontSize: 14),
      ),
    );
  }
}

/// No image placeholder — label-forward card per direction: bigger name
/// and price instead of an unpopulated image block. The whole card is one
/// large tap target (not just a small "add" button inside it), since
/// "tap the product to add it" is the entire interaction — except when
/// `stock` is 0, in which case there's nothing to add and the card is
/// disabled entirely (see OUT OF STOCK below).
class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    // OUT OF STOCK: `addToCart` itself has no stock check (it'll happily
    // add a 0-stock product if called), so the guard has to live here —
    // this is the only path a cashier has to add a product to the cart.
    final isOutOfStock = product.stock <= 0;

    // Card-to-card separation used to rely entirely on `borderSubtle`, but
    // in dark mode `borderSubtle` (neutral800) is the exact same color as
    // `surface` (also neutral800) — a border with zero contrast against
    // its own fill, i.e. invisible. First fix split fill from edge:
    //   - fill: `surfaceRaised` instead of `surface`, for luminance
    //     separation from the panel background in both modes.
    //   - edge: dark mode got a real 1.5px `border` (neutral700 vs
    //     neutral850 fill); light mode leaned on `elevation: 1` alone.
    // That light-mode shadow turned out too faint on its own — `shadow`
    // is only 12% black, and `surfaceRaised` (pure white) sits right next
    // to `background` (neutral50), so there was barely any edge to see.
    // Both modes now draw the same `colors.border` outline; the shadow
    // stays as a secondary depth cue in light mode rather than the only
    // one.
    final isDark = colors.isDark;

    // Disabled treatment mirrors `_ActionButton` elsewhere in the
    // dashboard: swap the fill for `disabledFill` and every foreground
    // color for `textDisabled`, rather than just intercepting the tap
    // and leaving the card looking fully interactive.
    final cardFill = isOutOfStock ? colors.disabledFill : colors.surfaceRaised;
    final textColor = isOutOfStock ? colors.textDisabled : colors.textPrimary;

    return Material(
      color: cardFill,
      borderRadius: BorderRadius.circular(14),
      elevation: isDark || isOutOfStock ? 0 : 1,
      shadowColor: colors.shadow,
      child: InkWell(
        onTap: isOutOfStock ? null : () => notifier.addToCart(product),
        borderRadius: BorderRadius.circular(14),
        splashColor: colors.primary.withValues(alpha: 0.12),
        highlightColor: colors.primary.withValues(alpha: 0.06),
        child: Container(
          constraints: const BoxConstraints(minHeight: primaryTapTarget),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: isOutOfStock
                ? null
                : Border.all(color: colors.border, width: 1.5),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                product.name,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
                style: AppTypography.ui(
                  color: textColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  height: 1.3,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₱${product.price.toStringAsFixed(2)}',
                    style: AppTypography.ui(
                      color: textColor,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isOutOfStock)
                    Text(
                      'Out of stock',
                      style: AppTypography.ui(
                        color: colors.textDisabled,
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
