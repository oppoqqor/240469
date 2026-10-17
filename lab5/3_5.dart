import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: CounterScreen()));

class CounterScreen extends StatefulWidget {
  const CounterScreen({super.key});

  @override
  State<CounterScreen> createState() => _CounterScreenState();
}

class _CounterScreenState extends State<CounterScreen> {
  int count = 0;

  Future<void> editCounter() async {
    final result = await Navigator.push<int>(
      context,
      MaterialPageRoute(
        builder: (_) => EditorScreen(initialValue: count),
      ),
    );

    if (!mounted) return;

    if (result != null) {
      setState(() => count = result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Counter')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$count', style: const TextStyle(fontSize: 32)),
            ElevatedButton(
              onPressed: editCounter,
              child: const Text('Edit'),
            ),
          ],
        ),
      ),
    );
  }
}

class EditorScreen extends StatefulWidget {
  final int initialValue;

  const EditorScreen({super.key, required this.initialValue});

  @override
  State<EditorScreen> createState() => _EditorScreenState();
}

class _EditorScreenState extends State<EditorScreen> {
  late int value;

  @override
  void initState() {
    super.initState();
    value = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editor')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('$value', style: const TextStyle(fontSize: 32)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(
                  onPressed: () => setState(() => value--),
                  icon: const Icon(Icons.remove),
                ),
                IconButton(
                  onPressed: () => setState(() => value++),
                  icon: const Icon(Icons.add),
                ),
              ],
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, value),
              child: const Text('Save'),
            ),
          ],
        ),
      ),
    );
  }
}