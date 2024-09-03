import 'package:flutter/material.dart';
import 'src/screens/menu_screen.dart';
import 'src/screens/product/product_list_screen.dart';
import 'src/screens/product/add_product_screen.dart';
import 'src/screens/gleba/gleba_list_screen.dart';
import 'src/screens/gleba/gleba_edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/products': (context) => const ProductListScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/glebas': (context) => const GlebaListScreen(),
        '/add_gleba': (context) => const GlebaEditScreen(),
      },
    );
  }
}
