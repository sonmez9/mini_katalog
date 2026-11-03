import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/main.dart';
import 'package:mini_katalog/services/product_service.dart';
import 'package:mini_katalog/models/product.dart';

/// Ağa dokunmadan assets/data/products.json dosyasını okuyan test servisi.
class _AssetOnlyService extends ProductService {
  @override
  Future<List<Product>> fetchProducts() async {
    final body = File('assets/data/products.json').readAsStringSync();
    final data = (jsonDecode(body) as Map<String, dynamic>)['data'] as List;
    return data
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }
}

/// Ürünler assets/data/products.json yedeğinden okunur.
Future<void> _launch(WidgetTester tester) async {
  await tester.binding.setSurfaceSize(const Size(430, 1000));
  await tester.pumpWidget(MiniKatalogApp(service: _AssetOnlyService()));
  await _waitForLoad(tester);
}

/// Asset/ağ okuma gerçek I/O olduğu için sahte zamanın dışında beklenir;
/// yükleme göstergeleri kaybolana kadar kareler çizilir.
Future<void> _waitForLoad(WidgetTester tester) async {
  for (var i = 0; i < 40; i++) {
    await tester.runAsync(
      () => Future.delayed(const Duration(milliseconds: 50)),
    );
    await tester.pump(const Duration(milliseconds: 50));
    if (find.byType(CircularProgressIndicator).evaluate().isEmpty) break;
  }
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('Ana sayfa ürünleri ve banner yüklenir', (tester) async {
    await _launch(tester);
    expect(find.text('Discover'), findsOneWidget);
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    expect(find.byType(SliverGrid), findsOneWidget);
  });

  testWidgets('Arama ürünleri filtreler', (tester) async {
    await _launch(tester);
    await tester.enterText(find.byType(TextField), 'macbook air');
    await tester.pumpAndSettle();
    expect(find.text('iPhone 15 Pro'), findsNothing);
    expect(find.text('MacBook Air 15"'), findsOneWidget);

    await tester.enterText(find.byType(TextField), 'zzzz');
    await tester.pumpAndSettle();
    expect(find.text('Sonuç bulunamadı'), findsOneWidget);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
  });

  testWidgets('Detay, sepete ekleme, silme ve checkout akışı', (tester) async {
    await _launch(tester);

    // Boş sepet
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();

    // Detay (Route Arguments ile ürün gelir)
    await tester.tap(find.text('iPhone 15 Pro'));
    await tester.pumpAndSettle();
    expect(find.text('Description'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Specifications'), 300);
    expect(find.text('Specifications'), findsOneWidget);
    expect(find.text('A17 Pro'), findsOneWidget);

    // Sepete ekle
    await tester.scrollUntilVisible(find.text('Add to cart'), 300);
    await tester.tap(find.text('Add to cart'));
    await tester.pump();
    expect(find.text('1'), findsOneWidget); // rozet

    // Sepet: ürün listelenir, silinince boşalır
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    expect(find.text('iPhone 15 Pro'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.remove_circle_outline));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Tekrar ekle ve Checkout
    await tester.tap(find.text('Back'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Add to cart'), 300);
    await tester.tap(find.text('Add to cart'));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.shopping_bag_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Checkout'));
    await tester.pumpAndSettle();
    expect(find.text('Your cart is empty'), findsOneWidget);
  });
}
