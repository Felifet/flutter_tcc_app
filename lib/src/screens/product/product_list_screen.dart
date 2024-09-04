import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/screens/product/add_product_screen.dart';
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
                    product['nomeComercial'] ?? 'Nome Indisponível';
                final type = product['tipo'] ?? 'Tipo Indisponível';

                return ListTile(
                  title: Text(nameComercial),
                  subtitle: Text('Type: $type'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
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
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          // Confirmação antes de excluir
                          final confirmDelete = await showDialog<bool>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: const Text('Confirmar Exclusão'),
                              content: const Text(
                                  'Você tem certeza que deseja excluir este produto?'),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(false);
                                  },
                                  child: const Text('Cancelar'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                  },
                                  child: const Text('Excluir'),
                                ),
                              ],
                            ),
                          );

                          if (confirmDelete == true) {
                            // Excluir o produto do banco de dados
                            await DBHelper().deleteProduct(product['id']);

                            // Atualiza a lista após excluir
                            setState(() {
                              _productList = DBHelper().getProducts();
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Produto excluído com sucesso.'),
                              ),
                            );
                          }
                        },
                      ),
                    ],
                  ),
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
              builder: (context) =>
                  const AddProductScreen(), // Chame a tela de adição
            ),
          ).then((_) {
            // Atualiza a lista após voltar da tela de adição
            setState(() {
              _productList = DBHelper().getProducts();
            });
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
