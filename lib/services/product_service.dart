import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product_model.dart';
import '../core/constants/app_constants.dart';

class ProductService {
  final CollectionReference _productsRef =
  FirebaseFirestore.instance.collection('products');

  Stream<List<Product>> getProductsStream({bool onlyVisible = false}) {
    return _productsRef.snapshots().map((snapshot) {
      final list = snapshot.docs.map((doc) {
        final data = doc.data() as Map<String, dynamic>? ?? {};
        return Product.fromFirestore(data, doc.id);
      }).toList();
      list.sort((a, b) => a.order.compareTo(b.order));
      if (onlyVisible) {
        return list.where((p) => p.isVisible).toList();
      }
      return list;
    });
  }

  /// Prendas que se muestran en el carrusel de portada
  Stream<List<Product>> getFeaturedProductsStream() {
    return getProductsStream(onlyVisible: true).map((list) {
      final featured = list.where((p) => p.isFeatured).toList();
      if (featured.isEmpty && list.isNotEmpty) {
        return list.take(5).toList();
      }
      return featured;
    });
  }

  /// Prendas que el admin seleccionó para mostrar en 'Colección Disponible' en la portada
  Stream<List<Product>> getHomeProductsStream() {
    return getProductsStream(onlyVisible: true).map((list) {
      final homeList = list.where((p) => p.showOnHome).toList();
      return homeList.isEmpty ? list : homeList;
    });
  }

  Future<void> createProduct({
    required String name,
    required String price,
    List<String> images = const [],
    Map<String, bool>? sizes,
  }) async {
    final initialSizes = sizes ?? {for (var s in AppConstants.standardSizes) s: true};
    final countSnapshot = await _productsRef.get();
    final newOrder = countSnapshot.docs.length + 1;

    await _productsRef.add({
      'name': name,
      'price': price,
      'images': images,
      'imageUrl': images.isNotEmpty ? images.first : '',
      'category': 'Streetwear',
      'order': newOrder,
      'sizes': initialSizes,
      'isFeatured': false,
      'isVisible': true,
      'showOnHome': true,
      'description': 'Playera Streetwear Oversize confeccionada en 100% Algodón Peinado pesado de 240g con serigrafía tacto cero.',
    });
  }

  Future<void> updateProductInfo(String id, String name, String price) async {
    await _productsRef.doc(id).set({
      'name': name,
      'price': price,
    }, SetOptions(merge: true));
  }

  Future<void> updateVisibility(String id, bool isVisible) async {
    await _productsRef.doc(id).set({
      'isVisible': isVisible,
    }, SetOptions(merge: true));
  }

  Future<void> updateFeaturedStatus(String id, bool isFeatured) async {
    await _productsRef.doc(id).set({
      'isFeatured': isFeatured,
    }, SetOptions(merge: true));
  }

  Future<void> updateShowOnHome(String id, bool showOnHome) async {
    await _productsRef.doc(id).set({
      'showOnHome': showOnHome,
    }, SetOptions(merge: true));
  }

  Future<void> updateSizeAvailability(String id, String size, bool isAvailable) async {
    await _productsRef.doc(id).set({
      'sizes': {size: isAvailable},
    }, SetOptions(merge: true));
  }

  Future<void> addPhoto(String id, String photoBase64OrUrl) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>? ?? {};
    List<String> current = [];
    if (data['images'] is List) {
      current = (data['images'] as List).map((e) => e.toString()).toList();
    } else if (data['imageUrl'] != null && data['imageUrl'].toString().isNotEmpty) {
      current = [data['imageUrl'].toString()];
    }

    if (current.length < 5) {
      current.add(photoBase64OrUrl);
      await _productsRef.doc(id).set({
        'images': current,
        'imageUrl': current.first,
      }, SetOptions(merge: true));
    }
  }

  Future<void> removePhoto(String id, int photoIndex) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) return;
    final data = doc.data() as Map<String, dynamic>? ?? {};
    List<String> current = [];
    if (data['images'] is List) {
      current = (data['images'] as List).map((e) => e.toString()).toList();
    }

    if (photoIndex >= 0 && photoIndex < current.length) {
      current.removeAt(photoIndex);
      await _productsRef.doc(id).set({
        'images': current,
        'imageUrl': current.isNotEmpty ? current.first : '',
      }, SetOptions(merge: true));
    }
  }

  Future<void> deleteProduct(String id) async {
    await _productsRef.doc(id).delete();
  }

  Future<void> updateFullProductDetails({
    required String id,
    required String name,
    required String price,
    required int order,
    required String description,
    required bool isVisible,
    required bool isFeatured,
    bool showOnHome = true,
  }) async {
    await _productsRef.doc(id).set({
      'name': name,
      'price': price,
      'order': order,
      'description': description,
      'isVisible': isVisible,
      'isFeatured': isFeatured,
      'showOnHome': showOnHome,
    }, SetOptions(merge: true));
  }
}