import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
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
    final glebasData = await DBHelper().getGlebasWithCultivar();
    setState(() {
      _glebas = glebasData;
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
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 2,
                crossAxisSpacing: 16.0,
                mainAxisSpacing: 16.0,
              ),
              itemCount: _filteredGlebas.length,
              itemBuilder: (context, index) {
                final gleba = _filteredGlebas[index];
                return Card(
                  elevation: 4,
                  child: InkWell(
                    onTap: () {
                      final glebaModel = Gleba.fromMap(gleba);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              GlebaEditScreen(gleba: glebaModel),
                        ),
                      ).then((_) => _loadGlebas());
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            gleba['nomeIdentificador'],
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Área: ${gleba['area']} Hectare(s)',
                            style: const TextStyle(fontSize: 18),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            'Cultivar: ${gleba['cultivarNome'] ?? 'N/A'}',
                            style: const TextStyle(fontSize: 18),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_gleba').then((_) => _loadGlebas());
        },
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 5, 94, 105),
        child: Container(
          height: 20, // Ajuste a altura da BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.list),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenuScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app_sharp),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
