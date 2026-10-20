import 'dart:collection';

import 'book_genre.dart';

class Book {
  final String id;
  final String title;
  final BookGenre genre;
  final DateTime meetingDate;
  final String place;
  final int copyLimit;
  final bool isOnline;
  final String? description;
  final bool isFavourite;

  final List<String> _borrowers;

  List<String> get borrowers => UnmodifiableListView(_borrowers);

  const Book({
    required this.id,
    required this.title,
    required this.genre,
    required this.meetingDate,
    required this.place,
    required this.copyLimit,
    required this.isOnline,
    required this.description,
    required this.isFavourite,
    required List<String> borrowers,
  }) : _borrowers = borrowers;

  factory Book.safe({
    required String id,
    required String title,
    required BookGenre genre,
    required DateTime meetingDate,
    required String place,
    required int copyLimit,
    required bool isOnline,
    required String? description,
    required bool isFavourite,
    required List<String> borrowers,
  }) {
    return Book(
      id: id,
      title: title,
      genre: genre,
      meetingDate: meetingDate,
      place: place,
      copyLimit: copyLimit,
      isOnline: isOnline,
      description: description,
      isFavourite: isFavourite,
      borrowers: List.unmodifiable(borrowers),
    );
  }

  Book.empty()
    : id = '',
      title = '',
      genre = BookGenre.fiction,
      meetingDate = DateTime.now().add(const Duration(days: 1)),
      place = '',
      copyLimit = 1,
      _borrowers = const [],
      isOnline = false,
      description = null,
      isFavourite = false;

  int get count => _borrowers.length;

  int get freePlaces => copyLimit - count;

  bool get isFull => count >= copyLimit;

  bool get isPast => meetingDate.isBefore(DateTime.now());

  bool contains(String name) => _borrowers.contains(name);

  ({int taken, int free}) get places => (taken: count, free: freePlaces);

  Book copyWith({
    String? id,
    String? title,
    BookGenre? genre,
    DateTime? meetingDate,
    String? place,
    int? copyLimit,
    List<String>? borrowers,
    bool? isOnline,
    String? description,
    bool clearDescription = false,
    bool? isFavourite,
  }) {
    return Book.safe(
      id: id ?? this.id,
      title: title ?? this.title,
      genre: genre ?? this.genre,
      meetingDate: meetingDate ?? this.meetingDate,
      place: place ?? this.place,
      copyLimit: copyLimit ?? this.copyLimit,
      borrowers: borrowers ?? this.borrowers,
      isOnline: isOnline ?? this.isOnline,
      description: clearDescription ? null : description ?? this.description,
      isFavourite: isFavourite ?? this.isFavourite,
    );
  }
}
