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
  List<Ciclo> _filteredCicloList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshCicloList();
  }

  void _refreshCicloList() {
    setState(() {
      _cicloList = _cicloService.getCiclos();
    });
    _cicloList.then((ciclos) {
      setState(() {
        _filteredCicloList = ciclos;
      });
    });
  }

  void _filterCiclos(String query) {
    final filtered = _filteredCicloList
        .where((ciclo) =>
            ciclo.descricao.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredCicloList = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _refreshCicloList();
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
                  hintText: 'Pesquisar ciclo...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterCiclos,
              )
            : const Text('Cadastro de Ciclos'),
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
      body: FutureBuilder<List<Ciclo>>(
        future: _cicloList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar o cadastro de Ciclos.'));
          } else if (!snapshot.hasData || _filteredCicloList.isEmpty) {
            return const Center(child: Text('Nenhum ciclo encontrado.'));
          } else {
            return ListView.separated(
              itemCount: _filteredCicloList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final ciclo = _filteredCicloList[index];
                return ListTile(
                  title: Text(
                    ciclo.descricao,
                    style: const TextStyle(fontSize: 18.0),
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
