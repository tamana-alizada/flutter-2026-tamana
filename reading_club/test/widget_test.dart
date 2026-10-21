import 'package:flutter_test/flutter_test.dart';
import 'package:reading_club/data/seed_books.dart';

void main() {
  test('Reading Club provides twelve seed books', () {
    final books = createSeedBooks();
    expect(books.length, 12);
    expect(books.any((book) => book.isFull), isTrue);
    expect(books.any((book) => book.isPast), isTrue);
    expect(books.any((book) => book.isOnline), isTrue);
    expect(books.any((book) => book.description == null), isTrue);
  });

  test('Borrowers list cannot be modified from outside', () {
    final book = createSeedBooks().first;
    expect(() => book.borrowers.add('Someone'), throwsUnsupportedError);
  });
}
