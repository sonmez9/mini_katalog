import 'package:flutter_test/flutter_test.dart';
import 'package:mini_katalog/state/cart_state.dart';
import 'package:mini_katalog/models/product.dart';

void main() {
  test('Sepete ekleme ve çıkarma', () {
    final cart = CartState();
    const p = Product(
      id: 1,
      name: 'Test',
      tagline: '',
      description: '',
      price: '\$1',
      currency: 'USD',
      image: '',
      specs: {},
    );
    cart.add(p);
    expect(cart.count, 1);
    cart.removeAt(0);
    expect(cart.isEmpty, true);
  });
}
