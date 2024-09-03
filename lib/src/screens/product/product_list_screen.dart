import 'package:flutter/material.dart';
import '../../services/db_helper.dart';
import 'product_edit_screen.dart'; // Importe a tela de edição

class ProductListScreen extends StatefulWidget {
  const ProductListScreen({super.key});

  @override
  _ProductListScreenState createState() => _ProductListScreenState();
}

class _ProductListScreenState extends State<ProductListScreen> {
  late Future<List<Map<String, dynamic>>> _productList;

  @override
  void initState() {
    super.initState();
    _productList = DBHelper().getProducts();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product List'),
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _productList,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return const Center(child: Text('Error loading products.'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No products found.'));
          } else {
            return ListView.builder(
              itemCount: snapshot.data!.length,
              itemBuilder: (context, index) {
                final product = snapshot.data![index];

                // Verifique se os campos obrigatórios estão presentes
                final nameComercial =
                    product['nameComercial'] ?? 'Nome Indisponível';
                final type = product['type'] ?? 'Tipo Indisponível';

                return ListTile(
                  title: Text(nameComercial),
                  subtitle: Text('Type: $type'),
                  trailing: IconButton(
                    icon: const Icon(Icons.edit),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              ProductEditScreen(product: product),
                        ),
                      ).then((_) {
                        // Atualiza a lista após voltar da tela de edição
                        setState(() {
                          _productList = DBHelper().getProducts();
                        });
                      });
                    },
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
