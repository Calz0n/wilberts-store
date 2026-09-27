import 'package:flutter/material.dart';
import '../models/product_model.dart';
import '../models/cart_item_model.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/whatsapp_helper.dart';

class CartService extends ChangeNotifier {
  static final CartService instance = CartService._internal();
  CartService._internal();

  final List<CartItem> _items = [];

  List<CartItem> get items => List.unmodifiable(_items);

  int get totalItems {
    return _items.fold(0, (sum, item) => sum + item.quantity);
  }

  double get totalPrice {
    return _items.fold(0.0, (sum, item) => sum + item.subtotal);
  }

  void addItem(Product product, String size, {int quantity = 1}) {
    final itemId = "${product.id}_$size";
    final index = _items.indexWhere((item) => item.id == itemId);

    if (index >= 0) {
      _items[index].quantity += quantity;
    } else {
      _items.add(
        CartItem(
          id: itemId,
          productId: product.id,
          name: product.name,
          price: product.price,
          imageUrl: product.imageUrl,
          size: size,
          quantity: quantity,
        ),
      );
    }
    notifyListeners();
  }

  void updateQuantity(String itemId, int delta) {
    final index = _items.indexWhere((item) => item.id == itemId);
    if (index >= 0) {
      final newQty = _items[index].quantity + delta;
      if (newQty <= 0) {
        _items.removeAt(index);
      } else {
        _items[index].quantity = newQty;
      }
      notifyListeners();
    }
  }

  void removeItem(String itemId) {
    _items.removeWhere((item) => item.id == itemId);
    notifyListeners();
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }

  Future<void> sendOrderToWhatsApp() async {
    if (_items.isEmpty) return;

    final buffer = StringBuffer();
    buffer.writeln("¡Hola! Quiero realizar el siguiente pedido en ${AppConstants.appTitle}:");
    buffer.writeln("");

    for (final item in _items) {
      buffer.writeln("• ${item.quantity}x ${item.name} (Talla: ${item.size}) - \$${item.price} c/u");
    }

    buffer.writeln("");
    buffer.writeln("Total a pagar: \$${totalPrice.toStringAsFixed(0)} ${AppConstants.currency}");
    buffer.writeln("");
    buffer.writeln("¿Me podrían confirmar disponibilidad para coordinar la entrega o envío?");

    await WhatsAppHelper.launchWhatsApp(buffer.toString());
  }
}
