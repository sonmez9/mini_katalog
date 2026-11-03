import 'package:flutter/material.dart';

import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/product_image.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);

    return Scaffold(
      appBar: AppBar(
        leadingWidth: 90,
        leading: TextButton.icon(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.chevron_left, color: AppTheme.ink),
          label: const Text('Back', style: TextStyle(color: AppTheme.ink)),
        ),
        title: const Text('Cart'),
      ),
      body: cart.isEmpty
          ? const Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.shopping_cart_outlined,
                    size: 48,
                    color: AppTheme.muted,
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Your cart is empty',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  SizedBox(height: 4),
                  Text(
                    'Add items to start shopping',
                    style: TextStyle(color: AppTheme.muted, fontSize: 12),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: cart.count,
              itemBuilder: (context, i) {
                final p = cart.items[i];
                return ListTile(
                  contentPadding: EdgeInsets.zero,
                  leading: ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: SizedBox(
                      width: 52,
                      height: 52,
                      child: ProductImage(url: p.image),
                    ),
                  ),
                  title: Text(
                    p.name,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  subtitle: Text(
                    p.tagline,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 11),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        p.price,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      IconButton(
                        onPressed: () => cart.removeAt(i),
                        icon: const Icon(
                          Icons.remove_circle_outline,
                          size: 20,
                          color: AppTheme.muted,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppTheme.surface,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.info_outline, size: 16, color: AppTheme.muted),
                    SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        'This is a demo cart. No real payment is made.',
                        style: TextStyle(fontSize: 11, color: AppTheme.muted),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              FilledButton(
                onPressed: cart.isEmpty
                    ? null
                    : () {
                        cart.clear();
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Order placed (demo)'),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                child: const Text('Checkout'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
