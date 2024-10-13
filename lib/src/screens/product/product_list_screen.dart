import 'package:flutter/material.dart';
import '../../models/product_model.dart';
import '../../controllers/product_controller.dart';
import 'add_product_screen.dart';
import 'product_edit_screen.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Product>> _productList;
  final ProductController _controller = ProductController();
  List<Product> _filteredProductList = [];
  bool _isSearching = false;
  final TextEditingController _searchController = TextEditingController();

  List<String> _tipos = []; // Lista para armazenar os tipos
  String? _selectedTipo; // Tipo selecionado no filtro

  @override
  void initState() {
    super.initState();
    _refreshProductList();
    _getProductTypes(); // Obter tipos de produtos ao inicializar
  }

  void _refreshProductList() {
    setState(() {
      _productList = _controller.getAllProducts();
    });
    _productList.then((products) {
      setState(() {
        _filteredProductList = products;
      });
    });
  }

  void _getProductTypes() async {
    List<Product> products = await _controller.getAllProducts();
    Set<String> tiposSet = products.map((product) => product.tipo).toSet();
    setState(() {
      _tipos =
          ['Ambos'] + tiposSet.toList(); // Adiciona "Ambos" como primeira opção
    });
  }

  void _filterProducts(String query) {
    final filtered = _filteredProductList.where((product) {
      final matchesNome =
          product.nomeComercial.toLowerCase().contains(query.toLowerCase());
      final matchesTipo = _selectedTipo ==
              'Ambos' || // Se "Ambos" estiver selecionado, não filtra por tipo
          (_selectedTipo != null && product.tipo == _selectedTipo);
      return matchesNome && matchesTipo; // Filtra pelo nome e tipo
    }).toList();
    setState(() {
      _filteredProductList = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _selectedTipo = 'Ambos'; // Reseta o tipo para "Ambos"
      _refreshProductList(); // Atualiza a lista com todos os produtos
    });
  }

  void _onTipoSelected(String? tipo) {
    setState(() {
      _selectedTipo = tipo; // Atualiza o tipo selecionado
      _searchController.clear(); // Limpa a busca
      _isSearching = false; // Fecha a barra de busca
    });
    // Atualiza a lista de produtos filtrando apenas pelo tipo selecionado
    _filterProducts(''); // Aplica o filtro sem buscar por nome
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Produtos'),
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
      body: Column(
        children: [
          // Dropdown para selecionar o tipo
          DropdownButton<String>(
            hint: const Text('Selecione um tipo de produto'),
            value: _selectedTipo,
            onChanged: _onTipoSelected,
            items: _tipos.map((tipo) {
              return DropdownMenuItem(
                value: tipo,
                child: Text(tipo),
              );
            }).toList(),
          ),
          // Campo de busca
          if (_isSearching)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Pesquisar produto...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: (query) {
                  _filterProducts(
                      query); // Aplica o filtro sempre que o texto mudar
                },
              ),
            ),
          Expanded(
            child: FutureBuilder<List<Product>>(
              future: _productList,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Erro ao carregar os produtos.'));
                } else if (!snapshot.hasData || _filteredProductList.isEmpty) {
                  return const Center(
                      child: Text('Nenhum produto encontrado!'));
                } else {
                  return ListView.separated(
                    itemCount: _filteredProductList.length,
                    separatorBuilder: (context, index) => const Divider(
                      height: 1.0,
                      color: Colors.grey,
                    ),
                    itemBuilder: (context, index) {
                      final product = _filteredProductList[index];

                      return ListTile(
                        title: Text(
                          product.nomeComercial,
                          style:
                              const TextStyle(fontSize: 20), // Aumenta a fonte
                        ),
                        subtitle: Text(
                          'Tipo: ${product.tipo}',
                          style:
                              const TextStyle(fontSize: 18), // Aumenta a fonte
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  ProductEditScreen(product: product),
                            ),
                          ).then((_) => _refreshProductList());
                        },
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const AddProductScreen(),
            ),
          ).then((_) => _refreshProductList());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
