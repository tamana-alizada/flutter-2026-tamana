import 'package:flutter/material.dart';

import 'contact_card.dart';
import 'contacts.dart';

class ContactList extends StatelessWidget {
  const ContactList({super.key});
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      children: [
        const Text('20 contacts'),
        Expanded(
          child: ListView.separated(
            itemCount: contacts.length,
            itemBuilder: (context, index) {
              return ContactCard(contact: contacts[index]);
            },
            separatorBuilder: (context, index) => const Divider(),
          ),
        ),
      ],
    ),
  );
}
