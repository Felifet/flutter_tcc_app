import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import '../../services/ciclo_service.dart';
import 'ciclo_edit_screen.dart';
import 'add_ciclo_screen.dart';

class CicloListScreen extends StatefulWidget {
  const CicloListScreen({super.key});

  @override
  _CicloListScreenState createState() => _CicloListScreenState();
}

class _CicloListScreenState extends State<CicloListScreen> {
  late Future<List<Ciclo>> _cicloList;
  final CicloService _cicloService = CicloService();

  @override
  void initState() {
    super.initState();
    _refreshCicloList();
  }

  void _refreshCicloList() {
    setState(() {
      _cicloList = _cicloService.getCiclos();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cadastro de Ciclos'),
      ),
      body: FutureBuilder<List<Ciclo>>(
        future: _cicloList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar o cadastro de Ciclos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum ciclo encontrado.'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final ciclo = snapshot.data![index];
                return ListTile(
                  title: Text(
                    ciclo.descricao,
                    style:
                        TextStyle(fontSize: 18.0), // Aumenta o tamanho da fonte
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CicloEditScreen(ciclo: ciclo),
                      ),
                    ).then((_) {
                      _refreshCicloList();
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
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddCicloScreen(),
            ),
          ).then((_) {
            _refreshCicloList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
