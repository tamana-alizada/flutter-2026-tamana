import 'package:flutter/material.dart';

import 'data/seed_books.dart';
import 'models/book.dart';
import 'screens/books_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late List<Book> _books;

  @override
  void initState() {
    super.initState();
    _books = createSeedBooks();
  }

  void _toggleFavourite(Book book) {
    setState(() {
      _books = [
        for (final item in _books)
          if (item.id == book.id)
            item.copyWith(isFavourite: !item.isFavourite)
          else
            item,
      ];
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: BooksScreen(
        books: _books,
        onFavourite: _toggleFavourite,
        onOpenBook: (book) {
          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text(book.title)));
        },
        onAddBook: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Book form coming next')),
          );
        },
      ),
    );
  }
}
