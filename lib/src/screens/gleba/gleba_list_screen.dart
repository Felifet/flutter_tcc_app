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
  List<Gleba> _filteredGlebas = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGlebas();
  }

  Future<void> _loadGlebas() async {
    final glebas = await DBHelper().getGlebas();
    setState(() {
      _glebas = glebas;
      _filteredGlebas = glebas;
    });
  }

  void _filterGlebas(String query) {
    final filtered = _glebas
        .where((gleba) =>
            gleba.nomeIdentificador.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredGlebas = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredGlebas = _glebas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Pesquisar gleba...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterGlebas,
              )
            : const Text('Glebas'),
        actions: [
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
      ),
      body: _filteredGlebas.isEmpty
          ? const Center(child: Text('Nenhuma Gleba encontrada.'))
          : ListView.separated(
              itemCount: _filteredGlebas.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final gleba = _filteredGlebas[index];
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
