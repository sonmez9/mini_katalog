import 'package:flutter/material.dart';

import '../models/product.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';
import 'cart_screen.dart';

class DetailScreen extends StatelessWidget {
  static const routeName = '/detail';

  const DetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Route Arguments ile gelen ürün.
    final product = ModalRoute.of(context)!.settings.arguments as Product;
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: AppTheme.ink),
          label: const Text('Back', style: TextStyle(color: AppTheme.ink)),
        ),
        actions: [
          IconButton(
            onPressed: () => Navigator.pushNamed(context, CartScreen.routeName),
            icon: Badge(
              isLabelVisible: cart.count > 0,
              label: Text('${cart.count}'),
              child: const Icon(Icons.shopping_bag_outlined),
            ),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
        children: [
          AspectRatio(
            aspectRatio: 1.1,
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: ProductImage(url: product.image),
            ),
          ),
          const SizedBox(height: 16),
          Text(product.name,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 2),
          Text(product.tagline,
              style: const TextStyle(color: AppTheme.muted, fontSize: 13)),
          const SizedBox(height: 4),
          Text(product.price,
              style: const TextStyle(
                  color: Colors.blue,
                  fontSize: 18,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 16),
          const Text('Description',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 6),
          Text(product.description,
              style: const TextStyle(fontSize: 13, height: 1.45)),
          const SizedBox(height: 16),
          const Text('Specifications',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Row(
            children: [
              for (final e in product.specs.entries)
                Expanded(
                  child: Card(
                    elevation: 0,
                    color: AppTheme.surface,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(e.key.toUpperCase(),
                              style: const TextStyle(
                                  fontSize: 10, color: AppTheme.muted)),
                          const SizedBox(height: 2),
                          Text(e.value,
                              style: const TextStyle(
                                  fontSize: 13, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              cart.add(product);
              ScaffoldMessenger.of(context)
                ..hideCurrentSnackBar()
                ..showSnackBar(SnackBar(
                  content: Text('${product.name} added to cart'),
                  duration: const Duration(seconds: 1),
                ));
            },
            child: const Text('Add to cart'),
          ),
        ],
      ),
    );
  }
}
