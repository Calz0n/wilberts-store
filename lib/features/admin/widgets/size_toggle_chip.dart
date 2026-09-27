import 'package:flutter/material.dart';
import '../../../services/product_service.dart';

class SizeToggleChip extends StatelessWidget {
  final String productId;
  final String size;
  final bool isAvailable;

  const SizeToggleChip({
    super.key,
    required this.productId,
    required this.size,
    required this.isAvailable,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(size),
      selected: isAvailable,
      selectedColor: Colors.green.withOpacity(0.3),
      checkmarkColor: Colors.greenAccent,
      onSelected: (newValue) {
        ProductService().updateSizeAvailability(productId, size, newValue);
      },
    );
  }
}
