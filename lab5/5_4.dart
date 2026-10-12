import 'package:flutter/material.dart';

void main() => runApp(const MaterialApp(home: HomeScreen()));

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: Center(
        child: ElevatedButton(
          onPressed: () => Navigator.push(
            context,
            PageRouteBuilder(
              transitionDuration: const Duration(milliseconds: 400),
              pageBuilder: (_, animation, secondaryAnimation) =>
                  const DetailsScreen(),
              transitionsBuilder: (_, animation, secondaryAnimation, child) {
                final scale = Tween<double>(
                  begin: 0.8,
                  end: 1.0,
                ).animate(animation);

                return FadeTransition(
                  opacity: animation,
                  child: ScaleTransition(
                    scale: scale,
                    child: child,
                  ),
                );
              },
            ),
          ),
          child: const Text('Open with scale and fade'),
        ),
      ),
    );
  }
}

class DetailsScreen extends StatelessWidget {
  const DetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Details')),
      body: const Center(child: Text('Grows and fades in')),
    );
  }
}