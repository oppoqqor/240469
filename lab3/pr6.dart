import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  double volume = 50;
  DateTime? date;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text('Volume & Date')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('${volume.round()}%'),
              Slider(
                value: volume,
                min: 0,
                max: 100,
                onChanged: (v) => setState(() => volume = v),
              ),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2100),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) setState(() => date = picked);
                },
                child: const Text('Select Date'),
              ),
              if (date != null)
                Text(
                  '${date!.day}/${date!.month}/${date!.year}',
                ),
            ],
          ),
        ),
      ),
    );
  }
}
