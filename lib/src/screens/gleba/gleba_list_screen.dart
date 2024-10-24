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
  List<Map<String, dynamic>> _glebas = [];
  List<Map<String, dynamic>> _filteredGlebas = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadGlebas();
  }

  Future<void> _loadGlebas() async {
    final glebasData =
        await DBHelper().getGlebasWithCultivar(); // Método que realiza o JOIN
    setState(() {
      _glebas = glebasData; // Recebe os dados com o cultivar
      _filteredGlebas = _glebas;
    });
  }

  void _filterGlebas(String query) {
    final filtered = _glebas.where((gleba) {
      final nomeIdentificador =
          gleba['nomeIdentificador'].toString().toLowerCase();
      return nomeIdentificador.contains(query.toLowerCase());
    }).toList();

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
                    gleba['nomeIdentificador'], // Nome da gleba
                    style: const TextStyle(fontSize: 20),
                  ),
                  subtitle: Text(
                    'Área: ${gleba['area']} ha\nCultivar: ${gleba['cultivarNome'] ?? 'N/A'}', // Exibe o nome do cultivar
                    style: const TextStyle(fontSize: 18),
                  ),
                  onTap: () {
                    final glebaModel =
                        Gleba.fromMap(gleba); // Converte o mapa para o modelo
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            GlebaEditScreen(gleba: glebaModel),
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
