import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
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
  List<DoencaPraga> _filteredDoencasPragas = [];
  final TextEditingController _searchController = TextEditingController();
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _loadDoencasPragas();
  }

  Future<void> _loadDoencasPragas() async {
    final doencasPragas = await DBHelper().getDoencasPragas();
    setState(() {
      _doencasPragas = doencasPragas;
      _filteredDoencasPragas = doencasPragas;
    });
  }

  void _filterDoencasPragas(String query) {
    final filtered = _doencasPragas
        .where((doencaPraga) => doencaPraga.descricaoCurta
            .toLowerCase()
            .contains(query.toLowerCase()))
        .toList();

    setState(() {
      _filteredDoencasPragas = filtered;
    });
  }

  void _toggleSearch() {
    setState(() {
      _isSearching = !_isSearching;
      _searchController.clear();
      _filteredDoencasPragas = _doencasPragas;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                decoration: const InputDecoration(
                  hintText: 'Pesquisar...',
                  border: InputBorder.none,
                ),
                style: const TextStyle(color: Colors.white),
                onChanged: _filterDoencasPragas,
              )
            : const Text('Doenças/Pragas'),
        actions: [
          IconButton(
            icon: Icon(_isSearching ? Icons.close : Icons.search),
            onPressed: _toggleSearch,
          ),
        ],
      ),
      body: _filteredDoencasPragas.isEmpty
          ? const Center(child: Text('Nenhuma Doença/Praga encontrada.'))
          : GridView.builder(
              padding: const EdgeInsets.all(16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 1,
                childAspectRatio: 3,
                crossAxisSpacing: 8.0,
                mainAxisSpacing: 8.0,
              ),
              itemCount: _filteredDoencasPragas.length,
              itemBuilder: (context, index) {
                final doencaPraga = _filteredDoencasPragas[index];
                return Card(
                  elevation: 4,
                  child: InkWell(
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
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            doencaPraga.descricaoCurta,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            doencaPraga.descricaoLonga ?? '',
                            style: const TextStyle(fontSize: 18),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
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
          Navigator.pushNamed(context, '/add_doenca_praga')
              .then((_) => _loadDoencasPragas());
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
