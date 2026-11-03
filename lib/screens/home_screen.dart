import 'package:flutter/material.dart';

import '../models/product.dart';
import '../services/product_service.dart';
import '../state/cart_state.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';
import 'cart_screen.dart';
import 'detail_screen.dart';

class HomeScreen extends StatefulWidget {
  static const routeName = '/';

  final ProductService? service;

  const HomeScreen({super.key, this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final ProductService _service;
  late Future<List<Product>> _future;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _service = widget.service ?? ProductService();
    _future = _service.fetchProducts();
  }

  void _reload() => setState(() => _future = _service.fetchProducts());

  @override
  Widget build(BuildContext context) {
    final cart = CartScope.of(context);
    return Scaffold(
      body: SafeArea(
        child: FutureBuilder<List<Product>>(
          future: _future,
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasError) {
              return Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text('Ürünler yüklenemedi'),
                    const SizedBox(height: 12),
                    FilledButton(
                      onPressed: _reload,
                      style: FilledButton.styleFrom(
                        minimumSize: const Size(140, 44),
                      ),
                      child: const Text('Tekrar dene'),
                    ),
                  ],
                ),
              );
            }

            final q = _query.trim().toLowerCase();
            final products = snapshot.data!
                .where(
                  (p) =>
                      q.isEmpty ||
                      p.name.toLowerCase().contains(q) ||
                      p.tagline.toLowerCase().contains(q),
                )
                .toList();

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(child: _header(cart)),
                SliverToBoxAdapter(child: _searchField()),
                SliverToBoxAdapter(child: _banner()),
                if (products.isEmpty)
                  const SliverFillRemaining(
                    hasScrollBody: false,
                    child: Center(child: Text('Sonuç bulunamadı')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                    sliver: SliverGrid.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 16,
                            crossAxisSpacing: 12,
                            childAspectRatio: 0.78,
                          ),
                      itemCount: products.length,
                      itemBuilder: (context, i) => ProductCard(
                        product: products[i],
                        onTap: () => Navigator.pushNamed(
                          context,
                          DetailScreen.routeName,
                          arguments: products[i],
                        ),
                      ),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _header(CartState cart) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 8, 8),
      child: Row(
        children: [
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Discover',
                  style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
                ),
                Text(
                  'Find your perfect device',
                  style: TextStyle(color: AppTheme.muted, fontSize: 13),
                ),
              ],
            ),
          ),
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
    );
  }

  Widget _searchField() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: TextField(
        onChanged: (v) => setState(() => _query = v),
        decoration: InputDecoration(
          hintText: 'Search products',
          prefixIcon: const Icon(Icons.search, size: 20),
          filled: true,
          fillColor: AppTheme.surface,
          contentPadding: const EdgeInsets.symmetric(vertical: 0),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget _banner() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Image.network(
          ProductService.bannerUrl,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stack) =>
              Image.asset('assets/images/banner.png', fit: BoxFit.cover),
        ),
      ),
    );
  }
}
