import '../models/product_model.dart';
import '../services/db_helper.dart';

class ProductService {
  final DBHelper _dbHelper = DBHelper();

  // Adiciona um produto de forma normal
  Future<int> addProduct(Product product) async {
    return await _dbHelper.insertProduct(product.toMap());
  }

  // Adiciona um produto ao banco de dados através da importação
  Future<int> addProductImport(Product product) async {
    return await _dbHelper.insert('products', product.toMap());
  }

  // Recupera todos os produtos cadastrados
  Future<List<Product>> getProducts() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getProducts();
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  // Atualiza um produto existente
  Future<int> updateProduct(Product product) async {
    return await _dbHelper.updateProduct(product.toMap());
  }

  // Deleta um produto pelo ID
  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
  }
}
