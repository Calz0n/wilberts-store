import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../core/constants/app_constants.dart';
import '../../models/product_model.dart';
import '../../services/auth_service.dart';
import '../../services/product_service.dart';
import '../../services/config_service.dart';
import '../common/smart_product_image.dart';
import '../catalog/widgets/product_detail_dialog.dart';

// ignore: avoid_web_libraries_in_flutter
import 'dart:html' as html;

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  final ProductService _productService = ProductService();
  final AuthService _authService = AuthService();
  final ConfigService _configService = ConfigService.instance;

  void _pickAndUploadPhotoBase64(String productId) {
    try {
      final uploadInput = html.FileUploadInputElement()..accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((e) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final file = files[0];
          final reader = html.FileReader();
          reader.readAsDataUrl(file);
          reader.onLoadEnd.listen((event) {
            if (reader.result != null) {
              final base64String = reader.result as String;
              _productService.addPhoto(productId, base64String);
            }
          });
        }
      });
    } catch (_) {
      _showAddPhotoUrlDialog(productId);
    }
  }

  void _showAddPhotoUrlDialog(String productId) {
    final urlCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        title: const Text('Agregar foto a la prenda', style: TextStyle(color: Colors.white, fontSize: 16)),
        content: TextField(
          controller: urlCtrl,
          decoration: const InputDecoration(labelText: 'URL de la imagen o Base64'),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () {
              if (urlCtrl.text.trim().isNotEmpty) {
                _productService.addPhoto(productId, urlCtrl.text.trim());
                Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text('AGREGAR'),
          ),
        ],
      ),
    );
  }

  void _showChangePhoneDialog() {
    final phoneCtrl = TextEditingController(text: AppConstants.whatsappNumber);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('NÚMERO DE WHATSAPP', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Ingresa el número receptor de pedidos (ej. 529210000000):',
              style: TextStyle(fontSize: 12, color: Colors.white70),
            ),
            const SizedBox(height: 14),
            TextField(
              controller: phoneCtrl,
              keyboardType: TextInputType.phone,
              autofocus: true,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
              decoration: const InputDecoration(
                prefixText: '+ ',
                labelText: 'Número con código de país',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () async {
              final raw = phoneCtrl.text.trim();
              if (raw.isNotEmpty) {
                await _configService.updateWhatsAppNumber(raw);
                if (mounted) {
                  setState(() {});
                  Navigator.pop(ctx);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("✓ WhatsApp guardado: +${AppConstants.whatsappNumber}"),
                      backgroundColor: const Color(0xFF14301B),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text('GUARDAR'),
          ),
        ],
      ),
    );
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController(text: '490');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF141414),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('AGREGAR NUEVA PRENDA', style: GoogleFonts.montserrat(fontWeight: FontWeight.bold, fontSize: 16, color: Colors.white)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Nombre del modelo (ej. Gothic Cross)')),
            const SizedBox(height: 12),
            TextField(controller: priceCtrl, keyboardType: TextInputType.number, decoration: const InputDecoration(labelText: 'Precio en MXN')),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar', style: TextStyle(color: Colors.white54))),
          ElevatedButton(
            onPressed: () async {
              if (nameCtrl.text.trim().isNotEmpty) {
                await _productService.createProduct(
                  name: nameCtrl.text.trim(),
                  price: priceCtrl.text.trim(),
                  sizes: {for (var s in AppConstants.standardSizes) s: true},
                );
                if (mounted) Navigator.pop(ctx);
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: Colors.black),
            child: const Text('CREAR PRENDA'),
          ),
        ],
      ),
    );
  }

  // VENTANA MODAL EDITAR INFORMACIÓN
  void _showEditProductDialog(Product product) {
    final nameCtrl = TextEditingController(text: product.name);
    final priceCtrl = TextEditingController(text: product.price);
    final orderCtrl = TextEditingController(text: product.order.toString());
    final descCtrl = TextEditingController(text: product.description);

    bool isVisible = product.isVisible;
    bool isFeatured = product.isFeatured;
    bool showOnHome = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) {
          final isMobile = MediaQuery.of(context).size.width < 650;

          return Dialog(
            backgroundColor: const Color(0xFF141414),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            insetPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 750),
              child: Padding(
                padding: const EdgeInsets.all(28),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Editar Información',
                        style: GoogleFonts.montserrat(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 24),

                      // Nombre del modelo
                      const Text(
                        'Nombre del modelo',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      TextField(
                        controller: nameCtrl,
                        style: const TextStyle(fontSize: 15, color: Colors.white),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 20),

                      // Precio y Posición
                      if (isMobile) ...[
                        const Text(
                          'Precio (MXN)',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        TextField(
                          controller: priceCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                        const SizedBox(height: 18),
                        const Text(
                          'Posición (1 = 1ra)',
                          style: TextStyle(fontSize: 12, color: Colors.white70),
                        ),
                        TextField(
                          controller: orderCtrl,
                          keyboardType: TextInputType.number,
                          style: const TextStyle(fontSize: 15, color: Colors.white),
                          decoration: const InputDecoration(
                            isDense: true,
                            contentPadding: EdgeInsets.symmetric(vertical: 8),
                            border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                            enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                            focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                          ),
                        ),
                      ] else ...[
                        Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Precio (MXN)',
                                    style: TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                  TextField(
                                    controller: priceCtrl,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontSize: 15, color: Colors.white),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 32),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Text(
                                    'Posición (1 = 1ra)',
                                    style: TextStyle(fontSize: 12, color: Colors.white70),
                                  ),
                                  TextField(
                                    controller: orderCtrl,
                                    keyboardType: TextInputType.number,
                                    style: const TextStyle(fontSize: 15, color: Colors.white),
                                    decoration: const InputDecoration(
                                      isDense: true,
                                      contentPadding: EdgeInsets.symmetric(vertical: 8),
                                      border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                                      enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                                      focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),

                      // Descripción
                      const Text(
                        'Descripción / Características',
                        style: TextStyle(fontSize: 12, color: Colors.white70),
                      ),
                      TextField(
                        controller: descCtrl,
                        maxLines: null,
                        style: const TextStyle(fontSize: 14, color: Colors.white, height: 1.4),
                        decoration: const InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.symmetric(vertical: 8),
                          border: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          enabledBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white24)),
                          focusedBorder: UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
                        ),
                      ),
                      const SizedBox(height: 28),

                      const Divider(color: Colors.white12, height: 1),
                      const SizedBox(height: 20),

                      // Switch 1: Visible en la tienda
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Visible en la tienda',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Si lo desactivas, los clientes no la verán',
                                  style: TextStyle(fontSize: 12, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: isVisible,
                            activeColor: const Color(0xFF55E7A2),
                            activeTrackColor: const Color(0xFF55E7A2).withOpacity(0.4),
                            inactiveThumbColor: Colors.white70,
                            inactiveTrackColor: Colors.white24,
                            onChanged: (val) {
                              setDialogState(() => isVisible = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Switch 2: Mostrar en el carrusel de portada
                      Row(
                        children: [
                          const Expanded(
                            child: Text(
                              'Mostrar en el carrusel de portada',
                              style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                            ),
                          ),
                          Switch(
                            value: isFeatured,
                            activeColor: const Color(0xFF55E7A2),
                            activeTrackColor: const Color(0xFF55E7A2).withOpacity(0.4),
                            inactiveThumbColor: Colors.white70,
                            inactiveTrackColor: Colors.white24,
                            onChanged: (val) {
                              setDialogState(() => isFeatured = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 18),

                      // Switch 3: Mostrar en colección de portada
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  'Mostrar en colección de portada',
                                  style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.white),
                                ),
                                SizedBox(height: 2),
                                Text(
                                  'Si lo apagas, solo se verá en el catálogo completo',
                                  style: TextStyle(fontSize: 12, color: Colors.white54),
                                ),
                              ],
                            ),
                          ),
                          Switch(
                            value: showOnHome,
                            activeColor: const Color(0xFF55E7A2),
                            activeTrackColor: const Color(0xFF55E7A2).withOpacity(0.4),
                            inactiveThumbColor: Colors.white70,
                            inactiveTrackColor: Colors.white24,
                            onChanged: (val) {
                              setDialogState(() => showOnHome = val);
                            },
                          ),
                        ],
                      ),
                      const SizedBox(height: 28),

                      // Botones inferiores
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Cancelar', style: TextStyle(color: Colors.white70, fontSize: 13)),
                          ),
                          const SizedBox(width: 14),
                          ElevatedButton(
                            onPressed: () async {
                              final parsedOrder = int.tryParse(orderCtrl.text.trim()) ?? product.order;
                              await _productService.updateFullProductDetails(
                                id: product.id,
                                name: nameCtrl.text.trim(),
                                price: priceCtrl.text.trim(),
                                order: parsedOrder,
                                description: descCtrl.text.trim(),
                                isVisible: isVisible,
                                isFeatured: isFeatured,
                                showOnHome: showOnHome,
                              );
                              if (mounted) Navigator.pop(ctx);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                            ),
                            child: const Text('Guardar', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13)),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070707),
      appBar: AppBar(
        backgroundColor: const Color(0xFF070707),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacementNamed(context, '/'),
        ),
        title: Text(
          'ADMINISTRACIÓN',
          style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.bold, letterSpacing: 1.5, color: Colors.white),
        ),
        actions: [
          TextButton(
            onPressed: _showChangePhoneDialog,
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: Text(
              'WhatsApp: +${AppConstants.whatsappNumber}',
              style: const TextStyle(color: Colors.greenAccent, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () => Navigator.pushNamed(context, '/'),
            style: TextButton.styleFrom(
              backgroundColor: const Color(0xFF1A1A1A),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
            child: const Text(
              'Ver Tienda',
              style: TextStyle(color: Colors.white70, fontSize: 11),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white70),
            tooltip: 'Cerrar sesión',
            onPressed: () => _authService.signOut(),
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1100),
            child: Column(
              children: [
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _showAddProductDialog,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    ),
                    child: Text(
                      '+ AGREGAR NUEVA PRENDA',
                      style: GoogleFonts.montserrat(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                        color: Colors.black,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),

                StreamBuilder<List<Product>>(
                  stream: _productService.getProductsStream(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator(color: Colors.white));
                    }
                    final products = snapshot.data!;
                    if (products.isEmpty) {
                      return const Padding(
                        padding: EdgeInsets.all(48),
                        child: Text(
                          'No hay prendas registradas. Agrega una nueva con el botón superior.',
                          style: TextStyle(color: Colors.white54),
                        ),
                      );
                    }

                    return ListView.separated(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: products.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 18),
                      itemBuilder: (context, index) {
                        final product = products[index];
                        final itemNumber = index + 1;
                        final photoCount = product.images.length;
                        final isVisible = product.isVisible;

                        return AnimatedOpacity(
                          duration: const Duration(milliseconds: 250),
                          opacity: isVisible ? 1.0 : 0.45,
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 250),
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              color: isVisible ? const Color(0xFF0F0F0F) : const Color(0xFF160B0B),
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isVisible ? Colors.white12 : Colors.redAccent.withOpacity(0.4),
                                width: isVisible ? 1 : 1.5,
                              ),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                if (!isVisible)
                                  Container(
                                    width: double.infinity,
                                    margin: const EdgeInsets.only(bottom: 12),
                                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                                    decoration: BoxDecoration(
                                      color: Colors.red.withOpacity(0.15),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: Colors.redAccent.withOpacity(0.4)),
                                    ),
                                    child: const Text(
                                      '🚫 PRENDA PAUSADA (Oculta para los clientes)',
                                      style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                    ),
                                  ),

                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF1E1E1E),
                                        borderRadius: BorderRadius.circular(4),
                                      ),
                                      child: Text(
                                        '#$itemNumber',
                                        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white70),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Text(
                                        product.name,
                                        style: GoogleFonts.montserrat(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    InkWell(
                                      onTap: () {
                                        showDialog(
                                          context: context,
                                          builder: (c) => AlertDialog(
                                            backgroundColor: const Color(0xFF141414),
                                            title: const Text('¿Eliminar prenda?', style: TextStyle(color: Colors.white)),
                                            content: Text('Se eliminará ${product.name} definitivamente.'),
                                            actions: [
                                              TextButton(onPressed: () => Navigator.pop(c), child: const Text('Cancelar')),
                                              TextButton(
                                                onPressed: () {
                                                  _productService.deleteProduct(product.id);
                                                  Navigator.pop(c);
                                                },
                                                child: const Text('Eliminar', style: TextStyle(color: Colors.redAccent)),
                                              ),
                                            ],
                                          ),
                                        );
                                      },
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                                        decoration: BoxDecoration(
                                          color: Colors.red.withOpacity(0.15),
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(color: Colors.redAccent.withOpacity(0.5)),
                                        ),
                                        child: const Text(
                                          '✕ Eliminar',
                                          style: TextStyle(color: Colors.redAccent, fontSize: 11, fontWeight: FontWeight.bold),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),

                                Padding(
                                  padding: const EdgeInsets.only(top: 6, bottom: 16),
                                  child: Text(
                                    '\$${product.price} MXN • $photoCount/5 fotos',
                                    style: GoogleFonts.inter(fontSize: 13, color: Colors.white60),
                                  ),
                                ),

                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: [
                                      InkWell(
                                        onTap: photoCount >= 5
                                            ? () {
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(content: Text('Límite de 5 fotos por prenda alcanzado.')),
                                          );
                                        }
                                            : () => _pickAndUploadPhotoBase64(product.id),
                                        borderRadius: BorderRadius.circular(4),
                                        child: Container(
                                          width: 70,
                                          height: 70,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF141414),
                                            borderRadius: BorderRadius.circular(4),
                                            border: Border.all(color: Colors.white24),
                                          ),
                                          child: const Column(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            children: [
                                              Text('+', style: TextStyle(fontSize: 22, color: Colors.white70, fontWeight: FontWeight.bold)),
                                              Text('Subir foto', style: TextStyle(fontSize: 10, color: Colors.white70)),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),

                                      ...List.generate(product.images.length, (photoIdx) {
                                        final imgStr = product.images[photoIdx];

                                        return Padding(
                                          padding: const EdgeInsets.only(right: 12),
                                          child: Stack(
                                            children: [
                                              Container(
                                                width: 70,
                                                height: 70,
                                                decoration: BoxDecoration(
                                                  color: Colors.black,
                                                  borderRadius: BorderRadius.circular(4),
                                                  border: Border.all(color: Colors.white12),
                                                ),
                                                child: ClipRRect(
                                                  borderRadius: BorderRadius.circular(4),
                                                  child: SmartProductImage(imageSource: imgStr),
                                                ),
                                              ),
                                              Positioned(
                                                top: 2,
                                                right: 2,
                                                child: InkWell(
                                                  onTap: () {
                                                    _productService.removePhoto(product.id, photoIdx);
                                                  },
                                                  child: Container(
                                                    padding: const EdgeInsets.all(3),
                                                    decoration: const BoxDecoration(
                                                      color: Colors.black87,
                                                      shape: BoxShape.circle,
                                                    ),
                                                    child: const Icon(Icons.close, size: 12, color: Colors.redAccent),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        );
                                      }),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 18),

                                // FILA: [Editar información] | [Ver Detalle] | [BOTÓN SIN EMOJI]
                                Row(
                                  children: [
                                    Expanded(
                                      child: OutlinedButton(
                                        onPressed: () => _showEditProductDialog(product),
                                        style: OutlinedButton.styleFrom(
                                          side: const BorderSide(color: Colors.white24),
                                          padding: const EdgeInsets.symmetric(vertical: 14),
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                        ),
                                        child: Text(
                                          'Editar información',
                                          style: GoogleFonts.montserrat(fontSize: 12, color: Colors.white),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    OutlinedButton(
                                      onPressed: () => ProductDetailDialog.show(context, product),
                                      style: OutlinedButton.styleFrom(
                                        side: const BorderSide(color: Colors.white24),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
                                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                                      ),
                                      child: const Text('Ver Detalle', style: TextStyle(color: Colors.white70, fontSize: 11)),
                                    ),
                                    const SizedBox(width: 8),

                                    // BOTÓN DE ESTADO SIN EMOJI
                                    InkWell(
                                      onTap: () {
                                        _productService.updateVisibility(product.id, !isVisible);
                                      },
                                      borderRadius: BorderRadius.circular(20),
                                      child: AnimatedContainer(
                                        duration: const Duration(milliseconds: 200),
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                        decoration: BoxDecoration(
                                          color: isVisible ? const Color(0xFF14301B) : const Color(0xFF2E1212),
                                          borderRadius: BorderRadius.circular(20),
                                          border: Border.all(
                                            color: isVisible ? const Color(0xFF55E7A2) : Colors.redAccent,
                                            width: 1.5,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Container(
                                              width: 7,
                                              height: 7,
                                              decoration: BoxDecoration(
                                                shape: BoxShape.circle,
                                                color: isVisible ? const Color(0xFF55E7A2) : Colors.redAccent,
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              isVisible ? 'Activa' : 'Pausada',
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: isVisible ? const Color(0xFF55E7A2) : Colors.redAccent,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 18),

                                Text(
                                  'Disponibilidad de tallas:',
                                  style: GoogleFonts.inter(fontSize: 12, color: Colors.white54),
                                ),
                                const SizedBox(height: 10),
                                Wrap(
                                  spacing: 8,
                                  children: AppConstants.standardSizes.map((size) {
                                    final isAvailable = product.sizes[size] ?? true;

                                    return InkWell(
                                      onTap: () {
                                        _productService.updateSizeAvailability(product.id, size, !isAvailable);
                                      },
                                      borderRadius: BorderRadius.circular(4),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                        decoration: BoxDecoration(
                                          color: isAvailable ? const Color(0xFF1E1E1E) : Colors.transparent,
                                          borderRadius: BorderRadius.circular(4),
                                          border: Border.all(
                                            color: isAvailable ? Colors.white : Colors.white24,
                                            width: isAvailable ? 1.5 : 1,
                                          ),
                                        ),
                                        child: Text(
                                          size,
                                          style: TextStyle(
                                            fontSize: 12,
                                            fontWeight: FontWeight.bold,
                                            color: isAvailable ? Colors.white : Colors.white24,
                                            decoration: isAvailable ? null : TextDecoration.lineThrough,
                                          ),
                                        ),
                                      ),
                                    );
                                  }).toList(),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}