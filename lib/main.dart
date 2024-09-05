import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/add_doenca_praga_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/doenca_praga_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/doenca_praga_list_screen.dart';
import 'src/screens/menu_screen.dart';
import 'src/screens/product/product_list_screen.dart';
import 'src/screens/product/add_product_screen.dart';
import 'src/screens/product/product_edit_screen.dart'; // Adicionado para edição de produtos
import 'src/screens/gleba/gleba_list_screen.dart';
import 'src/screens/gleba/gleba_edit_screen.dart';
import 'src/screens/ciclo/ciclo_list_screen.dart'; // Adicionado para ciclos
import 'src/screens/ciclo/add_ciclo_screen.dart'; // Adicionado para adicionar ciclos
import 'src/screens/ciclo/ciclo_edit_screen.dart'; // Adicionado para editar ciclos

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TCC App',
      theme: ThemeData.dark(), // Define o tema do aplicativo para escuro
      initialRoute: '/',
      routes: {
        '/': (context) => const MenuScreen(),
        '/products': (context) => const ProductListScreen(),
        '/add_product': (context) => const AddProductScreen(),
        '/edit_product': (context) =>
            ProductEditScreen(), // Adicionado para edição de produtos
        '/glebas': (context) => const GlebaListScreen(),
        '/add_gleba': (context) => const GlebaEditScreen(),
        '/edit_gleba': (context) =>
            GlebaEditScreen(), // Adicionado para edição de glebas
        '/ciclos': (context) =>
            const CicloListScreen(), // Adicionado para a lista de ciclos
        '/add_ciclo': (context) =>
            const AddCicloScreen(), // Adicionado para adicionar ciclos
        '/edit_ciclo': (context) =>
            const CicloEditScreen(), // Adicionado para edição de ciclos
        '/doencas_pragas': (context) =>
            const DoencaPragaListScreen(), // Adicionado para lista de doenças/pragas
        '/add_doenca_praga': (context) =>
            AddDoencaPragaScreen(), // Adicionado para adicionar doenças/pragas
        '/edit_doenca_praga': (context) =>
            const DoencaPragaEditScreen(), // Adicionado para edição de doenças/pragas
      },
    );
  }
}
