import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:gpos_provantis/src/core/theme/theme.dart';
import 'package:gpos_provantis/src/features/dashboard/presentation/controllers/dashboard_controller.dart';
import 'category_visibility.dart';
import 'dashboard_constants.dart';

class ProductGrid extends ConsumerWidget {
  const ProductGrid({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final controller = ref.watch(dashboardControllerProvider.notifier);

    final state = ref.watch(dashboardControllerProvider);
    final hidden = ref.watch(hiddenCategoryCodesProvider);
    final status = controller.productsStatus;
    final products = controller.productsForCatalogSheet();

    if (isCategoryIdHidden(state.catalogSheetCategoryId, hidden)) {
      return const _HiddenCategoryState();
    }

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

class _HiddenCategoryState extends ConsumerWidget {
  const _HiddenCategoryState();

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
              Icons.visibility_off_rounded,
              size: 40,
              color: colors.textDisabled,
            ),
            const SizedBox(height: 12),
            Text(
              'This category is hidden.',
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

class _ProductCard extends ConsumerWidget {
  const _ProductCard({required this.product});

  final Product product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final colors = context.colors;
    final notifier = ref.read(dashboardControllerProvider.notifier);

    final isOutOfStock = product.stock <= 0;

    final isDark = colors.isDark;

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
