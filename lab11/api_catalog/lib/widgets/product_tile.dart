import 'package:flutter/material.dart';
import '../models/product.dart';

class ProductTile extends StatelessWidget {
  const ProductTile({
    super.key,
    required this.product,
    required this.onTap,
  });

  final Product product;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: onTap,
      leading: SizedBox(
        width: 52,
        height: 52,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(6),
          child: Image.network(
            product.thumbnail,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => const Center(
              child: Icon(Icons.broken_image_outlined),
            ),
          ),
        ),
      ),
      title: Text(
        product.title,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      subtitle: Text(
        '\$${product.price.toStringAsFixed(2)} · ★ ${product.rating.toStringAsFixed(1)}',
      ),
    );
  }
}
