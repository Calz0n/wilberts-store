import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../models/product_model.dart';
import '../../../services/product_service.dart';
import '../../common/smart_product_image.dart';
import '../../catalog/widgets/product_detail_dialog.dart';

class FeaturedCarousel extends StatefulWidget {
  const FeaturedCarousel({super.key});

  @override
  State<FeaturedCarousel> createState() => _FeaturedCarouselState();
}

class _FeaturedCarouselState extends State<FeaturedCarousel> {
  final PageController _pageController = PageController(viewportFraction: 0.88);
  final ProductService _productService = ProductService();
  int _currentPage = 0;
  Timer? _autoTimer;
  int _itemCount = 0;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _autoTimer?.cancel();
    _autoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_itemCount > 1 && _pageController.hasClients) {
        final nextPage = (_currentPage + 1) % _itemCount;
        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 650),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _autoTimer?.cancel();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 700;

    return StreamBuilder<List<Product>>(
      stream: _productService.getFeaturedProductsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final products = snapshot.data!;
        _itemCount = products.length;

        return Container(
          color: const Color(0xFF070707),
          padding: const EdgeInsets.symmetric(vertical: 36),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.star, color: Colors.white, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      'MODELOS DESTACADOS',
                      style: GoogleFonts.pirataOne(
                        fontSize: isMobile ? 26 : 32,
                        letterSpacing: 2,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.star, color: Colors.white, size: 20),
                  ],
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Prendas seleccionadas de la colección actual',
                style: GoogleFonts.inter(fontSize: 13, color: Colors.white54),
              ),
              const SizedBox(height: 20),

              // Contenedor acotado para eliminar los vacíos negros a los lados
              Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxWidth: isMobile ? double.infinity : 680,
                  ),
                  child: SizedBox(
                    height: isMobile ? 380 : 450,
                    child: PageView.builder(
                      controller: _pageController,
                      itemCount: products.length,
                      onPageChanged: (i) => setState(() => _currentPage = i),
                      itemBuilder: (context, index) {
                        final product = products[index];

                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: InkWell(
                            onTap: () => ProductDetailDialog.show(context, product),
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFF111111),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.white12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Expanded(
                                    child: ClipRRect(
                                      borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                                      child: Container(
                                        color: const Color(0xFF070707),
                                        child: Stack(
                                          alignment: Alignment.center,
                                          children: [
                                            Positioned.fill(
                                              child: Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: SmartProductImage(
                                                  imageSource: product.imageUrl,
                                                  fit: BoxFit.contain,
                                                ),
                                              ),
                                            ),
                                            Positioned(
                                              top: 12,
                                              right: 12,
                                              child: Container(
                                                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.black.withOpacity(0.75),
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: Colors.white24),
                                                ),
                                                child: Text(
                                                  'DESTACADO',
                                                  style: GoogleFonts.montserrat(
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.bold,
                                                    letterSpacing: 1,
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                product.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 16,
                                                  fontWeight: FontWeight.bold,
                                                  color: Colors.white,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                '\$${product.price} ${AppConstants.currency}',
                                                style: GoogleFonts.inter(
                                                  fontSize: 14,
                                                  fontWeight: FontWeight.w600,
                                                  color: Colors.white70,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        ElevatedButton.icon(
                                          onPressed: () => ProductDetailDialog.show(context, product),
                                          icon: const Icon(Icons.visibility_outlined, size: 14, color: Colors.black),
                                          label: const Text(
                                            'VER DETALLE',
                                            style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.white,
                                            foregroundColor: Colors.black,
                                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              if (products.length > 1)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    products.length,
                        (i) => AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      margin: const EdgeInsets.symmetric(horizontal: 4),
                      width: _currentPage == i ? 24 : 8,
                      height: 4,
                      decoration: BoxDecoration(
                        color: _currentPage == i ? Colors.white : Colors.white24,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}