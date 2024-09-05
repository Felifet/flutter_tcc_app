import 'package:flutter/material.dart';
import '../../models/gleba_model.dart';
import '../../services/db_helper.dart';
import 'gleba_edit_screen.dart';

class GlebaListScreen extends StatefulWidget {
  const GlebaListScreen({super.key});

  @override
  _GlebaListScreenState createState() => _GlebaListScreenState();
}

class _GlebaListScreenState extends State<GlebaListScreen> {
  List<Gleba> _glebas = [];

  @override
  void initState() {
    super.initState();
    _loadGlebas();
  }

  Future<void> _loadGlebas() async {
    final glebas = await DBHelper().getGlebas();
    setState(() {
      _glebas = glebas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Glebas'),
      ),
      body: _glebas.isEmpty
          ? const Center(child: Text('Nenhuma Gleba encontrada.'))
          : ListView.separated(
              itemCount: _glebas.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final gleba = _glebas[index];
                return ListTile(
                  title: Text(
                    gleba.nomeIdentificador,
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Área: ${gleba.area} ha',
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => GlebaEditScreen(gleba: gleba),
                      ),
                    ).then((_) => _loadGlebas());
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_gleba').then((_) => _loadGlebas());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
