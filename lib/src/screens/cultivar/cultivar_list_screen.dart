import 'package:flutter/material.dart';
import '../../models/cultivar_model.dart';
import '../../controllers/cultivar_controller.dart';
import 'cultivar_edit_screen.dart';

class CultivarListScreen extends StatefulWidget {
  @override
  _CultivarListScreenState createState() => _CultivarListScreenState();
}

class _CultivarListScreenState extends State<CultivarListScreen> {
  final CultivarController _cultivarController = CultivarController();
  List<Cultivar> _cultivares = [];

  @override
  void initState() {
    super.initState();
    _loadCultivares();
  }

  void _loadCultivares() async {
    final cultivares = await _cultivarController.getCultivares();
    setState(() {
      _cultivares = cultivares;
    });
  }

  void _deleteCultivar(int id) async {
    await _cultivarController.deleteCultivar(id);
    _loadCultivares(); // Recarrega a lista após exclusão
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Cultivares')),
      body: _cultivares.isEmpty
          ? Center(child: Text('Nenhuma cultivar cadastrada.'))
          : ListView.builder(
              itemCount: _cultivares.length,
              itemBuilder: (context, index) {
                final cultivar = _cultivares[index];
                return ListTile(
                  title: Text(cultivar.nome),
                  trailing: IconButton(
                    icon: Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _showDeleteConfirmationDialog(cultivar.id!),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CultivarEditScreen(cultivar: cultivar),
                    ),
                  ).then((_) =>
                      _loadCultivares()), // Recarrega a lista após edição
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CultivarEditScreen()),
        ).then(
            (_) => _loadCultivares()), // Recarrega a lista após nova inserção
        child: Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Excluir Cultivar'),
          content: Text('Tem certeza de que deseja excluir esta cultivar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteCultivar(id);
                Navigator.pop(context);
              },
              child: Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
