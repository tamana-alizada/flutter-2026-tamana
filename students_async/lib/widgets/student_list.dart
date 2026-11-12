import 'package:flutter/material.dart';

import '../api/fake_api.dart';

class StudentList extends StatelessWidget {
  const StudentList({
    super.key,
    required this.students,
    this.compact = false,
  });

  final List<Student> students;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: students.length,
      itemBuilder: (context, index) {
        final student = students[index];

        return ListTile(
          dense: compact,
          leading: CircleAvatar(
            child: Text(student.name.substring(0, 1)),
          ),
          title: Text(student.name),
          subtitle: Text('Group: ${student.group}'),
          trailing: Text(
            student.gpa == null ? '—' : student.gpa!.toStringAsFixed(1),
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        );
      },
    );
  }
}
