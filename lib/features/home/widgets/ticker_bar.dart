import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TickerBar extends StatelessWidget {
  const TickerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
      decoration: const BoxDecoration(
        color: Color(0xFF131313), // Fondo carbón mate con elegante contraste
      ),
      child: Center(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: const BouncingScrollPhysics(),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '100% ALGODÓN 240G',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('•', style: TextStyle(color: Colors.white38, fontSize: 14)),
              ),
              Text(
                'CORTE OVERSIZE',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 14),
                child: Text('•', style: TextStyle(color: Colors.white38, fontSize: 14)),
              ),
              Text(
                'ENTREGAS LOCALES Y ENVÍOS A TODO MÉXICO',
                style: GoogleFonts.montserrat(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 2.0,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}