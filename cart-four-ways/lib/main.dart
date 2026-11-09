import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'bloc/cart_page_bloc.dart';
import 'cubit/cart_page_cubit.dart';
import 'riverpod/cart_page_riverpod.dart';
import 'setstate/cart_page_setstate.dart';

class _LogObserver extends BlocObserver {
  @override
  void onTransition(Bloc<dynamic, dynamic> bloc, Transition<dynamic, dynamic> transition) {
    super.onTransition(bloc, transition);
    debugPrint('${bloc.runtimeType}: ${transition.event.runtimeType}');
  }
}

void main() {
  Bloc.observer = _LogObserver();
  runApp(const ProviderScope(child: MaterialApp(home: HomePage())));
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('One Cart, Four Ways')),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              for (final (label, page) in [
                ('setState', const SetStateCartPage()),
                ('Riverpod', const RiverpodCartPage()),
                ('Cubit', const CubitCartPage()),
                ('Bloc', const BlocCartPage()),
              ])
                Padding(
                  padding: const EdgeInsets.all(6),
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.push(context, MaterialPageRoute(builder: (_) => page)),
                    child: Text(label),
                  ),
                ),
            ],
          ),
        ),
      );
}
