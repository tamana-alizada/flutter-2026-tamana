import 'package:flutter/material.dart';

import 'data/seed_books.dart';
import 'models/book.dart';
import 'models/profile.dart';
import 'screens/books_screen.dart';
import 'screens/favourites_screen.dart';
import 'screens/profile_screen.dart';
import 'routes/routes.dart';

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
    setState(() {
      _selectedIndex = index;
    });
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

  void _updateProfile(Profile profile) {
    setState(() {
      _profile = profile;
    });
  }

  void _openBook(Book book) {
    Navigator.pushNamed<void>(
      context,
      Routes.detail,
      arguments: BookDetailArguments(
        book: book,
        getCurrentBook: (id) => _books.firstWhere((item) => item.id == id),
        getProfileName: () => _profile.name.trim(),
        onBorrow: _borrowBook,
        onReturn: _returnBook,
        onDelete: _deleteBook,
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

  void _addBook() {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Add Book form coming next')));
  }

  Future<void> _showAbout() async {
    await showDialog<void>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('About Reading Club'),
          content: const Text(
            'Reading Club is a Flutter application '
            'for browsing books, borrowing copies, '
            'saving favourites and managing a profile.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _resetData() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('Reset data?'),
          content: const Text(
            'This will restore the original books '
            'and clear your profile.',
          ),
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
        );
      },
    );

    if (!mounted) return;

    if (confirmed == true) {
      setState(() {
        _books = createSeedBooks();
        _profile = const Profile.empty();
        _selectedIndex = 0;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Data restored successfully')),
      );
    }
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
          child: Column(
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
