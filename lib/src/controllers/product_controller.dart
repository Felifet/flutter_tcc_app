import '../models/product_model.dart';
import '../services/db_helper.dart';

class ProductController {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Product>> getAllProducts() async {
    final List<Map<String, dynamic>> productMaps =
        await _dbHelper.getProducts();
    return List.generate(productMaps.length, (i) {
      return Product.fromMap(productMaps[i]);
    });
  }

  Future<void> saveProduct(Product product) async {
    if (product.id == null) {
      await _dbHelper.insertProduct(product.toMap());
    } else {
      await _dbHelper.updateProduct(product.toMap());
    }
  }

  Future<void> deleteProduct(int id) async {
    await _dbHelper.deleteProduct(id);
  }
}
