import 'package:flutter/material.dart';

import 'data/seed_books.dart';
import 'models/book.dart';
import 'models/profile.dart';
import 'routes/routes.dart';
import 'screens/books_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';

class AppShell extends StatefulWidget {
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const AppShell({
    super.key,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late List<Book> _books;
  Profile _profile = const Profile.empty();
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    _books = createSeedBooks();
  }

  void _changeTab(int index) {
    setState(() => _selectedIndex = index);
  }

  void _toggleFavourite(Book book) {
    setState(() {
      _books = [
        for (final item in _books)
          if (item.id == book.id)
            // the value should be changed accordingly
            item.copyWith(isFavourite: !item.isFavourite)
          else
            item,
      ];
    });
  }

  void _updateProfile(Profile profile) {
    setState(() => _profile = profile);
  }

  Book _getCurrentBook(String id) => _books.firstWhere((book) => book.id == id);

  void _openBook(Book book) {
    Navigator.pushNamed<void>(
      context,
      Routes.detail,
      arguments: BookDetailArguments(
        book: book,
        getCurrentBook: _getCurrentBook,
        getProfileName: () => _profile.name.trim(),
        onBorrow: _borrowBook,
        onReturn: _returnBook,
        onDelete: _deleteBook,
        onEdit: _editBook,
        onProfileRequested: () => _changeTab(2),
      ),
    );
  }

  void _borrowBook(Book book) {
    final name = _profile.name.trim();
    if (name.isEmpty) return;
    setState(() {
      _books = [
        for (final item in _books)
          if (item.id == book.id && !item.isFull && !item.contains(name))
            item.copyWith(borrowers: [...item.borrowers, name])
          else
            item,
      ];
    });
  }

  void _returnBook(Book book) {
    final name = _profile.name.trim();
    if (name.isEmpty) return;
    setState(() {
      _books = [
        for (final item in _books)
          if (item.id == book.id && item.contains(name))
            item.copyWith(
              borrowers: item.borrowers
                  .where((borrower) => borrower != name)
                  .toList(),
            )
          else
            item,
      ];
    });
  }

  void _deleteBook(Book book) {
    setState(() {
      _books = [
        for (final item in _books)
          if (item.id != book.id) item,
      ];
    });
  }

  Future<void> _openBookForm([Book? existingBook]) async {
    final result = await Navigator.pushNamed<Book>(
      context,
      Routes.form,
      arguments: BookFormArguments(book: existingBook),
    );
    if (!mounted || result == null) return;

    setState(() {
      if (existingBook == null) {
        _books = [..._books, result];
      } else {
        _books = [
          for (final item in _books)
            if (item.id == existingBook.id) result else item,
        ];
      }
    });
  }

  void _addBook() {
    _openBookForm();
  }

  Future<void> _editBook(Book book) => _openBookForm(book);

  Future<void> _showAbout() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('About Reading Club'),
        content: const Text(
          'Browse books, manage borrowing, save favourites, '
          'and update your reader profile.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Reset data?'),
        content: const Text('Restore original books and clear your profile?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
    if (!mounted || confirmed != true) return;
    setState(() {
      _books = createSeedBooks();
      _profile = const Profile.empty();
      _selectedIndex = 0;
    });
    ScaffoldMessenger.of(context)
        .showSnackBar(const SnackBar(content: Text('Data restored')));
  }

  @override
  Widget build(BuildContext context) {
    final pages = [
      BooksScreen(
        books: _books,
        onFavourite: _toggleFavourite,
        onOpenBook: _openBook,
        onAddBook: _addBook,
      ),
      FavouritesScreen(
        books: _books,
        onFavourite: _toggleFavourite,
        onOpenBook: _openBook,
        onBrowseBooks: () => _changeTab(0),
      ),
      ProfileScreen(
        profile: _profile,
        books: _books,
        onProfileChanged: _updateProfile,
        themeMode: widget.themeMode,
        onThemeChanged: widget.onThemeChanged,
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Reading Club')),
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            children: [
              const ListTile(
                leading: Icon(Icons.menu_book),
                title: Text('Reading Club'),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('About'),
                onTap: () {
                  Navigator.pop(context);
                  _showAbout();
                },
              ),
              ListTile(
                leading: const Icon(Icons.restart_alt),
                title: const Text('Reset Data'),
                onTap: () {
                  Navigator.pop(context);
                  _resetData();
                },
              ),
            ],
          ),
        ),
      ),
      body: IndexedStack(index: _selectedIndex, children: pages),
      floatingActionButton: _selectedIndex == 0
          ? FloatingActionButton(
              onPressed: _addBook,
              child: const Icon(Icons.add),
            )
          : null,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: _changeTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Books',
          ),
          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favourites',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
