import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'models/book.dart';
import 'models/cart.dart';
import 'cart_badge.dart';

class BooksScreen extends StatefulWidget {
  const BooksScreen({super.key});

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  String searchText = '';

  @override
  Widget build(BuildContext context) {
    final filteredBooks = books.where((book) {
      return book.title.toLowerCase().contains(searchText.toLowerCase()) ||
          book.author.toLowerCase().contains(searchText.toLowerCase());
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Books'),
        actions: const [CartBadge()],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(65),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search books...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
                filled: true,
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),
        ),
      ),
      body: ListView(
        children: filteredBooks.map((b) {
          return Builder(
            builder: (context) {
              final isAdded = context.watch<Cart>().items.contains(b);

              return ListTile(
                title: Text(b.title),
                subtitle: Text('${b.author} • ${b.price} ₸'),
                trailing: isAdded
                    ? const Text('Added')
                    : OutlinedButton(
                        onPressed: () {
                          final ok = context.read<Cart>().add(b);

                          if (ok) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Added'),
                                duration: Duration(seconds: 1),
                              ),
                            );
                          }
                        },
                        child: const Text('Add'),
                      ),
              );
            },
          );
        }).toList(),
      ),
    );
  }
}