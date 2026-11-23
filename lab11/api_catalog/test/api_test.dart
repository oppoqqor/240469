import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:api_catalog/data/product_api.dart';

void main() {
  test('getProducts returns one product from fixture page', () async {
    final productJson = File('test/fixtures/product.json').readAsStringSync();
    final pageBody = jsonEncode({
      'products': [jsonDecode(productJson)],
      'total': 1,
      'skip': 0,
      'limit': 20,
    });

    final client = MockClient((_) async => http.Response(pageBody, 200));
    final api = ProductApi(client: client);

    final page = await api.getProducts();

    expect(page.products.length, 1);
    expect(page.products.first.title, 'Essence Mascara Lash Princess');
    expect(page.total, 1);
  });

  test('getProduct throws ApiException on 404', () async {
    final client = MockClient(
      (_) async => http.Response('{"message":"Not found"}', 404),
    );
    final api = ProductApi(client: client);

    expect(() => api.getProduct(0), throwsA(isA<ApiException>()));
  });
}
