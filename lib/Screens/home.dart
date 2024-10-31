import 'package:faker/faker.dart';
import 'package:flutter/material.dart';

import '../data/contact.dart';

class Home extends StatefulWidget {
  Home({Key? key}) : super(key: key);

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final faker = Faker();
  late List<Contact> _contacts;

  @override
  void initState() {
    super.initState();
    _contacts = List.generate(
      4, // Limit generated contacts to 4
      (index) => Contact(
        name: '${faker.person.firstName()} ${faker.person.lastName()}',
        email: faker.internet.email(),
        phoneNumber:
            '9${faker.randomGenerator.integer(1000000000, min: 100000000).toString()}',
        isFavorite: false,
      ),
    );
    _sortContactsAlphabetically();
  }

  // Sort contacts alphabetically by name
  void _sortContactsAlphabetically() {
    setState(() {
      _contacts.sort((a, b) => a.name.compareTo(b.name));
    });
  }

  // Show the contact card form to add a new contact
  void _showAddContactDialog() {
    String name = '';
    String email = '';
    String phoneNumber = '';

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Add New Contact'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Name'),
                onChanged: (value) {
                  name = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Email'),
                onChanged: (value) {
                  email = value;
                },
              ),
              TextField(
                decoration: const InputDecoration(labelText: 'Phone Number'),
                keyboardType: TextInputType.phone,
                onChanged: (value) {
                  phoneNumber = value;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                _addNewContact(name, email, phoneNumber);
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }

  // Add a new contact
  void _addNewContact(String name, String email, String phoneNumber) {
    setState(() {
      final newContact = Contact(
        name: name.isNotEmpty
            ? name
            : '${faker.person.firstName()} ${faker.person.lastName()}',
        email: email.isNotEmpty ? email : faker.internet.email(),
        phoneNumber: phoneNumber.isNotEmpty
            ? phoneNumber
            : '9${faker.randomGenerator.integer(1000000000, min: 100000000).toString()}',
      );
      _contacts.add(newContact);
      _sortContactsAlphabetically(); // Re-sort after adding new contact
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Contacts'),
        backgroundColor: Colors.grey[900],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddContactDialog, // Open the add contact form
        child: const Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: _contacts.length,
        itemBuilder: (context, index) {
          final contact = _contacts[index];
          return ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.blueAccent,
              child: Text(
                contact.name[0], // Display first letter of the contact's name
                style: const TextStyle(color: Colors.white),
              ),
            ),
            title: Text(
              contact.name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
            subtitle: Text(contact.email),
            trailing: IconButton(
              icon: Icon(
                contact.isFavorite ? Icons.star : Icons.star_border,
                color: contact.isFavorite ? Colors.yellow : Colors.grey,
              ),
              onPressed: () {
                setState(() {
                  contact.isFavorite = !contact.isFavorite;
                  _sortContactsAlphabetically(); // Sort after marking favorite
                });
              },
            ),
          );
        },
      ),
    );
  }
}
