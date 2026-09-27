import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/product_model.dart';
import '../../../services/cart_service.dart';
import '../../common/smart_product_image.dart';
import 'product_detail_dialog.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  late String selectedSize;

  @override
  void initState() {
    super.initState();
    String fallback = AppConstants.standardSizes.first;
    for (final s in AppConstants.standardSizes) {
      if (widget.product.sizes[s] == true) {
        fallback = s;
        break;
      }
    }
    selectedSize = fallback;
  }

  @override
  Widget build(BuildContext context) {
    final photoCount = widget.product.images.isNotEmpty ? widget.product.images.length : 1;
    final isStock = widget.product.sizes[selectedSize] == true;

    return Container(
      // Borde exterior estilizado de la tarjeta
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: Colors.white24, width: 1.2),
        borderRadius: BorderRadius.circular(10),
      ),
      padding: const EdgeInsets.all(10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Imagen clickeable SIN BARRAS NEGRAS (BoxFit.cover llena el marco)
          Expanded(
            child: InkWell(
              onTap: () => ProductDetailDialog.show(context, widget.product),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    SmartProductImage(
                      imageSource: widget.product.imageUrl,
                      fit: BoxFit.cover, // Llena completamente el espacio sin bordes negros
                    ),
                    // Etiqueta SOBRE PEDIDO si la talla seleccionada no tiene stock inmediato
                    if (!isStock)
                      Positioned(
                        top: 6,
                        left: 6,
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: Colors.black.withOpacity(0.85),
                            borderRadius: BorderRadius.circular(3),
                            border: Border.all(color: Colors.white38),
                          ),
                          child: const Text(
                            'SOBRE PEDIDO',
                            style: TextStyle(
                              fontSize: 8.5,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                      ),
                    // Contador de fotos (ej. 1/4)
                    Positioned(
                      top: 6,
                      right: 6,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.black.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(3),
                          border: Border.all(color: Colors.white24),
                        ),
                        child: Text(
                          '1/$photoCount',
                          style: const TextStyle(
                            fontSize: 9,
                            color: Colors.white70,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Nombre del modelo
          InkWell(
            onTap: () => ProductDetailDialog.show(context, widget.product),
            child: Text(
              widget.product.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 2),

          // Precio
          Text(
            "\$${widget.product.price} ${AppConstants.currency}",
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),

          // Chips de tallas con bordes definidos
          Wrap(
            spacing: 4,
            runSpacing: 4,
            children: AppConstants.standardSizes.map((size) {
              final isAvailable = widget.product.sizes[size] ?? true;
              final isSelected = selectedSize == size;

              return InkWell(
                onTap: () => setState(() => selectedSize = size),
                borderRadius: BorderRadius.circular(4),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: isSelected
                          ? Colors.white
                          : (isAvailable ? Colors.white38 : Colors.white12),
                    ),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Colors.black
                          : (isAvailable ? Colors.white : Colors.white60),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 8),

          // Botón AL CARRITO / PEDIR SOBRE PEDIDO
          SizedBox(
            width: double.infinity,
            height: 34,
            child: ElevatedButton.icon(
              onPressed: () {
                final effectiveSize = isStock ? selectedSize : "$selectedSize (Sobre pedido)";
                CartService.instance.addItem(widget.product, effectiveSize);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      isStock
                          ? "Agregado: ${widget.product.name} ($selectedSize)"
                          : "Agregado sobre pedido: ${widget.product.name} ($selectedSize)",
                    ),
                    backgroundColor: isStock ? const Color(0xFF222222) : const Color(0xFF1B2A1E),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              icon: Icon(
                isStock ? Icons.add_shopping_cart : Icons.schedule_send_outlined,
                size: 14,
                color: isStock ? Colors.black : Colors.white,
              ),
              label: Text(
                isStock ? 'AL CARRITO' : 'PEDIR SOBRE PEDIDO',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9.5,
                  letterSpacing: 0.5,
                  color: isStock ? Colors.black : Colors.white,
                ),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: isStock ? Colors.white : const Color(0xFF1C1C1C),
                foregroundColor: isStock ? Colors.black : Colors.white,
                side: isStock ? null : const BorderSide(color: Colors.white24),
                padding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}