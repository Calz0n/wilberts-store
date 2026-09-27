import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback onExploreCatalog;

  const HeroSection({super.key, required this.onExploreCatalog});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 800;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Expanded(child: _buildText(context)),
                  const SizedBox(width: 48),
                  Expanded(child: _buildGraphic()),
                ],
              )
            : Column(
                children: [
                  _buildGraphic(),
                  const SizedBox(height: 36),
                  _buildText(context),
                ],
              ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: Colors.white12,
            border: Border.all(color: Colors.white24),
            borderRadius: BorderRadius.circular(2),
          ),
          child: Text(
            'COLECCIÓN STREETWEAR HEAVYWEIGHT',
            style: GoogleFonts.montserrat(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              letterSpacing: 2,
              color: Colors.white70,
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Viste\nDiferente', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        Text(
          'Prendas oversize de 240 gramos confeccionadas en 100% algodón peinado. Diseñadas para quienes no siguen las reglas del streetwear convencional.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white70, height: 1.6),
        ),
        const SizedBox(height: 32),
        ElevatedButton.icon(
          onPressed: onExploreCatalog,
          icon: const Icon(Icons.arrow_forward, size: 16, color: Colors.black),
          label: Text(
            'EXPLORAR CATÁLOGO',
            style: GoogleFonts.montserrat(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              letterSpacing: 2,
              color: Colors.black,
            ),
          ),
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.black,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildGraphic() {
    return Container(
      height: 340,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: Image.asset(
          'assets/images/logo.jpeg',
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.checkroom, size: 80, color: Colors.white24),
          ),
        ),
      ),
    );
  }
}
