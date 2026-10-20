import 'dart:async';

import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/countdown.dart';
import '../routes/routes.dart';
import '../utils/format.dart';

class BookDetailScreen extends StatefulWidget {
  final BookDetailArguments arguments;

  const BookDetailScreen({super.key, required this.arguments});

  @override
  State<BookDetailScreen> createState() => _BookDetailScreenState();
}

class _BookDetailScreenState extends State<BookDetailScreen> {
  late Book _book;
  late Timer _timer;
  DateTime _now = DateTime.now();

  @override
  void initState() {
    super.initState();

    _book = widget.arguments.book;

    _timer = Timer.periodic(const Duration(minutes: 1), (_) {
      setState(() {
        _now = DateTime.now();
      });
    });
  }

  void _refreshBook() {
    setState(() {
      _book = widget.arguments.getCurrentBook(_book.id);
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  Future<void> _confirmBorrow() async {
    final name = widget.arguments.getProfileName();

    if (name.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Enter your name in Profile first.'),
          action: SnackBarAction(
            label: 'Profile',
            onPressed: () {
              Navigator.pop(context);
              widget.arguments.onProfileRequested();
            },
          ),
        ),
      );
      return;
    }

    final currentBook = widget.arguments.getCurrentBook(_book.id);

    if (currentBook.isFull || currentBook.contains(name)) {
      _refreshBook();
      return;
    }

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Borrow book?'),
        content: Text('Do you want to borrow ${_book.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Borrow'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      final latest = widget.arguments.getCurrentBook(_book.id);

      if (!latest.isFull && !latest.contains(name)) {
        widget.arguments.onBorrow(latest);
      }

      _refreshBook();
    }
  }

  Future<void> _confirmReturn() async {
    final name = widget.arguments.getProfileName();

    if (name.isEmpty) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Return book?'),
        content: Text('Do you want to return ${_book.title}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Return'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      final latest = widget.arguments.getCurrentBook(_book.id);

      if (latest.contains(name)) {
        widget.arguments.onReturn(latest);
      }

      _refreshBook();
    }
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Delete book?'),
        content: Text('Delete ${_book.title} from the club?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (!mounted) return;

    if (confirmed == true) {
      widget.arguments.onDelete(_book);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final (:taken, :free) = _book.places;
    final profileName = widget.arguments.getProfileName();

    final hasBorrowed = profileName.isNotEmpty && _book.contains(profileName);

    final countdown = getCountdown(_book.meetingDate, now: _now);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Book Details'),
          actions: [
            PopupMenuButton<String>(
              onSelected: (value) {
                if (value == 'edit') {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Edit form coming in Step 8')),
                  );
                } else if (value == 'delete') {
                  _confirmDelete();
                }
              },
              itemBuilder: (_) => const [
                PopupMenuItem(value: 'edit', child: Text('Edit')),
                PopupMenuItem(value: 'delete', child: Text('Delete')),
              ],
            ),
          ],
        ),
        body: Column(
          children: [
            Stack(
              children: [
                SizedBox(
                  height: 180,
                  width: double.infinity,
                  child: Image.asset(
                    'assets/images/library.png',
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 12,
                  left: 12,
                  child: Chip(
                    avatar: Icon(_book.genre.icon),
                    label: Text(_book.genre.label),
                  ),
                ),
                Positioned(
                  bottom: 12,
                  right: 12,
                  child: Chip(label: Text(countdownLabel(countdown))),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _book.title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$taken borrowed • $free available',
                    style: TextStyle(color: scheme.primary),
                  ),
                ],
              ),
            ),
            TabBar(
              tabs: [
                const Tab(text: 'About'),
                Tab(text: 'Borrowers ($taken)'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  ListView(
                    padding: const EdgeInsets.all(16),
                    children: [
                      ListTile(
                        leading: const Icon(Icons.calendar_today),
                        title: Text(formatDate(_book.meetingDate)),
                      ),
                      ListTile(
                        leading: Icon(
                          _book.isOnline ? Icons.language : Icons.location_on,
                        ),
                        title: Text(_book.place),
                      ),
                      if (_book.description != null)
                        Text(_book.description ?? ''),
                    ],
                  ),
                  _book.borrowers.isEmpty
                      ? const Center(child: Text('No borrowers yet'))
                      : ListView.builder(
                          itemCount: _book.borrowers.length,

                          itemBuilder: (context, index) {
                            final name = _book.borrowers[index];

                            final profileName = widget.arguments
                                .getProfileName();

                            final isYou =
                                profileName.isNotEmpty && name == profileName;

                            return ListTile(
                              leading: Icon(
                                isYou ? Icons.person_pin : Icons.person,
                              ),
                              title: Text(
                                isYou ? '$name (You)' : name,
                                style: TextStyle(
                                  fontWeight: isYou
                                      ? FontWeight.bold
                                      : FontWeight.normal,
                                ),
                              ),
                            );
                          },
                        ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: hasBorrowed
                      ? _confirmReturn
                      : _book.isFull
                      ? null
                      : _confirmBorrow,
                  child: Text(
                    hasBorrowed
                        ? 'Return book'
                        : _book.isFull
                        ? 'No copies available'
                        : 'Borrow book',
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
