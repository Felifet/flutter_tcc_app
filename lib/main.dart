import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/cultivar/cultivar_list_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/add_doenca_praga_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/doenca_praga_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/doenca_praga_list_screen.dart';
import 'src/screens/menu_screen.dart';
import 'src/screens/product/product_list_screen.dart';
import 'src/screens/product/add_product_screen.dart';
import 'src/screens/product/product_edit_screen.dart';
import 'src/screens/gleba/gleba_list_screen.dart';
import 'src/screens/gleba/gleba_edit_screen.dart';
import 'src/screens/ciclo/ciclo_list_screen.dart';
import 'src/screens/ciclo/add_ciclo_screen.dart';
import 'src/screens/ciclo/ciclo_edit_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC App',
      theme: ThemeData.dark(),
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/products': (context) => const ProductListScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/edit_product': (context) => const ProductEditScreen(),
        '/glebas': (context) => const GlebaListScreen(),
        '/add_gleba': (context) => const GlebaEditScreen(),
        '/edit_gleba': (context) => const GlebaEditScreen(),
        '/ciclos': (context) => const CicloListScreen(),
        '/add_ciclo': (context) => const AddCicloScreen(),
        '/edit_ciclo': (context) => const CicloEditScreen(),
        '/doencas_pragas': (context) => const DoencaPragaListScreen(),
        '/add_doenca_praga': (context) => const AddDoencaPragaScreen(),
        '/edit_doenca_praga': (context) => const DoencaPragaEditScreen(),
        '/cultivares': (context) => CultivarListScreen(),
      },
    );
  }
}
