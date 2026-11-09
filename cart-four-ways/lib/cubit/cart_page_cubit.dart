import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/cart.dart';
import '../services/checkout_api.dart';
import '../widgets/cart_body.dart';
import 'cart_cubit.dart';

class CubitCartPage extends StatelessWidget {
  const CubitCartPage({super.key});

  @override
  Widget build(BuildContext context) => BlocProvider(
        create: (_) => CartCubit(CheckoutApi()),
        child: BlocListener<CartCubit, CartState>(
          listenWhen: (p, c) => p.status != c.status,
          listener: handleCheckoutEffect,
          child: BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              final cubit = context.read<CartCubit>();
              return Scaffold(
                appBar: AppBar(
                  title: const Text('Cart · Cubit'),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.undo),
                      onPressed: state.canUndo ? cubit.undo : null,
                    ),
                  ],
                ),
                body: CartBody(
                  state: state,
                  onAdd: cubit.add,
                  onRemove: cubit.remove,
                  onQtyChanged: cubit.changeQty,
                  onApplyCoupon: cubit.applyCoupon,
                  onCheckout: cubit.checkout,
                  summaryCard: BlocSelector<CartCubit, CartState, double>(
                    selector: (s) => s.total,
                    builder: (context, _) {
                      debugPrint('Cubit SummaryCard rebuild');
                      return SummaryCard(state: context.read<CartCubit>().state);
                    },
                  ),
                ),
              );
            },
          ),
        ),
      );
}
