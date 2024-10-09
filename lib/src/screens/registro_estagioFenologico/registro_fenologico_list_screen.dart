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
  final TextEditingController _searchController = TextEditingController();
  List<RegistroEstagioFenologico> _filteredRegistros = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadRegistros();
  }

  Future<void> _loadRegistros() async {
    _registros = await DBHelper().getRegistrosEstagioFenologico();
    setState(() {
      _filteredRegistros = _registros; // Initialize with all registros
    });
  }

  void _filterRegistros(String query) {
    final filtered = _registros.where((registro) {
      final dateString = registro.datetime.toString(); // Convert to string
      return dateString.toLowerCase().contains(query.toLowerCase()) ||
          registro.cicloId.toString().contains(query) ||
          registro.glebaId.toString().contains(query) ||
          registro.estagioFenologicoId.toString().contains(query);
    }).toList();

    setState(() {
      _filteredRegistros = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredRegistros = _registros; // Reset to all registros
    });
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
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: _isSearching
                  ? TextField(
                      controller: _searchController,
                      autofocus: true,
                      decoration: InputDecoration(
                        hintText: 'Pesquisar registros...',
                        suffixIcon: IconButton(
                          icon: const Icon(Icons.clear),
                          onPressed: _clearSearch,
                        ),
                      ),
                      onChanged: _filterRegistros,
                    )
                  : const Text(
                      'Registros de Estágio Fenológico',
                      style: TextStyle(fontSize: 18.0),
                    ),
            ),
            if (!_isSearching) ...[
              IconButton(
                icon: const Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    _isSearching = !_isSearching;
                    if (!_isSearching) {
                      _clearSearch();
                    }
                  });
                },
              ),
            ],
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: _filteredRegistros.isEmpty
            ? const Center(child: Text('Nenhum registro encontrado'))
            : ListView.builder(
                itemCount: _filteredRegistros.length,
                itemBuilder: (context, index) {
                  final registro = _filteredRegistros[index];
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
