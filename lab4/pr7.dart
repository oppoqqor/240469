import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  List<int> items = List.generate(20, (i) => i + 1);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Items')),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, i) => Dismissible(
            key: Key('${items[i]}'),
            onDismissed: (_) => setState(() => items.removeAt(i)),
            child: ListTile(
              title: Text('Item ${items[i]}'),
            ),
          ),
        ),
      ),
    );
  }
}
