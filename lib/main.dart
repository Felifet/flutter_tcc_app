import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/controllers/registro_manejo_controller.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart'; // Import do model de RegistroManejo
import 'package:flutter_tcc_app/src/screens/cultivar/cultivar_list_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/add_doenca_praga_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/doenca_praga_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/doencaPraga/doenca_praga_list_screen.dart';
import 'package:flutter_tcc_app/src/screens/estagioFenologico/add_estagioFenologico_screen.dart';
import 'package:flutter_tcc_app/src/screens/estagioFenologico/estagioFenologico_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/estagioFenologico/estagioFenologico_list_screen.dart';
import 'package:flutter_tcc_app/src/screens/manejo/manejo_add_screen.dart';
import 'package:flutter_tcc_app/src/screens/manejo/manejo_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/manejo/manejo_list_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_estagioFenologico/add_registro_fenologico_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_estagioFenologico/registro_fenologico_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_estagioFenologico/registro_fenologico_list_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_manejo/add_registro_manejo_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_manejo/registro_manejo_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_manejo/registro_manejo_list_screen.dart';
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
        '/': (context) => MenuScreen(),
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
        '/estagios_fenologicos': (context) =>
            const EstagioFenologicoListScreen(),
        '/add_estagio_fenologico': (context) =>
            const AddEstagioFenologicoScreen(),
        '/edit_estagio_fenologico': (context) {
          final estagioId = ModalRoute.of(context)?.settings.arguments as int?;
          return EstagioFenologicoEditScreen(estagioId: estagioId ?? 0);
        },
        '/manejos': (context) => const ManejoListScreen(),
        '/add_manejo': (context) => const AddManejoScreen(),
        '/edit_manejo': (context) {
          final manejo = ModalRoute.of(context)?.settings.arguments as Manejo?;
          return EditManejoScreen(
              manejo: manejo ?? Manejo(id: 0, nome: '', descricao: ''));
        },
        '/add_registro_manejo': (context) => const AddRegistroManejoScreen(),
        '/registro_manejo_list': (context) => const RegistroManejoListScreen(),
        '/add_registro_estagio': (context) => const AddRegistroEstagioScreen(),
        '/registro_estagio_list': (context) =>
            const RegistroEstagioListScreen(),
        '/edit_registro_estagio': (context) {
          final RegistroEstagioFenologico registroEstagio =
              ModalRoute.of(context)?.settings.arguments
                  as RegistroEstagioFenologico;
          return EditRegistroEstagioScreen(registroEstagio: registroEstagio);
        },
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/registro_manejo_edit') {
          final RegistroManejo registroManejo =
              settings.arguments as RegistroManejo;

          return MaterialPageRoute(
            builder: (context) {
              return RegistroManejoEditScreen(registroManejo: registroManejo);
            },
          );
        }
        return null;
      },
    );
  }
}
