import 'package:flutter/material.dart';

import '../models/book.dart';
import '../utils/format.dart';

class BookCard extends StatelessWidget {
  final Book book;
  final VoidCallback onTap;
  final VoidCallback onFavourite;

  const BookCard({
    super.key,
    required this.book,
    required this.onTap,
    required this.onFavourite,
  });

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (:taken, :free) = book.places;

    return Card(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: book.genre.color(scheme),
                    child: Icon(book.genre.icon, color: scheme.surface),
                  ),
                  if (book.isFull || free <= 5)
                    Positioned(
                      bottom: -8,
                      right: -12,
                      child: Container(
                        padding: const EdgeInsets.all(4),
                        decoration: BoxDecoration(
                          color: scheme.errorContainer,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          book.isFull ? 'FULL' : '$free left',
                          style: TextStyle(color: scheme.onErrorContainer),
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      book.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    Text(book.genre.label),
                    Text(formatDate(book.meetingDate)),
                    Text(
                      book.place,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text('$taken borrowed'),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'Toggle favourite',
                onPressed: onFavourite,
                icon: Icon(
                  book.isFavourite ? Icons.favorite : Icons.favorite_border,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
