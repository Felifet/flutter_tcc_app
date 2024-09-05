import '../models/product_model.dart';
import '../services/db_helper.dart';

class ProductService {
  final DBHelper _dbHelper = DBHelper();

  Future<int> addProduct(Product product) async {
    return await _dbHelper.insertProduct(product.toMap());
  }

  Future<List<Product>> getProducts() async {
    final List<Map<String, dynamic>> maps = await _dbHelper.getProducts();
    return List.generate(maps.length, (i) {
      return Product.fromMap(maps[i]);
    });
  }

  Future<int> updateProduct(Product product) async {
    return await _dbHelper.updateProduct(product.toMap());
  }

  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
  }
}
