import 'package:flutter/material.dart';
import 'user.dart';

class UserDetailScreen extends StatelessWidget {
  const UserDetailScreen({super.key, required this.user});
  final User user;
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(user.name)),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          _section('Personal information', [
            _line('ID', '${user.id}'),
            _line('Name', user.name),
            _line('Username', user.username),
            _line('Email', user.email),
            _line('Phone', user.phoneDigits),
            _line('Website', user.website ?? 'Not provided'),
          ]),
          _section('Address', [
            _line('Street', user.address.street),
            _line('Suite', user.address.suite),
            _line('City', user.address.city),
            _line('ZIP code', user.address.zipcode),
            _line('Latitude', '${user.address.geo.lat}'),
            _line('Longitude', '${user.address.geo.lng}'),
          ]),
          _section('Company', [
            _line('Name', user.company.name),
            _line('Catch phrase', user.company.catchPhrase),
          ]),
        ]),
      );

  Widget _section(String title, List<Widget> children) => Card(
        margin: const EdgeInsets.only(bottom: 16),
        child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                ...children,
              ],
            )),
      );
  Widget _line(String label, String value) => Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
          SizedBox(
              width: 112,
              child: Text(label,
                  style: const TextStyle(fontWeight: FontWeight.w600))),
          Expanded(child: Text(value)),
        ]),
      );
}
