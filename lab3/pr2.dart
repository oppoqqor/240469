import 'package:flutter/material.dart';

void main() => runApp(const App());

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool obscure = true;

  @override
  Widget build(BuildContext context) {
    
      final customTextStyle = TextStyle(
      fontFamily: 'YourFontName',
      color: Colors.blue,
      fontSize: 16.0,
    );
    
    return MaterialApp(
        
      home: Scaffold(
        appBar: AppBar(title: const Text('Login')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              
               Text('Dark Mode', style: customTextStyle), 
              Text('Notifications', style: customTextStyle.copyWith(fontSize: 20.0)),
              
              TextFormField(
                decoration: const InputDecoration(labelText: 'Username'),
              ),
              TextFormField(
                obscureText: obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  suffixIcon: IconButton(
                    icon: Icon(
                      obscure ? Icons.visibility : Icons.visibility_off,
                    ),
                    onPressed: () => setState(() => obscure = !obscure),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text('Login'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
