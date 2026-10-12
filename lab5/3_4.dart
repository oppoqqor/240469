import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(home: ColorScreen()),
);

class ColorScreen extends StatefulWidget {
  const ColorScreen({super.key});

  @override
  State<ColorScreen> createState() => _ColorScreenState();
}

class _ColorScreenState extends State<ColorScreen> {
  Color color = Colors.blue;

  Future<void> chooseColor() async {
    final selectedColor = await Navigator.push<Color>(
      context,
      MaterialPageRoute(builder: (_) => const ChooseColorScreen()),
    );

    if (selectedColor != null) {
      setState(() => color = selectedColor);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pick a colour')),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(width: 150, height: 150, color: color),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: chooseColor,
              child: const Text('Choose colour'),
            ),
          ],
        ),
      ),
    );
  }
}

class ChooseColorScreen extends StatelessWidget {
  const ChooseColorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Choose a colour')),
      body: Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            for (final color in [Colors.red, Colors.green, Colors.blue])
              Padding(
                padding: const EdgeInsets.all(8),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: color,
                    minimumSize: const Size(70, 50),
                  ),
                  onPressed: () => Navigator.pop(context, color),
                  child: const SizedBox(width: 20, height: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}