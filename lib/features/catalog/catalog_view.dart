import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../models/product_model.dart';
import '../../services/product_service.dart';
import '../cart/widgets/cart_badge_button.dart';
import 'widgets/product_card.dart';

class CatalogView extends StatefulWidget {
  const CatalogView({super.key});

  @override
  State<CatalogView> createState() => _CatalogViewState();
}

class _CatalogViewState extends State<CatalogView> {
  final ProductService _productService = ProductService();
  String _selectedCategory = 'Todas';

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070707),
        surfaceTintColor: Colors.transparent,
        shadowColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/logo.jpeg',
              height: 24,
              fit: BoxFit.contain,
              errorBuilder: (_, __, ___) => const SizedBox.shrink(),
            ),
            const SizedBox(width: 8),
            Text(
              'CATÁLOGO',
              style: GoogleFonts.pirataOne(fontSize: 22, letterSpacing: 1.5, color: Colors.white),
            ),
          ],
        ),
        actions: const [
          CartBadgeButton(),
          SizedBox(width: 8),
        ],
      ),
      floatingActionButton: const CartBadgeButton(isFloating: true),
      body: StreamBuilder<List<Product>>(
        stream: _productService.getProductsStream(onlyVisible: true),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(child: Text('Error al conectar con el catálogo de playeras.', style: TextStyle(color: Colors.white70)));
          }
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator(color: Colors.white));
          }

          final allProducts = snapshot.data!;
          if (allProducts.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.checkroom, size: 64, color: Colors.white24),
                  const SizedBox(height: 16),
                  Text('No hay playeras disponibles en este momento.', style: GoogleFonts.montserrat(color: Colors.white70)),
                ],
              ),
            );
          }

          final categories = {'Todas', ...allProducts.map((p) => p.category)};
          final filteredProducts = _selectedCategory == 'Todas'
              ? allProducts
              : allProducts.where((p) => p.category == _selectedCategory).toList();

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              if (categories.length > 2)
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    child: Row(
                      children: categories.map((cat) {
                        final isSel = _selectedCategory == cat;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Text(cat),
                            selected: isSel,
                            selectedColor: Colors.white,
                            backgroundColor: const Color(0xFF161616),
                            labelStyle: TextStyle(
                              color: isSel ? Colors.black : Colors.white70,
                              fontWeight: FontWeight.bold,
                              fontSize: 12,
                            ),
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                            onSelected: (_) => setState(() => _selectedCategory = cat),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),

              SliverPadding(
                padding: EdgeInsets.symmetric(
                  horizontal: isMobile ? 10 : 24,
                  vertical: 10,
                ),
                sliver: SliverLayoutBuilder(
                  builder: (context, constraints) {
                    final width = constraints.crossAxisExtent;
                    final int cols = width > 950 ? 3 : (width > 600 ? 3 : 2);
                    final double aspectRatio = width < 380 ? 0.53 : (width < 650 ? 0.57 : 0.65);

                    return SliverGrid(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: cols,
                        childAspectRatio: aspectRatio,
                        crossAxisSpacing: isMobile ? 8 : 16,
                        mainAxisSpacing: isMobile ? 10 : 16,
                      ),
                      delegate: SliverChildBuilderDelegate(
                            (context, index) => ProductCard(product: filteredProducts[index]),
                        childCount: filteredProducts.length,
                      ),
                    );
                  },
                ),
              ),

              const SliverToBoxAdapter(
                child: SizedBox(height: 85),
              ),
            ],
          );
        },
      ),
    );
  }
}