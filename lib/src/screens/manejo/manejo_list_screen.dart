import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/screens/manejo/manejo_add_screen.dart';
import 'package:flutter_tcc_app/src/screens/manejo/manejo_edit_screen.dart';
import 'package:flutter_tcc_app/src/services/manejo_service.dart';

class ManejoListScreen extends StatefulWidget {
  const ManejoListScreen({super.key});

  @override
  _ManejoListScreenState createState() => _ManejoListScreenState();
}

class _ManejoListScreenState extends State<ManejoListScreen> {
  late Future<List<Manejo>> _manejoList;
  final ManejoService _manejoService = ManejoService();
  List<Manejo> _filteredManejoList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshManejoList();
  }

  void _refreshManejoList() {
    setState(() {
      _manejoList = _manejoService.getManejos();
    });
    _manejoList.then((manejos) {
      setState(() {
        _filteredManejoList = manejos;
      });
    });
  }

  void _filterManejos(String query) {
    final filtered = _filteredManejoList
        .where((manejo) =>
            manejo.nome.toLowerCase().contains(query.toLowerCase()) ||
            manejo.descricao.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredManejoList = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _refreshManejoList();
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
                  hintText: 'Pesquisar manejo...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterManejos,
              )
            : const Text('Cadastro de Manejos'),
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
      body: FutureBuilder<List<Manejo>>(
        future: _manejoList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(
                child: Text('Erro ao carregar o cadastro de manejos.'));
          } else if (!snapshot.hasData || _filteredManejoList.isEmpty) {
            return const Center(child: Text('Nenhum manejo encontrado.'));
          } else {
            return ListView.separated(
              itemCount: _filteredManejoList.length,
              separatorBuilder: (context, index) => const Divider(),
              itemBuilder: (context, index) {
                final manejo = _filteredManejoList[index];
                return ListTile(
                  title: Text(
                    manejo.nome,
                    style: const TextStyle(fontSize: 18.0),
                  ),
                  subtitle: Text(
                    manejo.descricao,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EditManejoScreen(
                          manejo: manejo,
                        ),
                      ),
                    ).then((_) {
                      _refreshManejoList();
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
              builder: (context) => const AddManejoScreen(),
            ),
          ).then((_) {
            _refreshManejoList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
