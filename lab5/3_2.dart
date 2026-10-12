import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(home: GreetingScreen()),
);

class GreetingScreen extends StatelessWidget {
  const GreetingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final nameController = TextEditingController();

    return Scaffold(
      appBar: AppBar(title: const Text('Greeting')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Your name'),
            ),
            ElevatedButton(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => HelloScreen(name: nameController.text),
                ),
              ),
              child: const Text('Greet'),
            ),
          ],
        ),
      ),
    );
  }
}

class HelloScreen extends StatelessWidget {
  final String name;

  const HelloScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hello')),
      body: Center(child: Text('Hello, $name!')),
    );
  }
}