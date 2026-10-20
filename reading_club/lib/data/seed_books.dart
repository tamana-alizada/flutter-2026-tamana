import '../models/book.dart';
import '../models/book_genre.dart';

List<Book> createSeedBooks() {
  final now = DateTime.now();

  return [
    Book.safe(
      id: '1',
      title: 'Atomic Habits',
      genre: BookGenre.selfHelp,
      meetingDate: now.add(const Duration(days: 5)),
      place: 'Library Room 101',
      copyLimit: 5,
      borrowers: ['Ali', 'Sara'],
      isOnline: false,
      description: 'A book about building better habits.',
      isFavourite: false,
    ),

    Book.safe(
      id: '2',
      title: 'The Alchemist',
      genre: BookGenre.fiction,
      meetingDate: now.add(const Duration(days: 7)),
      place: 'Library Room 102',
      copyLimit: 2,
      borrowers: ['Ahmad', 'Fatima'],
      isOnline: false,
      description: 'A story about following your dreams.',
      isFavourite: false,
    ),

    Book.safe(
      id: '3',
      title: 'A Brief History of Time',
      genre: BookGenre.science,
      meetingDate: now.subtract(const Duration(days: 4)),
      place: 'Science Hall',
      copyLimit: 10,
      borrowers: ['Omar'],
      isOnline: false,
      description: 'Explores the universe and time.',
      isFavourite: false,
    ),

    Book.safe(
      id: '4',
      title: 'Clean Code',
      genre: BookGenre.technology,
      meetingDate: now.add(const Duration(days: 10)),
      place: 'https://meet.example.com/clean-code',
      copyLimit: 20,
      borrowers: ['David', 'Sara'],
      isOnline: true,
      description: 'Principles of writing clean code.',
      isFavourite: false,
    ),

    Book.safe(
      id: '5',
      title: 'Sapiens',
      genre: BookGenre.history,
      meetingDate: now.add(const Duration(days: 12)),
      place: 'Library Room 103',
      copyLimit: 8,
      borrowers: [],
      isOnline: false,
      description: null,
      isFavourite: false,
    ),

    Book.safe(
      id: '6',
      title: 'A Guide to Reading Great Books and Understanding Their Ideas',
      genre: BookGenre.fiction,
      meetingDate: now.add(const Duration(days: 15)),
      place: 'Reading Hall',
      copyLimit: 12,
      borrowers: ['Ali'],
      isOnline: false,
      description: 'A discussion about reading techniques.',
      isFavourite: false,
    ),

    Book.safe(
      id: '7',
      title: 'Deep Work',
      genre: BookGenre.selfHelp,
      meetingDate: now.add(const Duration(days: 3)),
      place: 'Study Room 201',
      copyLimit: 6,
      borrowers: ['Sara', 'Omar'],
      isOnline: false,
      description: 'Improving focus and concentration.',
      isFavourite: false,
    ),

    Book.safe(
      id: '8',
      title: 'The Pragmatic Programmer',
      genre: BookGenre.technology,
      meetingDate: now.add(const Duration(days: 18)),
      place: 'Computer Lab',
      copyLimit: 15,
      borrowers: ['David'],
      isOnline: false,
      description: 'Practical software development advice.',
      isFavourite: false,
    ),

    Book.safe(
      id: '9',
      title: 'Cosmos',
      genre: BookGenre.science,
      meetingDate: now.add(const Duration(days: 20)),
      place: 'https://meet.example.com/cosmos',
      copyLimit: 10,
      borrowers: [],
      isOnline: true,
      description: 'An exploration of space and science.',
      isFavourite: false,
    ),

    Book.safe(
      id: '10',
      title: 'The Art of War',
      genre: BookGenre.history,
      meetingDate: now.subtract(const Duration(days: 10)),
      place: 'History Hall',
      copyLimit: 4,
      borrowers: ['Ali', 'Omar'],
      isOnline: false,
      description: 'A classic book about strategy.',
      isFavourite: false,
    ),

    Book.safe(
      id: '11',
      title: 'The Hobbit',
      genre: BookGenre.fiction,
      meetingDate: now.add(const Duration(days: 25)),
      place: 'Library Room 105',
      copyLimit: 5,
      borrowers: [],
      isOnline: false,
      description: 'A fantasy adventure story.',
      isFavourite: false,
    ),

    Book.safe(
      id: '12',
      title: 'Thinking, Fast and Slow',
      genre: BookGenre.selfHelp,
      meetingDate: now.add(const Duration(days: 30)),
      place: 'Discussion Room',
      copyLimit: 7,
      borrowers: ['Fatima'],
      isOnline: false,
      description: 'How people think and make decisions.',
      isFavourite: false,
    ),
  ];
}
