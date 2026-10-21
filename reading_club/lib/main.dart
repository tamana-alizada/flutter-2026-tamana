import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'routes/routes.dart';

void main() => runApp(const MyApp());

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() => _themeMode = mode);
  }

  @override
  Widget build(BuildContext context) {
    final lightScheme = ColorScheme.fromSeed(seedColor: Colors.green);
    final darkScheme = ColorScheme.fromSeed(
      seedColor: Colors.green,
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'Reading Club',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(useMaterial3: true, colorScheme: lightScheme),
      darkTheme: ThemeData(useMaterial3: true, colorScheme: darkScheme),
      themeMode: _themeMode,
      routes: {
        Routes.home: (_) =>
            AppShell(themeMode: _themeMode, onThemeChanged: _changeTheme),
      },
      onGenerateRoute: generateRoute,
      onUnknownRoute: notFoundRoute,
    );
  }
}
