import 'package:flutter/material.dart';

/// Ağdan görsel yükler; yüklenemezse yer tutucu gösterir.
class ProductImage extends StatelessWidget {
  final String url;
  final BoxFit fit;

  const ProductImage({super.key, required this.url, this.fit = BoxFit.cover});

  @override
  Widget build(BuildContext context) {
    return Image.network(
      url,
      fit: fit,
      loadingBuilder: (context, child, progress) => progress == null
          ? child
          : const Center(child: CircularProgressIndicator(strokeWidth: 2)),
      errorBuilder: (context, error, stack) => const ColoredBox(
        color: Color(0xFFF3F3F5),
        child: Center(
          child: Icon(Icons.image_not_supported_outlined, color: Colors.grey),
        ),
      ),
    );
  }
}
