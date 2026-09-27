class CartItem {
  final String id;
  final String productId;
  final String name;
  final String price;
  final String imageUrl;
  final String size;
  int quantity;

  CartItem({
    required this.id,
    required this.productId,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.size,
    this.quantity = 1,
  });

  double get unitPrice => double.tryParse(price.replaceAll(RegExp(r'[^0-9.]'), '')) ?? 0.0;
  double get subtotal => unitPrice * quantity;
}
