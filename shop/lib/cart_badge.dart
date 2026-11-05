import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartBadge extends StatelessWidget {
  const CartBadge({super.key});

  @override
  Widget build(BuildContext context) {
    debugPrint('badge build');

    final n = context.select<Cart, int>((cart) => cart.count);

    return Badge(
      label: Text('$n'),
      child: IconButton(
        icon: const Icon(Icons.shopping_cart),
        onPressed: () {
          Navigator.of(context).pushNamed('/cart');
        },
      ),
    );
  }
}