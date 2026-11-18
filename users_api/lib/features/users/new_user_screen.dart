import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'user.dart';
import 'users_model.dart';

class NewUserScreen extends StatefulWidget {
  const NewUserScreen({super.key});
  @override
  State<NewUserScreen> createState() => _NewUserScreenState();
}

class _NewUserScreenState extends State<NewUserScreen> {
  final _key = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _username = TextEditingController();
  final _email = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    _username.dispose();
    _email.dispose();
    super.dispose();
  }

  String? _required(String? v) =>
      v == null || v.trim().isEmpty ? 'This field is required' : null;

  String? _validEmail(String? v) {
    final required = _required(v);
    if (required != null) return required;
    return RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(v!.trim())
        ? null
        : 'Enter a valid email';
  }

  Future<void> _save() async {
    if (!_key.currentState!.validate()) return;
    final model = context.read<UsersModel>();
    final draft = User(
      id: 0,
      name: _name.text.trim(),
      username: _username.text.trim(),
      email: _email.text.trim(),
      phone: '',
      website: null,
      address: const Address(
          street: '',
          suite: '',
          city: '',
          zipcode: '',
          geo: Geo(lat: 0, lng: 0)),
      company: (name: '', catchPhrase: ''),
    );
    final created = await model.create(draft);
    if (!mounted) return;
    if (created != null) {
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content:
                Text('Could not save user: ${model.error ?? 'Unknown error'}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final saving = context.watch<UsersModel>().saving;
    return Scaffold(
      appBar: AppBar(title: const Text('New user')),
      body: Form(
          key: _key,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                  controller: _name,
                  decoration: const InputDecoration(labelText: 'Name'),
                  validator: _required,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _username,
                  decoration: const InputDecoration(labelText: 'Username'),
                  validator: _required,
                  textInputAction: TextInputAction.next),
              const SizedBox(height: 12),
              TextFormField(
                  controller: _email,
                  decoration: const InputDecoration(labelText: 'Email'),
                  validator: _validEmail,
                  keyboardType: TextInputType.emailAddress),
              const SizedBox(height: 24),
              FilledButton(
                  onPressed: saving ? null : _save,
                  child: saving
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2))
                      : const Text('Save')),
            ],
          )),
    );
  }
}
