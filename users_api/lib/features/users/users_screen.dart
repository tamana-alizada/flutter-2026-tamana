import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/api/api_exception.dart';
import 'users_model.dart';
import 'user_detail_screen.dart';
import 'new_user_screen.dart';

class UsersScreen extends StatelessWidget {
  const UsersScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final m = context.watch<UsersModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Users'), centerTitle: true, actions: [
        IconButton(
            icon: const Icon(Icons.person_add_alt_1),
            tooltip: 'Add user',
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => const NewUserScreen())))
      ]),
      body: _content(m),
    );
  }

  Widget _content(UsersModel m) {
    if (m.loading && m.items.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }
    final e = m.error;
    if (e != null && m.items.isEmpty) {
      return switch (e) {
        NoConnectionException() => _Problem(
            icon: Icons.wifi_off,
            title: 'You are offline',
            message: 'Check your connection.',
            retry: m.load),
        NotFoundException() || UnauthorizedException() => _Problem(
            icon: Icons.search_off,
            title: 'Resource unavailable',
            message: 'The resource could not be found or accessed.',
            retry: m.load),
        ServerException(:final status) => _Problem(
            icon: Icons.cloud_off,
            title: 'Server error ($status)',
            message: 'Try again later.',
            retry: m.load),
        BadResponseException() => const _Problem(
            icon: Icons.warning,
            title: 'Unexpected response',
            message: 'The server data could not be read.'),
      };
    }
    return RefreshIndicator(
      onRefresh: m.load,
      child: ListView.separated(
        physics: const AlwaysScrollableScrollPhysics(),
        itemCount: m.items.length,
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemBuilder: (context, i) {
          final u = m.items[i];
          return ListTile(
            leading: CircleAvatar(child: Text(u.name[0])),
            title: Text(u.name),
            subtitle: Text('${u.email}\n${u.address.city}'),
            isThreeLine: true,
            trailing: const Icon(Icons.chevron_right),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) => UserDetailScreen(user: u))),
          );
        },
      ),
    );
  }
}

class _Problem extends StatelessWidget {
  const _Problem(
      {required this.icon,
      required this.title,
      required this.message,
      this.retry});
  final IconData icon;
  final String title, message;
  final Future<void> Function()? retry;
  @override
  Widget build(BuildContext context) => Center(
          child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Icon(icon, size: 52),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.titleLarge),
          const SizedBox(height: 8),
          Text(message, textAlign: TextAlign.center),
          if (retry != null) ...[
            const SizedBox(height: 16),
            FilledButton.icon(
                onPressed: retry,
                icon: const Icon(Icons.refresh),
                label: const Text('Retry')),
          ],
        ]),
      ));
}
