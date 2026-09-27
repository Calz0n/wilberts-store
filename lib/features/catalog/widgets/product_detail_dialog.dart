import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../models/product_model.dart';
import '../../../services/cart_service.dart';
import '../../common/smart_product_image.dart';

class ProductDetailDialog extends StatefulWidget {
  final Product product;

  const ProductDetailDialog({super.key, required this.product});

  static void show(BuildContext context, Product product) {
    final isMobile = MediaQuery.of(context).size.width < 700;
    if (isMobile) {
      showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        builder: (_) => ProductDetailDialog(product: product),
      );
    } else {
      showDialog(
        context: context,
        builder: (_) => ProductDetailDialog(product: product),
      );
    }
  }

  @override
  State<ProductDetailDialog> createState() => _ProductDetailDialogState();
}

class _ProductDetailDialogState extends State<ProductDetailDialog> {
  late String selectedSize;
  int quantity = 1;
  int selectedPhotoIndex = 0;

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
    final isDesktop = MediaQuery.of(context).size.width >= 700;
    final photos = widget.product.images.isNotEmpty
        ? widget.product.images
        : [widget.product.imageUrl];

    final currentPhoto = photos.isNotEmpty && selectedPhotoIndex < photos.length
        ? photos[selectedPhotoIndex]
        : '';

    if (isDesktop) {
      return Dialog(
        backgroundColor: const Color(0xFF111111),
        insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
          side: const BorderSide(color: Colors.white24),
        ),
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 850, maxHeight: 720),
          child: Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(24),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 5, child: _buildGallery(photos, currentPhoto, height: 380)),
                    const SizedBox(width: 32),
                    Expanded(flex: 6, child: SingleChildScrollView(child: _buildInfoSection())),
                  ],
                ),
              ),
              Positioned(
                top: 12,
                right: 12,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white70),
                  onPressed: () => Navigator.pop(context),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.90,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF111111),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
        border: Border(top: BorderSide(color: Colors.white24, width: 1)),
      ),
      child: SafeArea(
        child: Column(
          children: [
            Container(
              margin: const EdgeInsets.only(top: 10, bottom: 4),
              width: 38,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white24,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white70, size: 20),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
                child: Column(
                  children: [
                    _buildGallery(photos, currentPhoto, height: 280),
                    const SizedBox(height: 18),
                    _buildInfoSection(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGallery(List<String> photos, String currentPhoto, {required double height}) {
    return Column(
      children: [
        Container(
          height: height,
          decoration: BoxDecoration(
            color: Colors.black,
            border: Border.all(color: Colors.white12),
            borderRadius: BorderRadius.circular(8),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: SmartProductImage(imageSource: currentPhoto),
          ),
        ),
        if (photos.length > 1) ...[
          const SizedBox(height: 12),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(photos.length, (idx) {
                final isSelected = selectedPhotoIndex == idx;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => setState(() => selectedPhotoIndex = idx),
                    child: Container(
                      width: 50,
                      height: 50,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: isSelected ? Colors.white : Colors.white24,
                          width: isSelected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(4),
                        child: SmartProductImage(imageSource: photos[idx]),
                      ),
                    ),
                  ),
                );
              }),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildInfoSection() {
    final isStock = widget.product.sizes[selectedSize] == true;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          children: [
            Expanded(
              child: Text(
                widget.product.name,
                style: GoogleFonts.pirataOne(fontSize: 28, letterSpacing: 1.2, color: Colors.white),
              ),
            ),
            if (!isStock)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.white24),
                ),
                child: const Text(
                  'SOBRE PEDIDO',
                  style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold, letterSpacing: 0.5),
                ),
              ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          "\$${widget.product.price} ${AppConstants.currency}",
          style: GoogleFonts.montserrat(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 14),
        Text(
          widget.product.description,
          style: GoogleFonts.inter(fontSize: 13, color: Colors.white70, height: 1.5),
        ),
        const SizedBox(height: 14),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF161616),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: Colors.white10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text('• Composición: 100% Algodón Peinado 240g (Heavyweight)', style: TextStyle(fontSize: 11, color: Colors.white70)),
              SizedBox(height: 3),
              Text('• Corte: Oversize Fit con hombro caído (Drop shoulder)', style: TextStyle(fontSize: 11, color: Colors.white70)),
              SizedBox(height: 3),
              Text('• Cuello: Redondo acanalado grueso de 1 pulgada', style: TextStyle(fontSize: 11, color: Colors.white70)),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Text('SELECCIONA TU TALLA:', style: GoogleFonts.montserrat(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white)),
            const SizedBox(width: 8),
            if (!isStock)
              const Text('(Disponible bajo encargo)', style: TextStyle(fontSize: 11, color: Colors.white54)),
          ],
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: AppConstants.standardSizes.map((size) {
            final availableInStock = widget.product.sizes[size] ?? true;
            final isSelected = selectedSize == size;

            return InkWell(
              onTap: () => setState(() => selectedSize = size),
              borderRadius: BorderRadius.circular(6),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  border: Border.all(
                    color: isSelected
                        ? Colors.white
                        : (availableInStock ? Colors.white38 : Colors.white12),
                  ),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  size,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    color: isSelected
                        ? Colors.black
                        : (availableInStock ? Colors.white : Colors.white60),
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 18),
        Row(
          children: [
            Container(
              decoration: BoxDecoration(
                border: Border.all(color: Colors.white24),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.remove, size: 16, color: Colors.white),
                    onPressed: quantity > 1 ? () => setState(() => quantity--) : null,
                  ),
                  Text('$quantity', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.white)),
                  IconButton(
                    icon: const Icon(Icons.add, size: 16, color: Colors.white),
                    onPressed: () => setState(() => quantity++),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: SizedBox(
                height: 46,
                child: ElevatedButton.icon(
                  onPressed: () {
                    final effectiveSize = isStock ? selectedSize : "$selectedSize (Sobre pedido)";
                    CartService.instance.addItem(
                      widget.product,
                      effectiveSize,
                      quantity: quantity,
                    );
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          isStock
                              ? "¡Agregado al carrito: ${widget.product.name} ($selectedSize)!"
                              : "¡Agregado sobre pedido: ${widget.product.name} ($selectedSize)!",
                        ),
                        backgroundColor: isStock ? const Color(0xFF222222) : const Color(0xFF1B2A1E),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  icon: Icon(
                    isStock ? Icons.shopping_bag_outlined : Icons.schedule_send_outlined,
                    size: 18,
                    color: isStock ? Colors.black : Colors.white,
                  ),
                  label: Text(
                    isStock ? 'AL CARRITO' : 'PEDIR SOBRE PEDIDO',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: isStock ? Colors.black : Colors.white,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isStock ? Colors.white : const Color(0xFF202020),
                    foregroundColor: isStock ? Colors.black : Colors.white,
                    side: isStock ? null : const BorderSide(color: Colors.white24),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          height: 42,
          child: TextButton.icon(
            onPressed: () {
              final effectiveSize = isStock ? selectedSize : "$selectedSize (Sobre pedido)";
              WhatsAppHelper.sendSingleOrder(
                productName: widget.product.name,
                size: effectiveSize,
                price: widget.product.price,
                quantity: quantity,
              );
            },
            icon: const Icon(Icons.chat, size: 16, color: Colors.greenAccent),
            label: Text(
              isStock
                  ? 'COMPRAR AHORA POR WHATSAPP'
                  : 'PEDIR SOBRE PEDIDO POR WHATSAPP',
              style: const TextStyle(
                color: Colors.white70,
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}