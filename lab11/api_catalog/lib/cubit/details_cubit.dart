import 'package:flutter_bloc/flutter_bloc.dart';
import '../data/product_api.dart';
import '../models/product.dart';

sealed class DetailsState {
  const DetailsState();
}

final class DetailsLoading extends DetailsState {
  const DetailsLoading();
}

final class DetailsError extends DetailsState {
  const DetailsError(this.message);
  final String message;
}

final class DetailsLoaded extends DetailsState {
  const DetailsLoaded(this.product);
  final Product product;
}

class DetailsCubit extends Cubit<DetailsState> {
  DetailsCubit(this._api) : super(const DetailsLoading());

  final ProductApi _api;

  Future<void> load(int id) async {
    emit(const DetailsLoading());
    try {
      final product = await _api.getProduct(id);
      if (isClosed) return;
      emit(DetailsLoaded(product));
    } on ApiException catch (e) {
      if (!isClosed) emit(DetailsError(e.message));
    }
  }
}
