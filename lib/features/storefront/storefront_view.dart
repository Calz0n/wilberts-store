import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import 'widgets/hero_section.dart';
import 'widgets/ticker_bar.dart';
import 'widgets/product_card.dart';
import 'widgets/how_to_order.dart';

class StorefrontView extends StatefulWidget {
  const StorefrontView({super.key});

  @override
  State<StorefrontView> createState() => _StorefrontViewState();
}

class _StorefrontViewState extends State<StorefrontView> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _catalogKey = GlobalKey();
  final GlobalKey _howToOrderKey = GlobalKey();
  final ProductService _productService = ProductService();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToCatalog() {
    if (_catalogKey.currentContext != null) {
      Scrollable.ensureVisible(
        _catalogKey.currentContext!,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToHowToOrder() {
    if (_howToOrderKey.currentContext != null) {
      Scrollable.ensureVisible(
        _howToOrderKey.currentContext!,
        duration: const Duration(milliseconds: 650),
        curve: Curves.easeInOutCubic,
      );
    }
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 650),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 768;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF070707),
        elevation: 0,
        centerTitle: false,
        title: InkWell(
          onTap: _scrollToTop,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Image.asset(
                  'assets/images/logo.jpeg',
                  height: 30,
                  width: 30,
                  errorBuilder: (_, __, ___) => const SizedBox.shrink(),
                ),
                const SizedBox(width: 8),
                Text(
                  'VISTE DIFERENTE',
                  style: GoogleFonts.pirataOne(fontSize: 24, letterSpacing: 2),
                ),
              ],
            ),
          ),
        ),
        actions: isDesktop
            ? [
                TextButton(
                  onPressed: _scrollToTop,
                  child: Text(
                    'INICIO',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _scrollToCatalog,
                  style: TextButton.styleFrom(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    backgroundColor: Colors.white10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: Colors.white24),
                    ),
                  ),
                  child: Text(
                    'CATÁLOGO',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 1.5,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                TextButton(
                  onPressed: _scrollToHowToOrder,
                  child: Text(
                    '¿CÓMO PEDIR?',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.5,
                      color: Colors.white70,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                IconButton(
                  tooltip: 'Panel Administrador',
                  onPressed: () => Navigator.pushNamed(context, '/admin'),
                  icon: const Icon(Icons.admin_panel_settings_outlined, size: 20, color: Colors.white24),
                ),
                const SizedBox(width: 12),
              ]
            : [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: TextButton(
                    onPressed: _scrollToCatalog,
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      backgroundColor: Colors.white12,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                        side: const BorderSide(color: Colors.white30),
                      ),
                    ),
                    child: Text(
                      'CATÁLOGO',
                      style: GoogleFonts.montserrat(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                IconButton(
                  tooltip: 'Admin',
                  onPressed: () => Navigator.pushNamed(context, '/admin'),
                  icon: const Icon(Icons.lock_outline, size: 18, color: Colors.white24),
                ),
                const SizedBox(width: 4),
              ],
      ),
      drawer: isDesktop
          ? null
          : Drawer(
              backgroundColor: const Color(0xFF111111),
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  DrawerHeader(
                    decoration: const BoxDecoration(color: Color(0xFF070707)),
                    child: Center(
                      child: Text(
                        'VISTE DIFERENTE',
                        style: GoogleFonts.pirataOne(fontSize: 28, letterSpacing: 2),
                      ),
                    ),
                  ),
                  ListTile(
                    leading: const Icon(Icons.home_outlined, color: Colors.white70),
                    title: Text(
                      'INICIO',
                      style: GoogleFonts.montserrat(fontSize: 13, letterSpacing: 1, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollToTop();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.checkroom, color: Colors.white),
                    title: Text(
                      'CATÁLOGO',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1,
                        color: Colors.white,
                      ),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollToCatalog();
                    },
                  ),
                  ListTile(
                    leading: const Icon(Icons.help_outline, color: Colors.white70),
                    title: Text(
                      '¿CÓMO PEDIR?',
                      style: GoogleFonts.montserrat(fontSize: 13, letterSpacing: 1, color: Colors.white),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      _scrollToHowToOrder();
                    },
                  ),
                  const Divider(color: Colors.white12),
                  ListTile(
                    leading: const Icon(Icons.admin_panel_settings_outlined, color: Colors.white24),
                    title: Text(
                      'Panel Admin',
                      style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white38),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, '/admin');
                    },
                  ),
                ],
              ),
            ),
      body: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          children: [
            HeroSection(onExploreCatalog: _scrollToCatalog),
            const TickerBar(),
            Padding(
              key: _catalogKey,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1100),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('COLECCIÓN DISPONIBLE', style: Theme.of(context).textTheme.headlineMedium),
                    const SizedBox(height: 24),
                    StreamBuilder<List<Product>>(
                      stream: _productService.getProductsStream(),
                      builder: (context, snapshot) {
                        if (snapshot.hasError) {
                          return const Center(child: Text('Error al conectar con el catálogo.'));
                        }
                        if (!snapshot.hasData) {
                          return const Center(child: CircularProgressIndicator(color: Colors.white));
                        }
                        final products = snapshot.data!;
                        if (products.isEmpty) {
                          return const Center(child: Text('No hay modelos disponibles por ahora.'));
                        }

                        return LayoutBuilder(
                          builder: (context, constraints) {
                            int cols = constraints.maxWidth > 900 ? 3 : (constraints.maxWidth > 600 ? 2 : 1);
                            return GridView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: products.length,
                              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: cols,
                                childAspectRatio: 0.68,
                                crossAxisSpacing: 16,
                                mainAxisSpacing: 16,
                              ),
                              itemBuilder: (context, index) => ProductCard(product: products[index]),
                            );
                          },
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            KeyedSubtree(
              key: _howToOrderKey,
              child: const HowToOrderSection(),
            ),
            Padding(
              padding: const EdgeInsets.all(24),
              child: Text(
                '© 2026 Viste Diferente. Todos los derechos reservados.',
                style: GoogleFonts.inter(fontSize: 12, color: Colors.white30),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
