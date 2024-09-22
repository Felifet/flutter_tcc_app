import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/screens/registro_estagioFenologico/registro_fenologico_edit_screen.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';

class RegistroEstagioListScreen extends StatefulWidget {
  const RegistroEstagioListScreen({Key? key}) : super(key: key);

  @override
  _RegistroEstagioListScreenState createState() =>
      _RegistroEstagioListScreenState();
}

class _RegistroEstagioListScreenState extends State<RegistroEstagioListScreen> {
  List<RegistroEstagioFenologico> _registros = [];

  @override
  void initState() {
    super.initState();
    _loadRegistros();
  }

  Future<void> _loadRegistros() async {
    _registros = await DBHelper().getRegistrosEstagioFenologico();
    setState(() {});
  }

  void _navigateToEdit(RegistroEstagioFenologico registro) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            EditRegistroEstagioScreen(registroEstagio: registro),
      ),
    ).then((_) => _loadRegistros());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Lista de Registros de Estágio Fenológico')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _registros.isEmpty
            ? const Center(child: Text('Nenhum registro encontrado'))
            : ListView.builder(
                itemCount: _registros.length,
                itemBuilder: (context, index) {
                  final registro = _registros[index];
                  return Card(
                    child: ListTile(
                      title: Text('Data: ${registro.datetime}'),
                      subtitle: Text(
                          'Ciclo ID: ${registro.cicloId}, Gleba ID: ${registro.glebaId}, Estágio ID: ${registro.estagioFenologicoId}'),
                      onTap: () => _navigateToEdit(registro),
                    ),
                  );
                },
              ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_registro_estagio');
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
