import 'dart:async';

import 'package:flutter/material.dart';

import 'api/fake_api.dart';
import 'widgets/empty_view.dart';
import 'widgets/error_view.dart';
import 'widgets/loading_view.dart';
import 'widgets/student_list.dart';

class StudentsScreen extends StatefulWidget {
  const StudentsScreen({super.key});

  @override
  State<StudentsScreen> createState() => _StudentsScreenState();
}

class _StudentsScreenState extends State<StudentsScreen> {
  List<Student>? _students;
  Object? _error;
  // Shared across visits so the fake server's request counters keep their values.
  static final _api = FakeApi();
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    setState(() {
      _students = null;
      _error = null;
    });

    try {
      final list = await _api.fetchStudents();

      if (!mounted) return;

      setState(() {
        _students = list;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e;
      });
    }
  }

  Future<void> _saveStudents() async {
    final count = _students!.length;

    setState(() {
      _saving = true;
    });

    try {
      await _api.save(count);

      if (!context.mounted) return;

      Navigator.pop(context);
    } on StateError catch (e) {
      if (!context.mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.message.toString())),
      );

      setState(() {
        _saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    Widget body;

    if (_error != null) {
      body = ErrorView(onRetry: () {
        unawaited(_load());
      });
    } else if (_students == null) {
      body = const LoadingView();
    } else if (_students!.isEmpty) {
      body = const EmptyView();
    } else {
      body = StudentList(students: _students!);
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Students – By hand')),
      body: body,
      floatingActionButton: _students != null && _error == null
          ? FloatingActionButton.extended(
              onPressed: _saving ? null : _saveStudents,
              icon: _saving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_saving ? 'Saving…' : 'Save'),
            )
          : null,
    );
  }
}
