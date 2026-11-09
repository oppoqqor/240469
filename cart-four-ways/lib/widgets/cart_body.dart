import 'package:flutter/material.dart';
import '../models/cart.dart';

class CartBody extends StatefulWidget {
  const CartBody({
    super.key,
    required this.state,
    required this.onAdd,
    required this.onRemove,
    required this.onQtyChanged,
    required this.onApplyCoupon,
    required this.onCheckout,
    this.summaryCard,
  });

  final CartState state;
  final void Function(Product) onAdd;
  final void Function(String productId) onRemove;
  final void Function(String productId, int delta) onQtyChanged;
  final void Function(String code) onApplyCoupon;
  final VoidCallback onCheckout;
  final Widget? summaryCard;

  @override
  State<CartBody> createState() => _CartBodyState();
}

class _CartBodyState extends State<CartBody> {
  final _couponCtrl = TextEditingController();

  @override
  void dispose() {
    _couponCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final s = widget.state;
    return Column(children: [
      Padding(
        padding: const EdgeInsets.all(12),
        child: Wrap(spacing: 8, children: [
          for (final p in catalog)
            ActionChip(
              label: Text('${p.name} · ${p.price.toStringAsFixed(0)}'),
              onPressed: () => widget.onAdd(p),
            ),
        ]),
      ),
      Expanded(
        child: s.lines.isEmpty
            ? const Center(child: Text('Cart is empty'))
            : ListView(children: [
                for (final l in s.lines)
                  ListTile(
                    key: ValueKey(l.product.id),
                    title: Text(l.product.name),
                    subtitle: Text('× ${l.qty}'),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.remove),
                          onPressed: () => widget.onQtyChanged(l.product.id, -1),
                        ),
                        IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () => widget.onQtyChanged(l.product.id, 1),
                        ),
                      ],
                    ),
                  ),
              ]),
      ),
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(children: [
          Expanded(
            child: TextField(
              controller: _couponCtrl,
              decoration: InputDecoration(
                labelText: 'Coupon',
                errorText: s.couponError,
              ),
            ),
          ),
          const SizedBox(width: 8),
          FilledButton(
            onPressed: () => widget.onApplyCoupon(_couponCtrl.text),
            child: const Text('Apply'),
          ),
        ]),
      ),
      widget.summaryCard ?? SummaryCard(state: s),
      Padding(
        padding: const EdgeInsets.all(12),
        child: SizedBox(
          width: double.infinity,
          child: FilledButton(
            onPressed: s.lines.isEmpty ? null : widget.onCheckout,
            child: s.status == CheckoutStatus.submitting
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Checkout'),
          ),
        ),
      ),
    ]);
  }
}

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key, required this.state});
  final CartState state;

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.all(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Items: ${state.itemCount}'),
              Text('Subtotal: ${state.subtotal.toStringAsFixed(2)}'),
            ]),
            Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
              Text('Discount: ${state.discount.toStringAsFixed(2)}'),
              Text('Total: ${state.total.toStringAsFixed(2)}'),
            ]),
          ]),
        ),
      );
}

void handleCheckoutEffect(BuildContext context, CartState state) {
  final messenger = ScaffoldMessenger.of(context);
  messenger.clearMaterialBanners();
  if (state.status == CheckoutStatus.success) {
    messenger.showSnackBar(SnackBar(content: Text('Order ${state.orderId}')));
  } else if (state.status == CheckoutStatus.failure) {
    messenger.showMaterialBanner(MaterialBanner(
      content: Text(state.checkoutError ?? 'Checkout failed'),
      actions: [
        TextButton(onPressed: messenger.clearMaterialBanners, child: const Text('DISMISS')),
      ],
    ));
  }
}
