import 'package:flutter/material.dart';
import '../../../services/cart_service.dart';
import 'cart_sheet.dart';

class CartBadgeButton extends StatelessWidget {
  final bool isFloating;

  const CartBadgeButton({super.key, this.isFloating = false});

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final count = cart.totalItems;

        if (isFloating) {
          return FloatingActionButton.extended(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            onPressed: () => CartSheet.show(context),
            icon: const Icon(Icons.shopping_bag_outlined),
            label: Text(
              count > 0 ? "CARRITO ($count)" : "CARRITO",
              style: const TextStyle(fontWeight: FontWeight.bold, letterSpacing: 1),
            ),
          );
        }

        return Stack(
          alignment: Alignment.center,
          children: [
            IconButton(
              tooltip: 'Ver Carrito',
              icon: const Icon(Icons.shopping_bag_outlined, color: Colors.white),
              onPressed: () => CartSheet.show(context),
            ),
            if (count > 0)
              Positioned(
                top: 6,
                right: 6,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                    color: Colors.redAccent,
                    shape: BoxShape.circle,
                  ),
                  constraints: const BoxConstraints(minWidth: 16, minHeight: 16),
                  child: Text(
                    "$count",
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
