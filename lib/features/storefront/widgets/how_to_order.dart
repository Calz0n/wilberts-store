import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HowToOrderSection extends StatelessWidget {
  const HowToOrderSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0D0D0D),
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 48),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 1100),
        child: Column(
          children: [
            Text('¿CÓMO PEDIR?', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 36),
            Wrap(
              spacing: 32,
              runSpacing: 24,
              alignment: WrapAlignment.center,
              children: const [
                _StepCard(
                  step: '01',
                  title: 'Elige tu modelo',
                  desc: 'Revisa el catálogo y escoge el diseño streetwear que buscas.',
                ),
                _StepCard(
                  step: '02',
                  title: 'Confirma disponibilidad',
                  desc: 'Selecciona una talla activa (las tachadas están agotadas).',
                ),
                _StepCard(
                  step: '03',
                  title: 'Ordena por WhatsApp',
                  desc: 'El botón generará el mensaje listo para coordinar la entrega o envío.',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StepCard extends StatelessWidget {
  final String step;
  final String title;
  final String desc;

  const _StepCard({required this.step, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(step, style: GoogleFonts.pirataOne(fontSize: 32, color: Colors.white24)),
          const SizedBox(height: 8),
          Text(title, style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text(desc, style: GoogleFonts.inter(fontSize: 13, color: Colors.white60)),
        ],
      ),
    );
  }
}
