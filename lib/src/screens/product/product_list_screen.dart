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

  @override
  void initState() {
    super.initState();
    _refreshProductList();
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

  void _filterProducts(String query) {
    final filtered = _filteredProductList
        .where((product) =>
            product.nomeComercial.toLowerCase().contains(query.toLowerCase()))
        .toList();
    setState(() {
      _filteredProductList = filtered;
    });
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      _isSearching = false;
      _refreshProductList();
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
                  hintText: 'Pesquisar produto...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: _clearSearch,
                  ),
                ),
                onChanged: _filterProducts,
              )
            : const Text('Consulta de Produtos'),
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
      body: FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os produtos.'));
          } else if (!snapshot.hasData || _filteredProductList.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado!'));
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
                    style: const TextStyle(fontSize: 20), // Aumenta a fonte
                  ),
                  subtitle: Text(
                    'Tipo do Produto: ${product.tipo}',
                    style: const TextStyle(fontSize: 18), // Aumenta a fonte
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
