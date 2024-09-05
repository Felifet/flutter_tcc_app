import 'package:flutter/material.dart';
import '../../models/doenca_praga_model.dart';
import '../../services/db_helper.dart';
import 'doenca_praga_edit_screen.dart';

class DoencaPragaListScreen extends StatefulWidget {
  const DoencaPragaListScreen({super.key});

  @override
  _DoencaPragaListScreenState createState() => _DoencaPragaListScreenState();
}

class _DoencaPragaListScreenState extends State<DoencaPragaListScreen> {
  List<DoencaPraga> _doencasPragas = [];

  @override
  void initState() {
    super.initState();
    _loadDoencasPragas();
  }

  Future<void> _loadDoencasPragas() async {
    final doencasPragas = await DBHelper().getDoencasPragas();
    setState(() {
      _doencasPragas = doencasPragas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Doenças/Pragas'),
      ),
      body: _doencasPragas.isEmpty
          ? const Center(child: Text('Nenhuma Doença/Praga encontrada.'))
          : ListView.separated(
              itemCount: _doencasPragas.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final doencaPraga = _doencasPragas[index];
                return ListTile(
                  contentPadding: const EdgeInsets.all(16.0),
                  title: Text(
                    doencaPraga.descricaoCurta,
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  subtitle: Text(
                    doencaPraga.descricaoLonga ?? '',
                    style: const TextStyle(
                      fontSize: 18.0,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DoencaPragaEditScreen(
                          doencaPraga: doencaPraga,
                        ),
                      ),
                    ).then((_) => _loadDoencasPragas());
                  },
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_doenca_praga')
              .then((_) => _loadDoencasPragas());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
