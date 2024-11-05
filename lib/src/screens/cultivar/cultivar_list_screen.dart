import 'package:flutter/material.dart';
import '../../models/cultivar_model.dart';
import '../../controllers/cultivar_controller.dart';
import 'cultivar_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';

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
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  elevation: 4,
                  child: ListTile(
                    title: Text(cultivar.nome),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            CultivarEditScreen(cultivar: cultivar),
                      ),
                    ).then((_) => _loadCultivares()),
                  ),
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
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 5, 94, 105),
        child: Container(
          height: 50, // Ajuste a altura da BottomAppBar
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
                  Navigator.pushReplacement(context,
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
