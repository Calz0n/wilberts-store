import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class TickerBar extends StatelessWidget {
  const TickerBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 14),
      color: const Color(0xFF141414),
      child: Center(
        child: Text(
          '100% ALGODÓN 240G  •  CORTE OVERSIZE  •  ENVÍOS A TODO MÉXICO',
          style: GoogleFonts.inter(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            letterSpacing: 1.5,
            color: Colors.white70,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
