import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';

class SmartProductImage extends StatelessWidget {
  final String imageSource;
  final BoxFit fit;
  final double? width;
  final double? height;

  const SmartProductImage({
    super.key,
    required this.imageSource,
    this.fit = BoxFit.contain,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    if (imageSource.trim().isEmpty) {
      return const Center(child: Icon(Icons.checkroom, color: Colors.white24, size: 36));
    }

    // Caso 1: Imagen en Base64 (Data URI o cadena pura)
    if (imageSource.startsWith('data:image') || (!imageSource.startsWith('http') && !imageSource.startsWith('assets/'))) {
      try {
        final pureBase64 = imageSource.contains(',') ? imageSource.split(',').last : imageSource;
        final Uint8List bytes = base64Decode(pureBase64.trim());
        return Image.memory(
          bytes,
          fit: fit,
          width: width,
          height: height,
          gaplessPlayback: true,
          errorBuilder: (_, __, ___) => const Center(
            child: Icon(Icons.broken_image, color: Colors.white24, size: 36),
          ),
        );
      } catch (e) {
        return const Center(
          child: Icon(Icons.broken_image, color: Colors.white24, size: 36),
        );
      }
    }

    // Caso 2: URL de internet (HTTP / HTTPS)
    if (imageSource.startsWith('http')) {
      return Image.network(
        imageSource,
        fit: fit,
        width: width,
        height: height,
        errorBuilder: (_, __, ___) => const Center(
          child: Icon(Icons.broken_image, color: Colors.white24, size: 36),
        ),
      );
    }

    // Caso 3: Recurso estático local (assets/...)
    return Image.asset(
      imageSource,
      fit: fit,
      width: width,
      height: height,
      errorBuilder: (_, __, ___) => const Center(
        child: Icon(Icons.checkroom, color: Colors.white24, size: 36),
      ),
    );
  }
}
