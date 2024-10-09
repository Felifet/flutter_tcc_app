import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/estagiofenologico_service.dart';
import 'add_estagiofenologico_screen.dart';
import 'estagiofenologico_edit_screen.dart';

class EstagioFenologicoListScreen extends StatefulWidget {
  const EstagioFenologicoListScreen({super.key});

  @override
  _EstagioFenologicoListScreenState createState() =>
      _EstagioFenologicoListScreenState();
}

class _EstagioFenologicoListScreenState
    extends State<EstagioFenologicoListScreen> {
  late Future<List<EstagioFenologico>> _estagioFenologicoList;
  final EstagioFenologicoService _estagioFenologicoService =
      EstagioFenologicoService();
  List<EstagioFenologico> _filteredEstagioList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshEstagioFenologicoList();
  }

  void _refreshEstagioFenologicoList() {
    setState(() {
      _estagioFenologicoList =
          _estagioFenologicoService.getAllEstagiosFenologicos();
    });
    _estagioFenologicoList.then((estagios) {
      setState(() {
        _filteredEstagioList = estagios;
      });
    });
  }

  void _filterEstagios(String query) {
    final filtered = _filteredEstagioList
        .where((estagio) =>
            estagio.descricao.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredEstagioList = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _refreshEstagioFenologicoList();
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
                  hintText: 'Pesquisar estágio fenológico...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterEstagios,
              )
            : const Text('Estágios Fenológicos'),
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
      body: FutureBuilder<List<EstagioFenologico>>(
        future: _estagioFenologicoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar os estágios fenológicos.'));
          } else if (!snapshot.hasData || _filteredEstagioList.isEmpty) {
            return const Center(
                child: Text('Nenhum estágio fenológico encontrado.'));
          } else {
            return ListView.separated(
              itemCount: _filteredEstagioList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final estagio = _filteredEstagioList[index];
                return ListTile(
                  title: Text(
                    estagio.descricao,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            EstagioFenologicoEditScreen(estagioId: estagio.id!),
                      ),
                    ).then((_) {
                      _refreshEstagioFenologicoList();
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
              builder: (context) => const AddEstagioFenologicoScreen(),
            ),
          ).then((_) {
            _refreshEstagioFenologicoList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
