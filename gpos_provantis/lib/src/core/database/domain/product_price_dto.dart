class ProductPriceDto {
  final int productId;
  final String description;
  final String barcode;
  final String price;
  final int category;
  final int quantity;

  ProductPriceDto({
    required this.productId,
    required this.description,
    required this.barcode,
    required this.price,
    required this.category,
    required this.quantity,
  });

  factory ProductPriceDto.fromJson(Map<String, dynamic> json) {
    return ProductPriceDto(
      productId: (json['productid'] ?? 0).toInt(),
      description: (json['description'] ?? '').toString(),
      barcode: (json['barcode'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      category: (json['category'] ?? 0).toInt(),
      quantity: (json['quantity'] ?? 0).toInt(),
    );
  }
}
