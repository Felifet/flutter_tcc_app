import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/controllers/registro_manejo_controller.dart';
import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:intl/intl.dart';

class RegistroManejoListScreen extends StatefulWidget {
  const RegistroManejoListScreen({super.key});

  @override
  _RegistroManejoListScreenState createState() =>
      _RegistroManejoListScreenState();
}

class _RegistroManejoListScreenState extends State<RegistroManejoListScreen> {
  final RegistroManejoController _controller = RegistroManejoController();
  late Future<List<RegistroManejo>> _registrosManejoFuture;
  List<RegistroManejo> _filteredRegistrosManejo = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _refreshRegistroManejoList();
  }

  void _refreshRegistroManejoList() {
    setState(() {
      _registrosManejoFuture = _controller.getRegistrosManejo();
    });
    _registrosManejoFuture.then((registros) {
      setState(() {
        _filteredRegistrosManejo = registros;
      });
    });
  }

  void _filterRegistrosManejo(String query) {
    final filtered = _filteredRegistrosManejo
        .where((registro) =>
            registro.glebaId.toString().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredRegistrosManejo = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _refreshRegistroManejoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final DateFormat dateFormat = DateFormat('dd.MM.yyyy');
    return Scaffold(
      appBar: AppBar(
        title: _isSearching
            ? TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Pesquisar por ID da Gleba...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterRegistrosManejo,
              )
            : const Text('Registros de Manejo'),
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
      body: FutureBuilder<List<RegistroManejo>>(
        future: _registrosManejoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Erro: ${snapshot.error}'));
          } else if (!snapshot.hasData || _filteredRegistrosManejo.isEmpty) {
            return const Center(
                child: Text('Nenhum registro de manejo encontrado'));
          } else {
            return ListView.builder(
              itemCount: _filteredRegistrosManejo.length,
              itemBuilder: (context, index) {
                final registro = _filteredRegistrosManejo[index];
                return ListTile(
                  title: Text(
                      'Data Registro: ${dateFormat.format(registro.datetime.toLocal())}'),
                  subtitle: Text('Gleba ID: ${registro.glebaId}'),
                  onTap: () {
                    Navigator.pushNamed(
                      context,
                      '/registro_manejo_edit',
                      arguments: registro,
                    ).then((_) {
                      _refreshRegistroManejoList();
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
          Navigator.pushNamed(context, '/add_registro_manejo').then((_) {
            _refreshRegistroManejoList();
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
