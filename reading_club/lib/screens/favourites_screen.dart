import 'package:flutter/material.dart';

import '../models/book.dart';
import '../widgets/book_card.dart';
import '../widgets/empty_state.dart';

class FavouritesScreen extends StatelessWidget {
  final List<Book> books;
  final ValueChanged<Book> onFavourite;
  final ValueChanged<Book> onOpenBook;
  final VoidCallback onBrowseBooks;

  const FavouritesScreen({
    super.key,
    required this.books,
    required this.onFavourite,
    required this.onOpenBook,
    required this.onBrowseBooks,
  });

  @override
  Widget build(BuildContext context) {
    final favourites = books.where((book) => book.isFavourite).toList();

    if (favourites.isEmpty) {
      return EmptyState(
        icon: Icons.favorite_border,
        message: 'You have no favourite books yet.',
        buttonLabel: 'Browse books',
        onPressed: onBrowseBooks,
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.all(12),
      itemCount: favourites.length,
      itemBuilder: (context, index) {
        final book = favourites[index];

        return BookCard(
          book: book,
          onTap: () => onOpenBook(book),
          onFavourite: () => onFavourite(book),
        );
      },
      separatorBuilder: (_, _) => const SizedBox(height: 8),
    );
  }
}
