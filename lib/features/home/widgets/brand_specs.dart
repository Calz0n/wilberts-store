import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class BrandSpecsSection extends StatelessWidget {
  const BrandSpecsSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF090909),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            Text('ESTÁNDARES DE CALIDAD', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 12),
            Text(
              'Cada prenda está fabricada bajo especificaciones estrictas de alta gama streetwear.',
              textAlign: TextAlign.center,
              style: GoogleFonts.inter(color: Colors.white60, fontSize: 14),
            ),
            const SizedBox(height: 40),
            Wrap(
              spacing: 24,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: const [
                _SpecBox(
                  icon: Icons.layers_outlined,
                  title: 'Algodón Pesado 240 GSM',
                  desc: 'Tejido premium de gramaje denso con caída recta y tacto suave que no se deforma tras los lavados.',
                ),
                _SpecBox(
                  icon: Icons.crop_free_outlined,
                  title: 'Corte Drop Shoulder',
                  desc: 'Hombros caídos y silueta oversize auténtica para lograr el fit urbano contemporáneo.',
                ),
                _SpecBox(
                  icon: Icons.brush_outlined,
                  title: 'Serigrafía Tacto Cero',
                  desc: 'Pigmentos de alta fijación resistentes al desgaste diario sin acartonamiento.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SpecBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String desc;

  const _SpecBox({required this.icon, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF111111),
        border: Border.all(color: Colors.white12),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 28, color: Colors.white),
          const SizedBox(height: 16),
          Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.inter(fontSize: 13, color: Colors.white60, height: 1.5)),
        ],
      ),
    );
  }
}
