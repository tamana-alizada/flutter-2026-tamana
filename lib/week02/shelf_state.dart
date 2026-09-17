import 'models.dart';

sealed class ShelfState {
  const ShelfState();
}

class Empty extends ShelfState {
  const Empty();
}

class Broken extends ShelfState {
  final String message;

  const Broken(this.message);
}

class Ready extends ShelfState {
  final List<Book> books;

  const Ready(this.books);
}

String describe(ShelfState state) {
  return switch (state) {
    Empty() => 'The shelf is empty.',
    Ready(:final books) => 'The shelf is ready: ${books.length} books.',
    Broken(:final message) => 'The shelf is broken($message)',
  };
}

({int count, double avgPages}) statsOf(List<Book> books) {
  final totalPages = books.fold<int>(0, (total, book) => total + book.pages);

  final average = books.isEmpty ? 0.0 : totalPages / books.length;

  return (count: books.length, avgPages: average);
}
