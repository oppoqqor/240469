import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'cubit/products_cubit.dart';
import 'data/product_api.dart';
import 'screens/products_screen.dart';

void main() => runApp(const ApiCatalogApp());

class ApiCatalogApp extends StatelessWidget {
  const ApiCatalogApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RepositoryProvider(
      create: (_) => ProductApi(),
      child: MaterialApp(
        title: 'API Catalog',
        debugShowCheckedModeBanner: false,
        home: BlocProvider(
          create: (c) => ProductsCubit(c.read<ProductApi>())..load(),
          child: const ProductsScreen(),
        ),
      ),
    );
  }
}
