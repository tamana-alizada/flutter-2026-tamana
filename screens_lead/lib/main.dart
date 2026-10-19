import 'package:flutter/material.dart';

import 'detail_screen.dart';
import 'edit_screen.dart';
import 'routes.dart';
import 'students.dart';
import 'students_screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.indigo),
    ),
    initialRoute: Routes.students,
    routes: {Routes.students: (_) => const StudentsScreen()},
    onGenerateRoute: (settings) {
      final student = settings.arguments as Student;

      switch (settings.name) {
        case Routes.student:
          return MaterialPageRoute(
            builder: (_) => DetailScreen(student: student),
          );

        case Routes.edit:
          return MaterialPageRoute<String>(
            builder: (_) => EditScreen(student: student),
          );

        default:
          return null;
      }
    },
  );
}
