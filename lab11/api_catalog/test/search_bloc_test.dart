import 'dart:convert';
import 'dart:io';
import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:api_catalog/bloc/search_bloc.dart';
import 'package:api_catalog/bloc/search_event.dart';
import 'package:api_catalog/bloc/search_state.dart';
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
  blocTest<SearchBloc, SearchState>(
    'emits loading then results for a query',
    build: () {
      final client = MockClient(
        (_) async => http.Response(_fixturePageJson(), 200),
      );
      return SearchBloc(ProductApi(client: client));
    },
    act: (bloc) => bloc.add(const SearchSubmitted('phone')),
    expect: () => [isA<SearchLoading>(), isA<SearchResults>()],
  );

  blocTest<SearchBloc, SearchState>(
    'emits only SearchIdle for whitespace query',
    build: () {
      final client = MockClient(
        (_) async => http.Response(_fixturePageJson(), 200),
      );
      return SearchBloc(ProductApi(client: client));
    },
    seed: () => const SearchEmpty('old'),
    act: (bloc) => bloc.add(const SearchSubmitted('   ')),
    expect: () => [isA<SearchIdle>()],
  );
}
