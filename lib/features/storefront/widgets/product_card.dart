import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../models/product_model.dart';

class ProductCard extends StatefulWidget {
  final Product product;

  const ProductCard({super.key, required this.product});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  String? selectedSize;

  @override
  Widget build(BuildContext context) {
    final sizes = widget.product.sizes;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: Colors.white10),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Container(
              color: Colors.black,
              width: double.infinity,
              child: widget.product.imageUrl.isNotEmpty
                  ? Image.network(
                      widget.product.imageUrl,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) =>
                          const Icon(Icons.image, size: 48, color: Colors.white24),
                    )
                  : const Icon(Icons.image, size: 48, color: Colors.white24),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.product.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: GoogleFonts.montserrat(fontSize: 15, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(
            "\$${widget.product.price} ${AppConstants.currency}",
            style: GoogleFonts.inter(fontSize: 14, color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 6,
            runSpacing: 4,
            children: sizes.entries.map((entry) {
              final size = entry.key;
              final isAvailable = entry.value;
              final isSelected = selectedSize == size;

              return InkWell(
                onTap: isAvailable
                    ? () => setState(() => selectedSize = isSelected ? null : size)
                    : null,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: isSelected ? Colors.white : Colors.transparent,
                    border: Border.all(
                      color: isAvailable
                          ? (isSelected ? Colors.white : Colors.white38)
                          : Colors.white12,
                    ),
                  ),
                  child: Text(
                    size,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: isAvailable
                          ? (isSelected ? Colors.black : Colors.white)
                          : Colors.white24,
                      decoration: isAvailable ? null : TextDecoration.lineThrough,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton(
              onPressed: selectedSize == null
                  ? null
                  : () => WhatsAppHelper.sendOrder(
                        productName: widget.product.name,
                        size: selectedSize!,
                        price: widget.product.price,
                      ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.black,
                disabledBackgroundColor: Colors.white12,
                disabledForegroundColor: Colors.white24,
                shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
              ),
              child: Text(
                selectedSize == null ? 'SELECCIONA TALLA' : 'PEDIR POR WHATSAPP',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12, letterSpacing: 1),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
