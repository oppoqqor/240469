import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubit/details_cubit.dart';
import '../data/product_api.dart';

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key, required this.productId});

  final int productId;

  String _formatDate(DateTime d) {
    final m = d.month.toString().padLeft(2, '0');
    final day = d.day.toString().padLeft(2, '0');
    return '${d.year}-$m-$day';
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (c) => DetailsCubit(c.read<ProductApi>())..load(productId),
      child: Scaffold(
        appBar: AppBar(title: const Text('Details')),
        body: BlocBuilder<DetailsCubit, DetailsState>(
          builder: (context, state) => switch (state) {
            DetailsLoading() => const Center(
                child: CircularProgressIndicator(),
              ),
            DetailsError(:final message) => Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(message, textAlign: TextAlign.center),
                      const SizedBox(height: 12),
                      ElevatedButton(
                        onPressed: () =>
                            context.read<DetailsCubit>().load(productId),
                        child: const Text('Retry'),
                      ),
                    ],
                  ),
                ),
              ),
            DetailsLoaded(:final product) => ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  SizedBox(
                    height: 220,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: product.images.isNotEmpty
                          ? product.images.length
                          : 1,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (_, i) {
                        final url = product.images.isNotEmpty
                            ? product.images[i]
                            : product.thumbnail;
                        return ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            url,
                            width: 220,
                            height: 220,
                            fit: BoxFit.cover,
                            errorBuilder: (_, _, _) => const SizedBox(
                              width: 220,
                              child: Center(
                                child: Icon(Icons.broken_image_outlined, size: 40),
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    product.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '\$${product.price.toStringAsFixed(2)} · ★ ${product.rating.toStringAsFixed(1)}'
                    '${product.brand != null ? ' · ${product.brand}' : ''}',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  if (product.description.isNotEmpty) ...[
                    const SizedBox(height: 12),
                    Text(product.description),
                  ],
                  const SizedBox(height: 16),
                  Text(
                    'Dimensions',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'W ${product.dimensions.width} × '
                    'H ${product.dimensions.height} × '
                    'D ${product.dimensions.depth}',
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Reviews (${product.reviews.length})',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  if (product.reviews.isEmpty)
                    const Text('No reviews yet.')
                  else
                    for (final review in product.reviews)
                      Card(
                        margin: const EdgeInsets.only(bottom: 8),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    '★ ${review.rating} · ${review.reviewerName}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    _formatDate(review.date),
                                    style: Theme.of(context).textTheme.bodySmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 6),
                              Text(review.comment),
                            ],
                          ),
                        ),
                      ),
                ],
              ),
          },
        ),
      ),
    );
  }
}
