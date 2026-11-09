import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import 'cart_bloc.dart';
import 'cart_event.dart';

class BlocCartPage extends StatelessWidget {
  const BlocCartPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CartBloc(CheckoutApi()),
        child: BlocListener<CartBloc, CartState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: handleCheckoutEffect,
          child: BlocBuilder<CartBloc, CartState>(
            builder: (context, state) {
              final bloc = context.read<CartBloc>();
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Cart · Bloc'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: state.canUndo ? () => bloc.add(const CartUndone()) : null,
                    ),
                  ],
                ),
                body: CartBody(
                  state: state,
                  onAdd: (p) => bloc.add(CartProductAdded(p)),
                  onRemove: (id) => bloc.add(CartProductRemoved(id)),
                  onQtyChanged: (id, d) => bloc.add(CartQtyChanged(id, d)),
                  onApplyCoupon: (c) => bloc.add(CartCouponApplied(c)),
                  onCheckout: () => bloc.add(const CartCheckoutRequested()),
                  summaryCard: BlocSelector<CartBloc, CartState, double>(
                    selector: (s) => s.total,
                    builder: (context, _) {
                      debugPrint('Bloc SummaryCard rebuild');
                      return SummaryCard(state: context.read<CartBloc>().state);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
}
