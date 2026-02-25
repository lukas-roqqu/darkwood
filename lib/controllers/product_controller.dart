import 'package:get/get.dart';
import '../models/product.dart';
import '../models/cart_item.dart';
import '../models/products.dart';

class ProductController extends GetxController {
  // ── Product list ───────────────────────────────────────────────
  final all = <Product>[].obs;

  // ── Selected product & variant (for detail/description view) ──
  final selected = Rxn<Product>();
  final selectedVariant = Rxn<ProductVariant>();

  // ── Cart ───────────────────────────────────────────────────────
  final cart = <CartItem>[].obs;

  // ── Filters ────────────────────────────────────────────────────
  final activeRoast = Rxn<RoastLevel>();
  final activeGrind = Rxn<GrindType>();

  @override
  void onInit() {
    super.onInit();
    all.assignAll(products);
  }

  // ── Computed ───────────────────────────────────────────────────

  List<Product> get filtered {
    return all.where((p) {
      if (activeRoast.value != null && p.roastLevel != activeRoast.value) {
        return false;
      }
      if (activeGrind.value != null) {
        final hasGrind =
            p.variants.any((v) => v.grind == activeGrind.value);
        if (!hasGrind) return false;
      }
      return true;
    }).toList();
  }

  int get cartCount => cart.fold(0, (sum, item) => sum + item.quantity);

  double get cartTotal => cart.fold(0, (sum, item) => sum + item.subtotal);

  bool get cartIsEmpty => cart.isEmpty;

  // ── Product selection ──────────────────────────────────────────

  void select(Product product) {
    selected.value = product;
    selectedVariant.value = product.defaultVariant;
  }

  void selectVariant(ProductVariant variant) {
    selectedVariant.value = variant;
  }

  void clearSelection() {
    selected.value = null;
    selectedVariant.value = null;
  }

  // ── Filters ────────────────────────────────────────────────────

  void filterByRoast(RoastLevel? roast) {
    activeRoast.value = roast;
  }

  void filterByGrind(GrindType? grind) {
    activeGrind.value = grind;
  }

  void clearFilters() {
    activeRoast.value = null;
    activeGrind.value = null;
  }

  // ── Cart ───────────────────────────────────────────────────────

  void addToCart(Product product, ProductVariant variant, {int quantity = 1}) {
    final key = '${product.id}_${variant.label}';
    final existing = cart.firstWhereOrNull((i) => i.key == key);

    if (existing != null) {
      existing.quantity += quantity;
      cart.refresh();
    } else {
      cart.add(CartItem(product: product, variant: variant, quantity: quantity));
    }
  }

  void removeFromCart(CartItem item) {
    cart.remove(item);
  }

  void incrementItem(CartItem item) {
    item.quantity++;
    cart.refresh();
  }

  void decrementItem(CartItem item) {
    if (item.quantity <= 1) {
      cart.remove(item);
    } else {
      item.quantity--;
      cart.refresh();
    }
  }

  void clearCart() {
    cart.clear();
  }

  // ── Convenience: add currently selected product+variant ───────

  void addSelectedToCart({int quantity = 1}) {
    if (selected.value == null || selectedVariant.value == null) return;
    addToCart(selected.value!, selectedVariant.value!, quantity: quantity);
  }

  // ── Pay items (for pay package) ────────────────────────────────

  List<Map<String, dynamic>> get paymentItems => [
        ...cart.map(
          (item) => {
            'label': '${item.product.name} · ${item.variant.label}',
            'amount': item.subtotal.toStringAsFixed(2),
            'type': 'lineItem',
            'status': 'final',
          },
        ),
        {
          'label': 'Total',
          'amount': cartTotal.toStringAsFixed(2),
          'type': 'total',
          'status': 'final',
        },
      ];
}
