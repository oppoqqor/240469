import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Tabs'),
            bottom: const TabBar(
              tabs: [
                Tab(text: 'Home'),
                Tab(text: 'Search'),
                Tab(text: 'Profile'),
              ],
            ),
          ),
          body: const TabBarView(
            children: [
              Center(child: Text('Home')),
              Center(child: Text('Search')),
              Center(child: Text('Profile')),
            ],
          ),
        ),
      ),
    );
  }
}