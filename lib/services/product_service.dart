import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart' show rootBundle;

import '../models/product.dart';

/// Ürünleri yönergedeki API'den okur. Ekstra paket kullanılmadığı için
/// `dart:io` içindeki HttpClient kullanılır. İnternet yoksa assets içindeki
/// JSON kopyasına düşer.
class ProductService {
  static const productsUrl = 'https://wantapi.com/products.php';
  static const bannerUrl = 'https://wantapi.com/assets/banner.png';
  static const _fallbackAsset = 'assets/data/products.json';

  Future<List<Product>> fetchProducts() async {
    String body;
    try {
      body = await _download(productsUrl);
    } catch (_) {
      body = await rootBundle.loadString(_fallbackAsset);
    }
    final decoded = jsonDecode(body) as Map<String, dynamic>;
    final list = decoded['data'] as List<dynamic>;
    return list
        .map((e) => Product.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<String> _download(String url) async {
    final client = HttpClient()
      ..connectionTimeout = const Duration(seconds: 8);
    try {
      final request = await client.getUrl(Uri.parse(url));
      final response = await request.close().timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw HttpException('HTTP ${response.statusCode}');
      }
      return await response.transform(utf8.decoder).join();
    } finally {
      client.close();
    }
  }
}
