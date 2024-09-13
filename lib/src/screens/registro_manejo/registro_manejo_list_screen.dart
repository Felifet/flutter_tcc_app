import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/controllers/registro_manejo_controller.dart';
import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:intl/intl.dart'; // Adicione esta importação

class RegistroManejoListScreen extends StatefulWidget {
  const RegistroManejoListScreen({super.key});

  @override
  _RegistroManejoListScreenState createState() =>
      _RegistroManejoListScreenState();
}

class _RegistroManejoListScreenState extends State<RegistroManejoListScreen> {
  final RegistroManejoController _controller = RegistroManejoController();
  late Future<List<RegistroManejo>> _registrosManejoFuture;

  @override
  void initState() {
    super.initState();
    _refreshRegistroManejoList();
  }

  void _refreshRegistroManejoList() {
    setState(() {
      _registrosManejoFuture = _controller.getRegistrosManejo();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registros de Manejo'),
      ),
      body: FutureBuilder<List<RegistroManejo>>(
        future: _registrosManejoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
                child: Text('Nenhum registro de manejo encontrado'));
          } else {
            final registros = snapshot.data!;
            return ListView.builder(
              itemCount: registros.length,
              itemBuilder: (context, index) {
                final registro = registros[index];
                return ListTile(
                  title: Text(
                      'Data Registro: ${dateFormat.format(registro.datetime.toLocal())}'),
                  subtitle: Text('Gleba ID: ${registro.glebaId}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/registro_manejo_edit',
                      arguments: registro,
                    ).then((_) {
                      _refreshRegistroManejoList();
                    });
                  },
                );
              },
            );
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_registro_manejo').then((_) {
            _refreshRegistroManejoList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
