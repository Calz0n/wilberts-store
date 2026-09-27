import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../common/smart_product_image.dart';
import '../catalog/widgets/product_card.dart';
import '../catalog/widgets/product_detail_dialog.dart';
import '../cart/widgets/cart_badge_button.dart';
import 'widgets/ticker_bar.dart';
import 'widgets/how_to_order.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  final ProductService _productService = ProductService();
  final PageController _featuredPageCtrl = PageController();
  int _currentFeaturedPage = 0;
  Timer? _featuredTimer;
  int _secretAdminTaps = 0;

  @override
  void initState() {
    super.initState();
    _startFeaturedTimer();
  }

  void _startFeaturedTimer() {
    _featuredTimer?.cancel();
    _featuredTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (_featuredPageCtrl.hasClients) {
        _featuredPageCtrl.nextPage(
          duration: const Duration(milliseconds: 600),
          curve: Curves.easeInOutCubic,
        );
      }
    });
  }

  @override
  void dispose() {
    _featuredTimer?.cancel();
    _featuredPageCtrl.dispose();
    super.dispose();
  }

  void _onSecretTap() {
    _secretAdminTaps++;
    if (_secretAdminTaps >= 5) {
      _secretAdminTaps = 0;
      Navigator.pushNamed(context, '/admin');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 850;

    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070707),
        surfaceTintColor: Colors.transparent,
        scrolledUnderElevation: 0,
        elevation: 0,
        automaticallyImplyLeading: false, // 1. Elimina la flecha de regreso en móvil
        centerTitle: false,
        titleSpacing: isDesktop ? 20 : 10,
        toolbarHeight: isDesktop ? 68 : 58,
        title: GestureDetector(
          onTap: _onSecretTap,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(6),
                child: Image.asset(
                  'assets/images/logo.jpeg',
                  height: isDesktop ? 46 : 34,
                  width: isDesktop ? 46 : 34,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Text(
                    'WS',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                "Wilberts' Store",
                style: GoogleFonts.montserrat(
                  fontSize: isDesktop ? 19 : 14.5,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: 0.3,
                ),
              ),
            ],
          ),
        ),
        actions: [
          // Botón de acceso directo al catálogo completo adaptado a móvil y escritorio
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/catalog'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 14 : 8,
                vertical: isDesktop ? 8 : 5,
              ),
              backgroundColor: const Color(0xFF1A1A1A),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text(
              'CATÁLOGO',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: isDesktop ? 11 : 9.5,
                letterSpacing: 0.8,
              ),
            ),
          ),
          SizedBox(width: isDesktop ? 8 : 2),
          const CartBadgeButton(),
          SizedBox(width: isDesktop ? 14 : 8),
        ],
      ),
      floatingActionButton: const CartBadgeButton(isFloating: true),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Sección Hero: Texto + Carrusel
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isDesktop ? 48 : 20,
                vertical: isDesktop ? 40 : 20,
              ),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1150),
                  child: isDesktop
                      ? Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(flex: 5, child: _buildHeroLeftText(context)),
                      const SizedBox(width: 48),
                      Expanded(flex: 6, child: _buildFeaturedCarousel(context, isDesktop)),
                    ],
                  )
                      : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildHeroLeftText(context),
                      const SizedBox(height: 28),
                      _buildFeaturedCarousel(context, isDesktop),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // Ticker bar informativo
            const TickerBar(),

            const SizedBox(height: 36),

            // Sección: Colección disponible (Solo playeras elegidas por el admin)
            Padding(
              padding: EdgeInsets.symmetric(horizontal: isDesktop ? 48 : 16),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1150),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'COLECCIÓN DISPONIBLE',
                        style: GoogleFonts.pirataOne(
                          fontSize: isDesktop ? 34 : 26,
                          letterSpacing: 2,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 20),

                      StreamBuilder<List<Product>>(
                        stream: _productService.getHomeProductsStream(),
                        builder: (context, snapshot) {
                          if (snapshot.hasError) {
                            return const Center(child: Text('Error al cargar la colección.'));
                          }
                          if (!snapshot.hasData) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(40),
                                child: CircularProgressIndicator(color: Colors.white),
                              ),
                            );
                          }

                          final products = snapshot.data!;
                          if (products.isEmpty) {
                            return const Padding(
                              padding: EdgeInsets.all(40),
                              child: Center(
                                child: Text('No hay prendas seleccionadas para la portada.'),
                              ),
                            );
                          }

                          final width = MediaQuery.of(context).size.width;
                          final isMobile = width < 600;
                          final int cols = width > 1050 ? 4 : (width > 700 ? 3 : 2);
                          final double aspectRatio = width < 380 ? 0.53 : (width < 650 ? 0.57 : 0.65);

                          return Column(
                            children: [
                              GridView.builder(
                                shrinkWrap: true,
                                physics: const NeverScrollableScrollPhysics(),
                                itemCount: products.length,
                                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                  crossAxisCount: cols,
                                  childAspectRatio: aspectRatio,
                                  crossAxisSpacing: isMobile ? 8 : 16,
                                  mainAxisSpacing: isMobile ? 10 : 16,
                                ),
                                itemBuilder: (context, index) {
                                  return ProductCard(product: products[index]);
                                },
                              ),
                              const SizedBox(height: 32),

                              // Botón para acceder al catálogo completo
                              Center(
                                child: OutlinedButton.icon(
                                  onPressed: () => Navigator.pushNamed(context, '/catalog'),
                                  icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                                  label: const Text(
                                    'VER CATÁLOGO COMPLETO',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      letterSpacing: 1.5,
                                      color: Colors.white,
                                    ),
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    backgroundColor: const Color(0xFF141414),
                                    side: const BorderSide(color: Colors.white24, width: 1.2),
                                    padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                  ),
                                ),
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 36),

            // ¿Cómo pedir?, Métodos de pago y Redes
            const HowToOrderSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeroLeftText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Viste\nDiferente',
          style: GoogleFonts.pirataOne(
            fontSize: 60,
            height: 1.05,
            color: Colors.white,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 18),
        Text(
          'Más que ropa, una declaración de estilo. Tejido pesado de 240g y acabados de alta gama que marcan la diferencia.',
          style: GoogleFonts.inter(
            fontSize: 15,
            color: Colors.white70,
            height: 1.5,
          ),
        ),
      ],
    );
  }

  Widget _buildFeaturedCarousel(BuildContext context, bool isDesktop) {
    return StreamBuilder<List<Product>>(
      stream: _productService.getFeaturedProductsStream(),
      builder: (context, snapshot) {
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const SizedBox.shrink();
        }

        final featuredList = snapshot.data!;
        final cardHeight = isDesktop ? 380.0 : 360.0;

        return Center(
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: isDesktop ? 420 : 360),
            child: Container(
              height: cardHeight,
              decoration: BoxDecoration(
                color: const Color(0xFF111111),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.white24, width: 1.2),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    PageView.builder(
                      controller: _featuredPageCtrl,
                      itemCount: featuredList.length,
                      onPageChanged: (idx) {
                        setState(() => _currentFeaturedPage = idx % featuredList.length);
                      },
                      itemBuilder: (context, index) {
                        final product = featuredList[index % featuredList.length];

                        return InkWell(
                          onTap: () => ProductDetailDialog.show(context, product),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              SmartProductImage(
                                imageSource: product.imageUrl,
                                fit: BoxFit.cover,
                              ),
                              Positioned(
                                left: 0,
                                right: 0,
                                bottom: 0,
                                height: 110,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.black.withOpacity(0.85),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                left: 16,
                                bottom: 16,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      product.name,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      '\$${product.price} MXN',
                                      style: GoogleFonts.inter(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Positioned(
                                right: 16,
                                bottom: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: Colors.black.withOpacity(0.6),
                                    borderRadius: BorderRadius.circular(3),
                                    border: Border.all(color: Colors.white24),
                                  ),
                                  child: Text(
                                    'DESTACADA',
                                    style: GoogleFonts.montserrat(
                                      fontSize: 9,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 1,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    ),
                    if (featuredList.length > 1)
                      Positioned(
                        left: 6,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              _featuredPageCtrl.previousPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chevron_left, color: Colors.white70, size: 22),
                            ),
                          ),
                        ),
                      ),
                    if (featuredList.length > 1)
                      Positioned(
                        right: 6,
                        top: 0,
                        bottom: 0,
                        child: Center(
                          child: InkWell(
                            onTap: () {
                              _featuredPageCtrl.nextPage(
                                duration: const Duration(milliseconds: 350),
                                curve: Curves.easeInOut,
                              );
                            },
                            borderRadius: BorderRadius.circular(20),
                            child: Container(
                              padding: const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                color: Colors.black.withOpacity(0.5),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.chevron_right, color: Colors.white70, size: 22),
                            ),
                          ),
                        ),
                      ),
                    if (featuredList.length > 1)
                      Positioned(
                        bottom: 8,
                        left: 0,
                        right: 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            featuredList.length,
                                (i) => AnimatedContainer(
                              duration: const Duration(milliseconds: 300),
                              margin: const EdgeInsets.symmetric(horizontal: 3),
                              width: _currentFeaturedPage == i ? 18 : 6,
                              height: 3,
                              decoration: BoxDecoration(
                                color: _currentFeaturedPage == i ? Colors.white : Colors.white24,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}