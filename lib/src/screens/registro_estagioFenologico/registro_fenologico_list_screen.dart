import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/screens/registro_estagioFenologico/registro_fenologico_edit_screen.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';
import 'package:intl/intl.dart';

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

  // Atualizando o método para carregar os registros
  Future<void> _loadRegistros() async {
    _registros = await DBHelper().getRegistrosEstagioFenologico();
    setState(() {
      _filteredRegistros = _registros; // Inicializando com todos os registros
    });
  }

  // Método para filtrar os registros
  void _filterRegistros(String query) {
    final filtered = _registros.where((registro) {
      final dateString =
          registro.datetime.toString(); // Convertendo para string
      return dateString.toLowerCase().contains(query.toLowerCase()) ||
          registro.cicloId.toString().contains(query) ||
          registro.glebaId.toString().contains(query) ||
          registro.estagioFenologicoId.toString().contains(query);
    }).toList();

    setState(() {
      _filteredRegistros = filtered;
    });
  }

  // Método para limpar a pesquisa
  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _filteredRegistros = _registros; // Resetando para todos os registros
    });
  }

  // Navegar para a tela de edição do registro
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
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        'Data do Registro: ${DateFormat('dd/MM/yyyy - HH:mm').format(registro.datetime)}', // Formato da data
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FutureBuilder<String>(
                            future: DBHelper().getCicloNameById(registro
                                    .cicloId ??
                                -1), // Substitua por um valor padrão se for null
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasData) {
                                return Text(
                                  'Ciclo: ${snapshot.data}',
                                  style: const TextStyle(fontSize: 14),
                                );
                              }
                              return const Text('Ciclo: Não encontrado');
                            },
                          ),
                          FutureBuilder<String>(
                            future: DBHelper().getGlebaNameById(
                                registro.glebaId ??
                                    -1), // Substitua por um valor padrão se
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasData) {
                                return Text(
                                  'Gleba: ${snapshot.data}',
                                  style: const TextStyle(fontSize: 14),
                                );
                              }
                              return const Text('Gleba: Não encontrada');
                            },
                          ),
                          FutureBuilder<String>(
                            future: DBHelper().getEstagioFenologicoNameById(
                                registro.estagioFenologicoId ?? -1),
                            builder: (context, snapshot) {
                              if (snapshot.connectionState ==
                                  ConnectionState.waiting) {
                                return const CircularProgressIndicator();
                              }
                              if (snapshot.hasData) {
                                return Text(
                                  'Estágio: ${snapshot.data}',
                                  style: const TextStyle(fontSize: 14),
                                );
                              }
                              return const Text('Estágio: Não encontrado');
                            },
                          ),
                        ],
                      ),
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
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => MenuScreen()),
                  );
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
