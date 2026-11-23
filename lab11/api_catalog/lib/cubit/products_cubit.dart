import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_api.dart';
import '../models/product.dart';

sealed class ProductsState {
  const ProductsState();
}

final class ProductsLoading extends ProductsState {
  const ProductsLoading();
}

final class ProductsError extends ProductsState {
  const ProductsError(this.message);
  final String message;
}

final class ProductsLoaded extends ProductsState {
  const ProductsLoaded(this.products, {required this.total});

  final List<Product> products;
  final int total;

  bool get hasMore => products.length < total;
}

class ProductsCubit extends Cubit<ProductsState> {
  ProductsCubit(this._api) : super(const ProductsLoading());

  final ProductApi _api;
  bool _loadingMore = false;

  Future<void> load() async {
    emit(const ProductsLoading());
    try {
      final page = await _api.getProducts();
      if (isClosed) return;
      emit(ProductsLoaded(page.products, total: page.total));
    } on ApiException catch (e) {
      if (!isClosed) emit(ProductsError(e.message));
    }
  }

  Future<void> loadMore() async {
    final current = state;
    if (current is! ProductsLoaded || !current.hasMore || _loadingMore) return;

    _loadingMore = true;
    try {
      final page = await _api.getProducts(skip: current.products.length);
      if (isClosed) return;
      emit(
        ProductsLoaded(
          [...current.products, ...page.products],
          total: page.total,
        ),
      );
    } on ApiException catch (e) {
      if (!isClosed) emit(ProductsError(e.message));
    } finally {
      _loadingMore = false;
    }
  }
}
