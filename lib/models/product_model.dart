import '../core/constants/app_constants.dart';

class Product {
  final String id;
  final String name;
  final String price;
  final List<String> images;
  final String category;
  final int order;
  final Map<String, bool> sizes;
  final String description;
  final bool isFeatured;
  final bool isVisible;
  final bool showOnHome;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.images,
    required this.category,
    required this.order,
    required this.sizes,
    this.description = 'Playera Streetwear Oversize confeccionada en 100% Algodón Peinado pesado de 240g con estampado serigráfico de máxima resistencia y corte drop shoulder.',
    this.isFeatured = false,
    this.isVisible = true,
    this.showOnHome = true,
  });

  String get imageUrl => images.isNotEmpty ? images.first : '';

  factory Product.fromFirestore(Map<String, dynamic> data, String documentId) {
    List<String> parsedImages = [];
    if (data['images'] is List) {
      parsedImages = (data['images'] as List).map((e) => e.toString()).toList();
    } else if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty) {
      parsedImages = [data['imageUrl'].toString()];
    }

    final rawSizes = data['sizes'] is Map ? data['sizes'] as Map : {};
    final Map<String, bool> orderedSizes = {};
    for (final size in AppConstants.standardSizes) {
      if (rawSizes.containsKey(size)) {
        final v = rawSizes[size];
        orderedSizes[size] = (v == true || v == 1 || v == 'true');
      } else {
        orderedSizes[size] = true;
      }
    }

    return Product(
      id: documentId,
      name: data['name']?.toString() ?? '',
      price: data['price']?.toString() ?? '490',
      images: parsedImages,
      category: data['category']?.toString() ?? 'General',
      order: int.tryParse(data['order']?.toString() ?? '0') ?? 0,
      sizes: orderedSizes,
      description: data['description']?.toString() ??
          'Playera Streetwear Oversize confeccionada en 100% Algodón Peinado pesado de 240g con estampado serigráfico de máxima resistencia y corte drop shoulder.',
      isFeatured: data['isFeatured'] == true || data['featured'] == true,
      isVisible: data['isVisible'] ?? true,
      showOnHome: data['showOnHome'] ?? true,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'price': price,
      'images': images,
      'imageUrl': imageUrl,
      'category': category,
      'order': order,
      'sizes': sizes,
      'description': description,
      'isFeatured': isFeatured,
      'isVisible': isVisible,
      'showOnHome': showOnHome,
    };
  }
}