import 'package:flutter/material.dart';

enum BookGenre {
  fiction('Fiction', Icons.auto_stories),
  science('Science', Icons.science),
  history('History', Icons.history_edu),
  technology('Technology', Icons.computer),
  selfHelp('Self Help', Icons.psychology);

  const BookGenre(this.label, this.icon);

  final String label;
  final IconData icon;

  Color color(ColorScheme colorScheme) => switch (this) {
    BookGenre.fiction => colorScheme.primary,
    BookGenre.science => colorScheme.secondary,
    BookGenre.history => colorScheme.tertiary,
    BookGenre.technology => colorScheme.onPrimaryContainer,
    BookGenre.selfHelp => colorScheme.onSecondaryContainer,
  };
}
