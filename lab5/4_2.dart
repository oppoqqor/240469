import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (context) => const HomeScreen(),
    '/square': (context) => const SquareScreen(),
  },
));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            for (final n in [1, 2, 3])
              ElevatedButton(
                onPressed: () => Navigator.pushNamed(
                  context,
                  '/square',
                  arguments: n,
                ),
                child: Text('$n'),
              ),
          ],
        ),
      ),
    );
  }
}

class SquareScreen extends StatelessWidget {
  const SquareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final n = ModalRoute.of(context)!.settings.arguments as int;

    return Scaffold(
      appBar: AppBar(title: const Text('Square')),
      body: Center(
        child: Text('$n squared = ${n * n}',
            style: const TextStyle(fontSize: 24)),
      ),
    );
  }
}