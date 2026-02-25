import 'product.dart';

class CartItem {
  final Product product;
  final ProductVariant variant;
  int quantity;

  CartItem({
    required this.product,
    required this.variant,
    this.quantity = 1,
  });

  double get subtotal => variant.price * quantity;

  String get key => '${product.id}_${variant.label}';
}
