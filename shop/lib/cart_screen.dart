import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/cart.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  Future<void> _confirmClear(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Clear cart?'),
          content: const Text('Are you sure you want to remove all books?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(false);
              },
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop(true);
              },
              child: const Text('Clear'),
            ),
          ],
        );
      },
    );

    if (!context.mounted) return;

    if (confirmed == true) {
      context.read<Cart>().clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cart'),
        actions: [
          IconButton(
            tooltip: 'Clear cart',
            icon: const Icon(Icons.delete_outline),
            onPressed: () => _confirmClear(context),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Consumer<Cart>(
              builder: (context, cart, child) {
                if (cart.items.isEmpty) {
                  return const Center(child: Text('Your cart is empty'));
                }

                return ListView(
                  children: cart.items.map((b) {
                    return ListTile(
                      title: Text(b.title),
                      subtitle: Text('${b.price} ₸ × ${cart.qtyOf(b)}'),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text('×${cart.qtyOf(b)}'),
                          IconButton(
                            icon: const Icon(Icons.add),
                            onPressed: () {
                              cart.increment(b);
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.close),
                            onPressed: () {
                              cart.remove(b);
                            },
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                );
              },
            ),
          ),
          Consumer<Cart>(
            child: const TotalLabel(),
            builder: (context, cart, child) {
              return Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    child!,
                    Text(
                      '${cart.total} ₸',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class TotalLabel extends StatelessWidget {
  const TotalLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.receipt_long),
        SizedBox(width: 8),
        Text('Total:', style: TextStyle(fontSize: 20)),
      ],
    );
  }
}