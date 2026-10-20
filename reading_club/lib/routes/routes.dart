import 'package:flutter/material.dart';

import '../models/book.dart';
import '../screens/book_detail_screen.dart';

class Routes {
  static const String home = '/';
  static const String detail = '/detail';
  static const String form = '/form';
}

class BookDetailArguments {
  final Book book;
  final Book Function(String id) getCurrentBook;
  final String Function() getProfileName;
  final ValueChanged<Book> onBorrow;
  final ValueChanged<Book> onReturn;
  final ValueChanged<Book> onDelete;
  final VoidCallback onProfileRequested;

  const BookDetailArguments({
    required this.book,
    required this.getCurrentBook,
    required this.getProfileName,
    required this.onBorrow,
    required this.onReturn,
    required this.onDelete,
    required this.onProfileRequested,
  });
}

Route<dynamic> generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.detail:
      final arguments = settings.arguments;

      if (arguments is BookDetailArguments) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BookDetailScreen(arguments: arguments),
        );
      }

      return _notFoundRoute();

    default:
      return _notFoundRoute();
  }
}

Route<dynamic> _notFoundRoute() {
  return MaterialPageRoute<void>(
    builder: (_) => const Scaffold(body: Center(child: Text('Not found'))),
  );
}
