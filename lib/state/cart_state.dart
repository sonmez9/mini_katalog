import 'package:flutter/widgets.dart';

import '../models/product.dart';

/// Bellekte tutulan basit sepet durumu (simülasyon).
class CartState extends ChangeNotifier {
  final List<Product> _items = [];

  List<Product> get items => List.unmodifiable(_items);
  int get count => _items.length;
  bool get isEmpty => _items.isEmpty;

  void add(Product product) {
    _items.add(product);
    notifyListeners();
  }

  void removeAt(int index) {
    _items.removeAt(index);
    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
  }
}

/// Paket kullanmadan sepet durumunu widget ağacına taşır.
class CartScope extends InheritedNotifier<CartState> {
  const CartScope({
    super.key,
    required CartState cart,
    required super.child,
  }) : super(notifier: cart);

  static CartState of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<CartScope>();
    assert(scope != null, 'CartScope bulunamadı');
    return scope!.notifier!;
  }
}
