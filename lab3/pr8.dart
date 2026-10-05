import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  final images = const [
    'https://picsum.photos/400/400?1',
    'https://picsum.photos/400/400?2',
    'https://picsum.photos/400/400?3',
    'https://picsum.photos/400/400?4',
    'https://picsum.photos/400/400?5',
    'https://picsum.photos/400/400?6',
  ];

  void preview(BuildContext context, String image) {
    showDialog(
      context: context,
      builder: (_) => Dialog(
        child: Image.network(image),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Gallery')),
        body: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          padding: const EdgeInsets.all(8),
          children: images.map(
            (image) => InkWell(
              onTap: () => preview(context, image),
              child: Image.network(
                image,
                fit: BoxFit.cover,
              ),
            ),
          ).toList(),
        ),
      ),
    );
  }
}
