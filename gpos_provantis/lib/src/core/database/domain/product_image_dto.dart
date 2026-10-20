/// One element of the `data` list returned by `/products/image`.
class ProductImageDto {
  final String productImage;

  const ProductImageDto({required this.productImage});

  factory ProductImageDto.fromJson(Map<String, dynamic> json) {
    return ProductImageDto(
      productImage: (json['productimage'] ?? '').toString(),
    );
  }

  /// False when the server has no picture for the product.
  bool get hasImage => productImage.trim().isNotEmpty;
}
