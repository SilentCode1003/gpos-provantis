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
      productId: int.tryParse(json['productid']?.toString() ?? '') ?? 0,
      description: (json['description'] ?? '').toString(),
      barcode: (json['barcode'] ?? '').toString(),
      price: (json['price'] ?? '').toString(),
      category: int.tryParse(json['category']?.toString() ?? '') ?? 0,
      quantity: int.tryParse(json['quantity']?.toString() ?? '') ?? 0,
    );
  }
}
