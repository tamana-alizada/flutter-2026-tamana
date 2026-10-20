import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/book_genre.dart';
import '../widgets/book_card.dart';
import '../widgets/empty_state.dart';

class BooksScreen extends StatefulWidget {
  final List<Book> books;
  final ValueChanged<Book> onFavourite;
  final ValueChanged<Book> onOpenBook;
  final VoidCallback onAddBook;

  const BooksScreen({
    super.key,
    required this.books,
    required this.onFavourite,
    required this.onOpenBook,
    required this.onAddBook,
  });

  @override
  State<BooksScreen> createState() => _BooksScreenState();
}

class _BooksScreenState extends State<BooksScreen> {
  final TextEditingController _searchController = TextEditingController();

  BookGenre? _selectedGenre;
  bool _showPast = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Book> get _filteredBooks {
    final query = _searchController.text.trim().toLowerCase();

    final filtered = widget.books.where((book) {
      final matchesSearch = book.title.toLowerCase().contains(query);

      final matchesGenre =
          _selectedGenre == null || book.genre == _selectedGenre;

      final matchesPast = _showPast || !book.isPast;

      return matchesSearch && matchesGenre && matchesPast;
    }).toList();

    filtered.sort((a, b) {
      if (a.isPast != b.isPast) {
        return a.isPast ? 1 : -1;
      }
      return a.meetingDate.compareTo(b.meetingDate);
    });

    return filtered;
  }

  void _clearFilters() {
    setState(() {
      _searchController.clear();
      _selectedGenre = null;
      _showPast = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final books = _filteredBooks;

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Club')),
      floatingActionButton: FloatingActionButton(
        onPressed: widget.onAddBook,
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              decoration: InputDecoration(
                labelText: 'Search books',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _searchController.text.isEmpty
                    ? null
                    : IconButton(
                        onPressed: _clearFilters,
                        icon: const Icon(Icons.clear),
                      ),
                border: const OutlineInputBorder(),
              ),
            ),
          ),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                ChoiceChip(
                  label: const Text('All'),
                  selected: _selectedGenre == null,
                  onSelected: (_) {
                    setState(() => _selectedGenre = null);
                  },
                ),
                const SizedBox(width: 8),
                for (final genre in BookGenre.values) ...[
                  ChoiceChip(
                    label: Text(genre.label),
                    selected: _selectedGenre == genre,
                    onSelected: (_) {
                      setState(() => _selectedGenre = genre);
                    },
                  ),
                  const SizedBox(width: 8),
                ],
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(12),
            child: Align(
              alignment: Alignment.centerLeft,
              child: FilterChip(
                label: const Text('Include past meetings'),
                selected: _showPast,
                onSelected: (value) {
                  setState(() => _showPast = value);
                },
              ),
            ),
          ),
          Expanded(
            child: books.isEmpty
                ? EmptyState(
                    icon: Icons.menu_book,
                    message: 'No matching books found',
                    buttonLabel: 'Clear filters',
                    onPressed: _clearFilters,
                  )
                : LayoutBuilder(
                    builder: (context, constraints) {
                      final width = constraints.maxWidth;

                      if (width < 600) {
                        return ListView.separated(
                          padding: const EdgeInsets.all(12),
                          itemCount: books.length,
                          itemBuilder: (context, index) {
                            final book = books[index];
                            return BookCard(
                              book: book,
                              onTap: () => widget.onOpenBook(book),
                              onFavourite: () => widget.onFavourite(book),
                            );
                          },
                          separatorBuilder: (_, _) => const SizedBox(height: 8),
                        );
                      }

                      final columns = (width / 360).ceil().clamp(2, 6);

                      return GridView.builder(
                        padding: const EdgeInsets.all(12),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: columns,
                          mainAxisExtent: 150,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                        ),
                        itemCount: books.length,
                        itemBuilder: (context, index) {
                          final book = books[index];
                          return BookCard(
                            book: book,
                            onTap: () => widget.onOpenBook(book),
                            onFavourite: () => widget.onFavourite(book),
                          );
                        },
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
