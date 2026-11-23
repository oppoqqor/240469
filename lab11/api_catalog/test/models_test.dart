import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:api_catalog/models/product.dart';

void main() {
  test('parses product fixture without network', () {
    final raw = File('test/fixtures/product.json').readAsStringSync();
    final json = jsonDecode(raw) as Map<String, dynamic>;
    final product = Product.fromJson(json);

    expect(product.title, 'Essence Mascara Lash Princess');
    expect(product.price, isA<double>());
    expect(product.price, 9.99);
    expect(product.tags.length, 2);
    expect(product.reviews.length, 3);
  });

  test('handles missing brand and tags', () {
    final map = <String, dynamic>{
      'id': 2,
      'title': 'Sample Item',
      'price': 10,
      'rating': 4,
      'thumbnail': 'https://example.com/img.png',
      'dimensions': {'width': 1, 'height': 2, 'depth': 3},
      'reviews': <dynamic>[],
    };

    final product = Product.fromJson(map);

    expect(product.brand, isNull);
    expect(product.tags, isEmpty);
  });
}
