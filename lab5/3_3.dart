import 'package:flutter/material.dart';

class Contact {
  final String name;
  final String phone;
  final String email;

  const Contact(this.name, this.phone, this.email);
}

const contacts = [
  Contact('Alice Smith', '111-111', 'alice@example.com'),
  Contact('Bob Jones', '222-222', 'bob@example.com'),
  Contact('Carol White', '333-333', 'carol@example.com'),
  Contact('David Brown', '444-444', 'david@example.com'),
  Contact('Emma Green', '555-555', 'emma@example.com'),
];

void main() => runApp(
  const MaterialApp(home: ContactListScreen()),
);

class ContactListScreen extends StatelessWidget {
  const ContactListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contacts')),
      body: ListView(
        children: [
          for (final contact in contacts)
            ListTile(
              leading: const Icon(Icons.person),
              title: Text(contact.name),
              subtitle: Text(contact.phone),
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => ContactScreen(contact: contact),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class ContactScreen extends StatelessWidget {
  final Contact contact;

  const ContactScreen({super.key, required this.contact});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(contact.name)),
      body: Card(
        margin: const EdgeInsets.all(20),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(contact.name, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 12),
              Text('Phone: ${contact.phone}'),
              Text('Email: ${contact.email}'),
            ],
          ),
        ),
      ),
    );
  }
}