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
class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider.notifier);
    // Watching state so the grid rebuilds on category swap and on every
    // keystroke in the sheet's search field.
    ref.watch(dashboardControllerProvider);
    final products = controller.productsForCatalogSheet();

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
/// "tap the product to add it" is the entire interaction.
class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);
    final isLowStock = product.stock <= 5;

    return Material(
      color: colors.surface,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: () => notifier.addToCart(product),
        borderRadius: BorderRadius.circular(14),
        child: Container(
          constraints: const BoxConstraints(minHeight: primaryTapTarget),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: colors.borderSubtle, width: 1.5),
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
                  color: colors.textPrimary,
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
                    '\$${product.price.toStringAsFixed(2)}',
                    style: AppTypography.ui(
                      color: colors.textPrimary,
                      fontSize: 17,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (isLowStock)
                    Text(
                      '${product.stock} left',
                      style: AppTypography.ui(
                        color: colors.warning,
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
