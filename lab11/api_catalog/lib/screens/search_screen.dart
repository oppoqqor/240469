import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../data/product_api.dart';
import '../widgets/product_tile.dart';
import 'details_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => SearchBloc(c.read<ProductApi>()),
      child: Builder(
        builder: (context) => Scaffold(
          appBar: AppBar(title: const Text('Search')),
          body: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(12),
                child: TextField(
                  controller: _controller,
                  textInputAction: TextInputAction.search,
                  decoration: InputDecoration(
                    hintText: 'Search products...',
                    border: const OutlineInputBorder(),
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        _controller.clear();
                        context.read<SearchBloc>().add(const SearchCleared());
                      },
                    ),
                  ),
                  onSubmitted: (value) {
                    context.read<SearchBloc>().add(SearchSubmitted(value));
                  },
                ),
              ),
              Expanded(
                child: BlocBuilder<SearchBloc, SearchState>(
                  builder: (context, state) => switch (state) {
                    SearchIdle() => const Center(
                        child: Text('Type a query and press search.'),
                      ),
                    SearchLoading() => const Center(
                        child: CircularProgressIndicator(),
                      ),
                    SearchEmpty(:final query) => Center(
                        child: Text('No products found for "$query".'),
                      ),
                    SearchError(:final message) => Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(message, textAlign: TextAlign.center),
                        ),
                      ),
                    SearchResults(:final products) => ListView.builder(
                        itemCount: products.length,
                        itemBuilder: (context, i) {
                          final product = products[i];
                          return ProductTile(
                            product: product,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      DetailsScreen(productId: product.id),
                                ),
                              );
                            },
                          );
                        },
                      ),
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
