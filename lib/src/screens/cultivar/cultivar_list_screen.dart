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
  List<Cultivar> _filteredCultivares = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadCultivares();
  }

  void _loadCultivares() async {
    final cultivares = await _cultivarController.getCultivares();
    setState(() {
      _cultivares = cultivares;
      _filteredCultivares = cultivares;
    });
  }

  void _deleteCultivar(int id) async {
    await _cultivarController.deleteCultivar(id);
    _loadCultivares(); // Recarrega a lista após exclusão
  }

  void _filterCultivares(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredCultivares = _cultivares;
      } else {
        _filteredCultivares = _cultivares
            .where((cultivar) =>
                cultivar.nome.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                  border: InputBorder.none,
                ),
                onChanged: _filterCultivares,
              )
            : const Text('Cultivares'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: () {
              setState(() {
                _isSearching = !_isSearching;
                if (!_isSearching) {
                  _filteredCultivares = _cultivares;
                }
              });
            },
          ),
        ],
      ),
      body: _filteredCultivares.isEmpty
          ? const Center(child: Text('Nenhuma cultivar cadastrada.'))
          : ListView.builder(
              itemCount: _filteredCultivares.length,
              itemBuilder: (context, index) {
                final cultivar = _filteredCultivares[index];
                return ListTile(
                  title: Text(cultivar.nome),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () =>
                        _showDeleteConfirmationDialog(cultivar.id!),
                  ),
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CultivarEditScreen(cultivar: cultivar),
                    ),
                  ).then((_) => _loadCultivares()),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CultivarEditScreen()),
        ).then((_) => _loadCultivares()),
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showDeleteConfirmationDialog(int id) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Excluir Cultivar'),
          content:
              const Text('Tem certeza de que deseja excluir esta cultivar?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () {
                _deleteCultivar(id);
                Navigator.pop(context);
              },
              child: const Text('Excluir'),
            ),
          ],
        );
      },
    );
  }
}
