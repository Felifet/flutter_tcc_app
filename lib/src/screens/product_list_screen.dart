import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/product.dart';
import '../services/db_helper.dart';

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  List<Product> _products = [];

  @override
  void initState() {
    super.initState();
    _loadProducts();
  }

  void _loadProducts() async {
    final data = await DBHelper().getProducts();
    setState(() {
      _products = data.map((item) => Product.fromMap(item)).toList();
    });
  }

  void _deleteProduct(int id) async {
    await DBHelper().deleteProduct(id);
    _loadProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Product List')),
      body: ListView.builder(
        itemCount: _products.length,
        itemBuilder: (context, index) {
          final product = _products[index];
          return ListTile(
            title: Text(product.nomeComercial),
            subtitle: Text(product.principioAtivo),
            trailing: IconButton(
              icon: const Icon(Icons.delete),
              onPressed: () => _deleteProduct(product.id!),
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/add_product')
              .then((_) => _loadProducts());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
