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

  @override
  void initState() {
    super.initState();
    _productList = _controller.getAllProducts();
  }

  Future<void> _reloadProducts() async {
    setState(() {
      _productList = _controller.getAllProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de Produtos'),
      ),
      body: FutureBuilder<List<Product>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Erro ao carregar os produtos.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('Nenhum produto encontrado!'));
          } else {
            return ListView.separated(
              itemCount: snapshot.data!.length,
              separatorBuilder: (context, index) => const Divider(
                height: 1.0,
                color: Colors.grey,
              ),
              itemBuilder: (context, index) {
                final product = snapshot.data![index];

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
                    ).then((_) =>
                        _reloadProducts()); // Atualiza a lista após voltar
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
          ).then((_) =>
              _reloadProducts()); // Atualiza a lista após adicionar um novo produto
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
