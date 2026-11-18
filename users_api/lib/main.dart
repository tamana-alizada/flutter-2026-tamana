import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'core/api/api_client.dart';
import 'features/users/user_repository.dart';
import 'features/users/users_model.dart';
import 'features/users/users_screen.dart';

void main() {
  final model = UsersModel(UserRepository(ApiClient.createDefault()))..load();
  runApp(ChangeNotifierProvider.value(value: model, child: const UsersApp()));
}

class UsersApp extends StatelessWidget {
  const UsersApp({super.key});
  @override
  Widget build(BuildContext context) => MaterialApp(
        title: 'Users API',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
            useMaterial3: true),
        home: const UsersScreen(),
      );
}
