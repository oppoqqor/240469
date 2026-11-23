import 'dart:convert';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:api_catalog/cubit/products_cubit.dart';
import 'package:api_catalog/data/product_api.dart';

String _fixturePageJson() {
  final product = jsonDecode(
    File('test/fixtures/product.json').readAsStringSync(),
  );
  return jsonEncode({
    'products': [product],
    'total': 1,
    'skip': 0,
    'limit': 20,
  });
}

void main() {
  blocTest<ProductsCubit, ProductsState>(
    'emits loading then loaded on success',
    build: () {
      final client = MockClient(
        (_) async => http.Response(_fixturePageJson(), 200),
      );
      return ProductsCubit(ProductApi(client: client));
    },
    act: (cubit) => cubit.load(),
    expect: () => [isA<ProductsLoading>(), isA<ProductsLoaded>()],
  );

  blocTest<ProductsCubit, ProductsState>(
    'emits loading then error on failure',
    build: () {
      final client = MockClient((_) async => http.Response('error', 500));
      return ProductsCubit(ProductApi(client: client));
    },
    act: (cubit) => cubit.load(),
    expect: () => [isA<ProductsLoading>(), isA<ProductsError>()],
  );
}
