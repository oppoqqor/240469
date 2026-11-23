import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/products_cubit.dart';
import '../widgets/product_tile.dart';
import 'details_screen.dart';
import 'search_screen.dart';

class ProductsScreen extends StatelessWidget {
  const ProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Search',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(builder: (_) => const SearchScreen()),
              );
            },
          ),
        ],
      ),
      body: BlocBuilder<ProductsCubit, ProductsState>(
        builder: (context, state) => switch (state) {
          ProductsLoading() => const Center(
              child: CircularProgressIndicator(),
            ),
          ProductsError(:final message) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(message, textAlign: TextAlign.center),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () => context.read<ProductsCubit>().load(),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ProductsLoaded(:final products, :final total, :final hasMore) =>
            RefreshIndicator(
              onRefresh: () => context.read<ProductsCubit>().load(),
              child: ListView.builder(
                itemCount: products.length + (hasMore ? 1 : 0),
                itemBuilder: (context, i) {
                  if (i == products.length) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      child: OutlinedButton(
                        onPressed: () =>
                            context.read<ProductsCubit>().loadMore(),
                        child: Text('Load more (${products.length} of $total)'),
                      ),
                    );
                  }
                  final product = products[i];
                  return ProductTile(
                    product: product,
                    onTap: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => DetailsScreen(productId: product.id),
                        ),
                      );
                    },
                  );
                },
              ),
            ),
        },
      ),
    );
  }
}
