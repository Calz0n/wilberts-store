import 'package:flutter/foundation.dart';
import 'package:url_launcher/url_launcher.dart';
import '../constants/app_constants.dart';

class WhatsAppHelper {
  static Future<void> launchWhatsApp(String message) async {
    final uri = Uri.parse(
      "https://wa.me/${AppConstants.whatsappNumber}?text=${Uri.encodeComponent(message)}",
    );

    try {
      if (await canLaunchUrl(uri)) {
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(uri);
      }
    } catch (e) {
      debugPrint("Error al abrir WhatsApp: $e");
      try {
        await launchUrl(uri);
      } catch (_) {}
    }
  }

  static Future<void> sendOrder({
    required String productName,
    required String size,
    required String price,
    int quantity = 1,
  }) async {
    final qtyText = quantity > 1 ? "$quantity unidades de " : "";
    final message = "¡Hola! Quiero ordenar $qtyText la siguiente prenda:\n\n"
        "• Modelo: $productName\n"
        "• Talla: $size\n"
        "• Precio: \$$price ${AppConstants.currency}\n\n"
        "¿Tienen disponibilidad para coordinar la entrega o envío?";

    await launchWhatsApp(message);
  }

  static Future<void> sendSingleOrder({
    required String productName,
    required String size,
    required String price,
    int quantity = 1,
  }) async {
    await sendOrder(
      productName: productName,
      size: size,
      price: price,
      quantity: quantity,
    );
  }
}