import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool dark = false;
  bool terms = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Settings')),
        body: Column(
          children: [
            SwitchListTile(
              title: const Text('Dark Mode'),
              value: dark,
              onChanged: (v) => setState(() => dark = v),
            ),
            CheckboxListTile(
              title: const Text('Agree to Terms'),
              value: terms,
              onChanged: (v) => setState(() => terms = v ?? false),
            ),
          ],
        ),
      ),
    );
  }
}
