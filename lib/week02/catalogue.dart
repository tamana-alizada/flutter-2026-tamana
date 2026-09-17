import 'models.dart';

class Library {
  final List<LibraryItem> items;

  Library({List<LibraryItem>? items}) : items = items ?? [];

  void add(LibraryItem item) {
    items.add(item);
  }

  Book? findByTitle(String title) {
    for (final item in items) {
      if (item is Book && item.title == title) {
        return item;
      }
    }

    return null;
  }

  String countryOf(String title) {
    return findByTitle(title)?.author.country ?? 'unknown';
  }

  late final DateTime openedAt;

  void open() {
    openedAt = DateTime.now();
  }

  String? _cachedReport;

  String get report {
    return _cachedReport ??= items.map((item) => item.describe()).join('\n');
  }

  // Level 4 - no for loops is allowed here

  List<String> get everyTitle => items.map((item) => item.title).toList();

  List<Book> get booksAfter2010 =>
      items.whereType<Book>().where((book) => book.year > 2010).toList();

  // there might be no element to get the operation started
  // We use fold instead of reduce, because reduce throws an error
  double get averagePages {
    final books = items.whereType<Book>().toList();

    return books.isEmpty
        ? 0
        : books.fold<int>(0, (total, book) => total + book.pages) /
              books.length;
  }

  // how many books each author has?
  Map<String, int> get booksByAuthor =>
      items.whereType<Book>().fold<Map<String, int>>(
        {},
        (result, book) => {
          ...result,
          book.author.name: (result[book.author.name] ?? 0) + 1,
        },
      );

  Set<String> get distinctAuthors =>
      items.whereType<Book>().map((book) => book.author.name).toSet();

  Set<Genre> get genresPresent =>
      items.whereType<Book>().map((book) => book.genre).toSet();

  List<String> get displayList => [
    'CATALOGUE',
    for (final book in items.whereType<Book>()) '${book.title} (${book.year})',
    ...items.whereType<Book>().map((book) => book.author.name),
    if (items.whereType<Book>().any((book) => book.pages == 0))
      '(incomplete data)',
  ];
}
