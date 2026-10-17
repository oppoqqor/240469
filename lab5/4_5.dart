import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
  initialRoute: '/',
  routes: {
    '/': (_) => const HomeScreen(),
    '/rate': (_) => const RateScreen(),
  },
));

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String result = 'No rating selected';

  Future<void> rateMovie() async {
    final rating = await Navigator.pushNamed<int>(
      context,
      '/rate',
      arguments: 'Inception',
    );

    if (!mounted) return;

    setState(() {
      result = rating == null
          ? 'No rating selected'
          : 'Movie: $rating/5';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Movie rating')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(result),
            ElevatedButton(
              onPressed: rateMovie,
              child: const Text('Rate movie'),
            ),
          ],
        ),
      ),
    );
  }
}

class RateScreen extends StatelessWidget {
  const RateScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final movie = ModalRoute.of(context)!.settings.arguments as String;

    return Scaffold(
      appBar: AppBar(title: Text('Rate $movie')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (int rating = 1; rating <= 5; rating++)
              IconButton(
                icon: const Icon(Icons.star),
                onPressed: () => Navigator.pop(context, rating),
              ),
          ],
        ),
      ),
    );
  }
}