import 'package:flutter/material.dart';

void main() => runApp(
  const MaterialApp(home: Step1()),
);

class Step1 extends StatelessWidget {
  const Step1({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 1')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Step2()),
          ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class Step2 extends StatelessWidget {
  const Step2({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 2')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Step3()),
          ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class Step3 extends StatelessWidget {
  const Step3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 3')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => const Step4()),
          ),
          child: const Text('Next'),
        ),
      ),
    );
  }
}

class Step4 extends StatelessWidget {
  const Step4({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Step 4')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.popUntil(
            context,
            (route) => route.isFirst,
          ),
          child: const Text('Finish'),
        ),
      ),
    );
  }
}
