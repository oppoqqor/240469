import 'package:flutter/material.dart';

void main() {
  runApp(MaterialApp(
    initialRoute: '/',
    routes: {
      '/': (context) => const HomeScreen(),
    },
    onUnknownRoute: (settings) => MaterialPageRoute(
      builder: (context) => const NotFoundScreen(),
    ),
  ));
}

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.pushNamed(
            context,
            '/eaughiaeuhgiUEAHGIUAHEGIUHAEGIUAHEIGUHA',
          ),
          child: const Text('Open unknown page'),
        ),
      ),
    );
  }
}

class NotFoundScreen extends StatelessWidget {
  const NotFoundScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('404')),
      body: const Center(
        child: Text('Page not found'),
      ),
    );
  }
}