import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HeroSection extends StatelessWidget {
  final VoidCallback? onExploreCatalog;

  const HeroSection({super.key, this.onExploreCatalog});

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
                  _buildText(context),
                  const SizedBox(height: 36),
                  _buildGraphic(),
                ],
              ),
      ),
    );
  }

  Widget _buildText(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Viste\nDiferente', style: Theme.of(context).textTheme.displayLarge),
        const SizedBox(height: 16),
        Text(
          'Prendas de gramaje pesado 240g diseñadas con corte oversize y estética streetwear gótica.',
          style: GoogleFonts.inter(fontSize: 16, color: Colors.white70, height: 1.5),
        ),
        if (onExploreCatalog != null) ...[
          const SizedBox(height: 28),
          ElevatedButton.icon(
            onPressed: onExploreCatalog,
            icon: const Icon(Icons.arrow_downward, size: 16, color: Colors.black),
            label: Text(
              'VER CATÁLOGO',
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
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
              ),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildGraphic() {
    return Container(
      height: 320,
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(4),
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
