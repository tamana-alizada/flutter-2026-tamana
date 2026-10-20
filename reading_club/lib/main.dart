import 'package:flutter/material.dart';

import 'app_shell.dart';
import 'routes/routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  ThemeMode _themeMode = ThemeMode.system;

  void _changeTheme(ThemeMode mode) {
    setState(() {
      _themeMode = mode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Reading Club',
      debugShowCheckedModeBanner: false,

      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF317B72)),
      ),

      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF317B72),
          brightness: Brightness.dark,
        ),
      ),
      onGenerateRoute: generateRoute,
      onUnknownRoute: (_) => MaterialPageRoute<void>(
        builder: (_) => const Scaffold(body: Center(child: Text('Not found'))),
      ),

      themeMode: _themeMode,

      home: AppShell(themeMode: _themeMode, onThemeChanged: _changeTheme),
    );
  }
}
