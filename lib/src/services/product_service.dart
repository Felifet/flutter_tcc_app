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

  Future<List<String>> getDistinctProductTypes() async {
    final List<Map<String, dynamic>> result = await _dbHelper.query(
      'products',
      columns: ['DISTINCT tipo'],
    );
    return result.map((map) => map['tipo'] as String).toList();
  }

  Future<List<Product>> getProductsByType(String tipo) async {
    final List<Map<String, dynamic>> result = await _dbHelper.query(
      'products',
      where: 'tipo = ?',
      whereArgs: [tipo],
    );
    return result.map((map) => Product.fromMap(map)).toList();
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
