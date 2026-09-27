import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class HowToOrderSection extends StatelessWidget {
  const HowToOrderSection({super.key});

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0E0E0E), // Fondo con contraste tipo bloque
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 56),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1000),
          child: Column(
            children: [
              // Título
              Text(
                '¿CÓMO PEDIR?',
                style: GoogleFonts.pirataOne(
                  fontSize: 44,
                  color: Colors.white,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 40),

              // Pasos 01, 02, 03
              Wrap(
                spacing: 36,
                runSpacing: 32,
                alignment: WrapAlignment.center,
                children: const [
                  _StepItem(
                    step: '01',
                    title: 'Elige tu modelo',
                    desc: 'Revisa el catálogo y escoge el diseño que buscas.',
                  ),
                  _StepItem(
                    step: '02',
                    title: 'Confirma disponibilidad',
                    desc: 'Escoge tu talla. Si no hay stock inmediato, puedes pedirla Sobre Pedido.',
                  ),
                  _StepItem(
                    step: '03',
                    title: 'Ordena por WhatsApp',
                    desc: 'El botón generará el mensaje listo para coordinar el pago y envío.',
                  ),
                ],
              ),
              const SizedBox(height: 52),

              // Métodos de Pago
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                decoration: BoxDecoration(
                  color: const Color(0xFF141414),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  children: [
                    Text(
                      'MÉTODOS DE PAGO ACEPTADOS',
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 2,
                        color: Colors.white70,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      alignment: WrapAlignment.center,
                      children: const [
                        _PaymentChip(icon: Icons.account_balance_outlined, label: 'Transferencia SPEI'),
                        _PaymentChip(icon: Icons.storefront_outlined, label: 'Depósito en OXXO'),
                        _PaymentChip(icon: Icons.credit_card_outlined, label: 'Tarjetas Débito / Crédito'),
                        _PaymentChip(icon: Icons.payments_outlined, label: 'Efectivo en entregas locales'),
                      ],
                    ),
                    const SizedBox(height: 18),
                    Text(
                      'Los datos bancarios o número de cuenta se proporcionan de forma directa y segura por WhatsApp al confirmar las piezas de tu pedido.',
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        color: Colors.white38,
                        height: 1.4,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 52),

              // Redes Sociales
              Text(
                'SÍGUENOS EN NUESTRAS REDES',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 18),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _SocialButton(
                    icon: Icons.camera_alt_outlined,
                    label: 'INSTAGRAM',
                    onTap: () => _launchUrl('https://www.instagram.com/wilberts.store?stkn=MWwwbjA3NmYwMm1iYg=='),
                  ),
                  const SizedBox(width: 14),
                  _SocialButton(
                    icon: Icons.music_note_outlined,
                    label: 'TIKTOK',
                    onTap: () => _launchUrl('https://www.tiktok.com/@wilbertstore2?_r=1&_t=ZS-9A4Nijc1WZ2'),
                  ),
                ],
              ),
              const SizedBox(height: 40),

              // Footer
              Text(
                "© 2026 Wilberts' Store. Todos los derechos reservados.",
                style: GoogleFonts.inter(
                  fontSize: 11,
                  color: Colors.white24,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StepItem extends StatelessWidget {
  final String step;
  final String title;
  final String desc;

  const _StepItem({required this.step, required this.title, required this.desc});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 280,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            step,
            style: GoogleFonts.pirataOne(
              fontSize: 42,
              color: Colors.white38,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.montserrat(
              fontSize: 15,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            desc,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.white60,
              height: 1.4,
            ),
          ),
        ],
      ),
    );
  }
}

class _PaymentChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _PaymentChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E1E),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: Colors.white70),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({required this.icon, required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(4),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFF1E1E1E),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.montserrat(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}