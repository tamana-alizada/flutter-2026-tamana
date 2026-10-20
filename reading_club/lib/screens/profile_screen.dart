import 'package:flutter/material.dart';

import '../models/book.dart';
import '../models/profile.dart';

class ProfileScreen extends StatefulWidget {
  final Profile profile;
  final List<Book> books;
  final ValueChanged<Profile> onProfileChanged;
  final ThemeMode themeMode;
  final ValueChanged<ThemeMode> onThemeChanged;

  const ProfileScreen({
    super.key,
    required this.profile,
    required this.books,
    required this.onProfileChanged,
    required this.themeMode,
    required this.onThemeChanged,
  });

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _groupController;

  @override
  void initState() {
    super.initState();

    _nameController = TextEditingController(text: widget.profile.name);

    _groupController = TextEditingController(text: widget.profile.group);
  }

  @override
  void didUpdateWidget(covariant ProfileScreen oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.profile.name != widget.profile.name) {
      _nameController.text = widget.profile.name;
    }

    if (oldWidget.profile.group != widget.profile.group) {
      _groupController.text = widget.profile.group;
    }
  }

  void _saveName(String value) {
    widget.onProfileChanged(widget.profile.copyWith(name: value.trim()));
  }

  void _saveGroup(String value) {
    final group = value.trim();

    final validGroup = RegExp(r'^[A-Za-z0-9-]{2,20}$').hasMatch(group);

    if (!validGroup && group.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Group must be 2–20 letters, numbers or hyphens.'),
        ),
      );
      return;
    }

    widget.onProfileChanged(widget.profile.copyWith(group: group));
  }

  @override
  void dispose() {
    _nameController.dispose();
    _groupController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.profile.name.trim();

    final joinedCount = name.isEmpty
        ? 0
        : widget.books.where((book) => book.contains(name)).length;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Icon(
          Icons.account_circle,
          size: 72,
          color: Theme.of(context).colorScheme.primary,
        ),
        const SizedBox(height: 16),

        TextField(
          controller: _nameController,
          decoration: const InputDecoration(
            labelText: 'Your name',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _saveName,
        ),

        const SizedBox(height: 16),

        TextField(
          controller: _groupController,
          decoration: const InputDecoration(
            labelText: 'Your group',
            hintText: 'SE-01',
            border: OutlineInputBorder(),
          ),
          textInputAction: TextInputAction.done,
          onSubmitted: _saveGroup,
        ),

        const SizedBox(height: 20),

        Card(
          child: ListTile(
            leading: const Icon(Icons.menu_book),
            title: Text('You are on $joinedCount lists'),
            subtitle: const Text('Books you have borrowed'),
          ),
        ),

        const SizedBox(height: 24),

        Text('Appearance', style: Theme.of(context).textTheme.titleMedium),

        const SizedBox(height: 12),

        Wrap(
          spacing: 8,
          children: [
            ChoiceChip(
              label: const Text('System'),
              selected: widget.themeMode == ThemeMode.system,
              onSelected: (_) => widget.onThemeChanged(ThemeMode.system),
            ),
            ChoiceChip(
              label: const Text('Light'),
              selected: widget.themeMode == ThemeMode.light,
              onSelected: (_) => widget.onThemeChanged(ThemeMode.light),
            ),
            ChoiceChip(
              label: const Text('Dark'),
              selected: widget.themeMode == ThemeMode.dark,
              onSelected: (_) => widget.onThemeChanged(ThemeMode.dark),
            ),
          ],
        ),
      ],
    );
  }
}
