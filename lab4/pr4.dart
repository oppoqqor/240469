import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool loading = false;

  void start() async {
    setState(() => loading = true);
    await Future.delayed(const Duration(seconds: 3));
    setState(() => loading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Completed'),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () {},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Loading')),
        body: Center(
          child: loading
              ? const CircularProgressIndicator()
              : ElevatedButton(
                  onPressed: start,
                  child: const Text('Start'),
                ),
        ),
      ),
    );
  }
}
