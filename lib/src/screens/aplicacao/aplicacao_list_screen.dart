import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import 'package:flutter_tcc_app/src/screens/aplicacao/add_aplicacao_screen.dart';
import 'package:flutter_tcc_app/src/screens/aplicacao/aplicacao_edit_screen.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
import 'package:flutter_tcc_app/src/services/aplicacao_service.dart';

class AplicacaoListScreen extends StatefulWidget {
  const AplicacaoListScreen({Key? key}) : super(key: key);

  @override
  _AplicacaoListScreenState createState() => _AplicacaoListScreenState();
}

class _AplicacaoListScreenState extends State<AplicacaoListScreen> {
  late Future<List<Aplicacao>> _aplicacoes;
  List<Aplicacao> _filteredAplicacoes = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadAplicacoes();
  }

  void _loadAplicacoes() {
    setState(() {
      _aplicacoes = AplicacaoService().getAplicacoes();
    });

    _aplicacoes.then((aplicacoes) async {
      List<Aplicacao> aplicacoesComProdutoNome = [];

      for (var aplicacao in aplicacoes) {
        String nomeProduto = await AplicacaoService()
            .getProdutoNomeComercial(aplicacao.produtoId);
        aplicacao.produtoNomeComercial = nomeProduto;
        aplicacoesComProdutoNome.add(aplicacao);
      }

      setState(() {
        _filteredAplicacoes = aplicacoesComProdutoNome;
      });
    });
  }

  void _filterAplicacoes(String query) {
    final filtered = _filteredAplicacoes
        .where((aplicacao) =>
            aplicacao.motivo.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredAplicacoes = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _loadAplicacoes();
    });
  }

  void _navigateToAddAplicacao() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAplicacaoScreen()),
    ).then((_) {
      _loadAplicacoes();
    });
  }

  void _navigateToEditAplicacao(Aplicacao aplicacao) {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => EditAplicacaoScreen(aplicacao: aplicacao)),
    ).then((_) {
      _loadAplicacoes();
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
                  hintText: 'Pesquisar aplicação...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterAplicacoes,
              )
            : const Text('Lista de Aplicações'),
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
      body: FutureBuilder<List<Aplicacao>>(
        future: _aplicacoes,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar as aplicações.'));
          } else if (!snapshot.hasData || _filteredAplicacoes.isEmpty) {
            return const Center(child: Text('Nenhuma aplicação encontrada.'));
          }

          final aplicacoes = _filteredAplicacoes;

          return ListView.builder(
            itemCount: aplicacoes.length,
            itemBuilder: (context, index) {
              final aplicacao = aplicacoes[index];
              String formattedDate =
                  DateFormat('dd/MM/yyyy').format(aplicacao.datetime);

              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                child: ListTile(
                  title: Text('Aplicação na data: $formattedDate'),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Motivo: ${aplicacao.motivo}'),
                      Text('Produto: ${aplicacao.produtoNomeComercial}'),
                    ],
                  ),
                  onTap: () => _navigateToEditAplicacao(aplicacao),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _navigateToAddAplicacao,
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 5, 94, 105),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.list),
              color: Colors.white,
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MenuScreen()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.exit_to_app_sharp),
              color: Colors.white,
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
