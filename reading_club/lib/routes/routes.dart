import 'package:flutter/material.dart';

import '../models/book.dart';
import '../screens/book_detail_screen.dart';
import '../screens/book_form_screen.dart';

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
  final Future<void> Function(Book) onEdit;
  final VoidCallback onProfileRequested;

  const BookDetailArguments({
    required this.book,
    required this.getCurrentBook,
    required this.getProfileName,
    required this.onBorrow,
    required this.onReturn,
    required this.onDelete,
    required this.onEdit,
    required this.onProfileRequested,
  });
}

class BookFormArguments {
  final Book? book;
  const BookFormArguments({this.book});
}

Route<dynamic>? generateRoute(RouteSettings settings) {
  switch (settings.name) {
    case Routes.detail:
      final args = settings.arguments;
      if (args is BookDetailArguments) {
        return MaterialPageRoute<void>(
          settings: settings,
          builder: (_) => BookDetailScreen(arguments: args),
        );
      }
      return null;
    case Routes.form:
      final args = settings.arguments;
      if (args is BookFormArguments) {
        return MaterialPageRoute<Book>(
          settings: settings,
          builder: (_) => BookFormScreen(book: args.book),
        );
      }
      return null;
    default:
      return null;
  }
}

Route<dynamic> notFoundRoute(RouteSettings settings) {
  return MaterialPageRoute<void>(
    settings: settings,
    builder: (_) => const Scaffold(body: Center(child: Text('Page not found'))),
  );
}
