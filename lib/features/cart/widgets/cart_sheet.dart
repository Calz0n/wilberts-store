import '../../common/smart_product_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/whatsapp_helper.dart';
import '../../../services/cart_service.dart';

class CartSheet extends StatefulWidget {
  const CartSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => const CartSheet(),
    );
  }

  @override
  State<CartSheet> createState() => _CartSheetState();
}

class _CartSheetState extends State<CartSheet> {
  // 'local' o 'nacional'
  String _deliveryType = 'local';
  final TextEditingController _postalCodeCtrl = TextEditingController();

  @override
  void dispose() {
    _postalCodeCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cart = CartService.instance;

    return AnimatedBuilder(
      animation: cart,
      builder: (context, _) {
        final items = cart.items;

        return Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.90,
            maxWidth: 520,
          ),
          decoration: const BoxDecoration(
            color: Color(0xFF0F0F0F),
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
            border: Border(top: BorderSide(color: Colors.white12, width: 1)),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 18),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Encabezado: MI CARRITO (N)  Vaciar  X
              Row(
                children: [
                  const Icon(Icons.shopping_bag_outlined, color: Colors.white, size: 22),
                  const SizedBox(width: 10),
                  Text(
                    'MI CARRITO (${cart.totalItems})',
                    style: GoogleFonts.montserrat(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  const Spacer(),
                  if (items.isNotEmpty)
                    TextButton(
                      onPressed: () => cart.clearCart(),
                      child: const Text(
                        'Vaciar',
                        style: TextStyle(color: Color(0xFFE53935), fontSize: 13, fontWeight: FontWeight.w600),
                      ),
                    ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Colors.white70, size: 22),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 12),

              // Lista de productos
              Flexible(
                child: items.isEmpty
                    ? const Padding(
                  padding: EdgeInsets.symmetric(vertical: 48),
                  child: Center(
                    child: Text(
                      'Tu carrito está vacío.',
                      style: TextStyle(color: Colors.white54, fontSize: 14),
                    ),
                  ),
                )
                    : ListView.separated(
                  shrinkWrap: true,
                  itemCount: items.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 16),
                  itemBuilder: (context, index) {
                    final item = items[index];
                    final isPreOrder = item.size.contains('Sobre pedido');
                    final displaySize = item.size.replaceAll(' (Sobre pedido)', '');

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Miniatura
                        Container(
                          width: 56,
                          height: 56,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(4),
                            border: Border.all(color: Colors.white12),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(4),
                            child: SmartProductImage(
                              imageSource: item.imageUrl,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        // Info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                item.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: GoogleFonts.montserrat(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Wrap(
                                spacing: 6,
                                runSpacing: 4,
                                crossAxisAlignment: WrapCrossAlignment.center,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF222222),
                                      borderRadius: BorderRadius.circular(3),
                                    ),
                                    child: Text(
                                      'Talla $displaySize',
                                      style: const TextStyle(
                                        fontSize: 11,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white70,
                                      ),
                                    ),
                                  ),
                                  if (isPreOrder)
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.12),
                                        borderRadius: BorderRadius.circular(3),
                                        border: Border.all(color: Colors.white24),
                                      ),
                                      child: const Text(
                                        'SOBRE PEDIDO',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white70,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '\$${item.price} ${AppConstants.currency}',
                                style: GoogleFonts.inter(
                                  fontSize: 13,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Selector de cantidad (-) 1 (+) compacto
                        Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              icon: const Icon(Icons.remove_circle_outline, color: Colors.white70, size: 20),
                              onPressed: () => cart.updateQuantity(item.id, -1),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 4),
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                              ),
                            ),
                            IconButton(
                              visualDensity: VisualDensity.compact,
                              padding: EdgeInsets.zero,
                              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                              icon: const Icon(Icons.add_circle_outline, color: Colors.white70, size: 20),
                              onPressed: () => cart.updateQuantity(item.id, 1),
                            ),
                          ],
                        ),
                      ],
                    );
                  },
                ),
              ),

              const SizedBox(height: 12),
              const Divider(color: Colors.white10, thickness: 1),
              const SizedBox(height: 10),

              // TOTAL ESTIMADO
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'TOTAL ESTIMADO',
                    style: GoogleFonts.montserrat(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '\$${cart.totalPrice.toStringAsFixed(0)} ${AppConstants.currency}',
                    style: GoogleFonts.montserrat(
                      fontSize: 22,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 18),

              // BOTONES DE ENVÍO: TIPO DE ENTREGA (Local / Nacional)
              Text(
                'TIPO DE ENTREGA',
                style: GoogleFonts.montserrat(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1.5,
                  color: Colors.white70,
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  // Local
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _deliveryType = 'local'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161616),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _deliveryType == 'local' ? Colors.white : Colors.white12,
                            width: _deliveryType == 'local' ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.location_on_outlined, size: 22, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Local',
                                  style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text('Punto medio', style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Nacional
                  Expanded(
                    child: InkWell(
                      onTap: () => setState(() => _deliveryType = 'nacional'),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFF161616),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(
                            color: _deliveryType == 'nacional' ? Colors.white : Colors.white12,
                            width: _deliveryType == 'nacional' ? 1.5 : 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined, size: 22, color: Colors.white),
                            const SizedBox(width: 10),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Nacional',
                                  style: GoogleFonts.montserrat(fontSize: 13, fontWeight: FontWeight.bold, color: Colors.white),
                                ),
                                Text('Paquetería', style: GoogleFonts.inter(fontSize: 11, color: Colors.white54)),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),

              // Campo de Código Postal cuando se elige Envío Nacional
              if (_deliveryType == 'nacional') ...[
                const SizedBox(height: 14),
                TextField(
                  controller: _postalCodeCtrl,
                  keyboardType: TextInputType.number,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                  decoration: InputDecoration(
                    labelText: 'Código Postal de destino (C.P.)',
                    labelStyle: const TextStyle(color: Colors.white70, fontSize: 13),
                    hintText: 'Ej. 96400',
                    hintStyle: const TextStyle(color: Colors.white30, fontSize: 13),
                    prefixIcon: const Icon(Icons.markunread_mailbox_outlined, color: Colors.white70, size: 20),
                    filled: true,
                    fillColor: const Color(0xFF161616),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide: const BorderSide(color: Colors.white24),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(4)),
                      borderSide: BorderSide(color: Colors.white),
                    ),
                  ),
                ),
              ],

              const SizedBox(height: 20),

              // Botón CONFIRMAR PEDIDO POR WHATSAPP
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton.icon(
                  onPressed: items.isEmpty
                      ? null
                      : () {
                    final buffer = StringBuffer();
                    buffer.writeln("¡Hola! Quiero ordenar el siguiente pedido en ${AppConstants.appTitle}:");
                    buffer.writeln("");
                    for (final it in items) {
                      final tag = it.size.contains('Sobre pedido') ? " [SOBRE PEDIDO]" : "";
                      buffer.writeln("• ${it.quantity}x ${it.name} (Talla: ${it.size})$tag - \$${it.price} c/u");
                    }
                    buffer.writeln("");
                    buffer.writeln("Total estimado: \$${cart.totalPrice.toStringAsFixed(0)} ${AppConstants.currency}");
                    if (_deliveryType == 'nacional') {
                      final cp = _postalCodeCtrl.text.trim();
                      final cpText = cp.isNotEmpty ? " (C.P.: $cp)" : "";
                      buffer.writeln("Tipo de entrega: Nacional por paquetería$cpText");
                    } else {
                      buffer.writeln("Tipo de entrega: Local (Punto medio en Coatzacoalcos)");
                    }
                    buffer.writeln("");
                    buffer.writeln("¿Me podrían confirmar disponibilidad para coordinar el pago?");

                    WhatsAppHelper.launchWhatsApp(buffer.toString());
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18, color: Colors.black),
                  label: Text(
                    'CONFIRMAR PEDIDO POR WHATSAPP',
                    style: GoogleFonts.montserrat(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.2,
                      color: items.isEmpty ? Colors.white24 : Colors.black,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: Colors.black,
                    disabledBackgroundColor: Colors.white12,
                    disabledForegroundColor: Colors.white24,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}