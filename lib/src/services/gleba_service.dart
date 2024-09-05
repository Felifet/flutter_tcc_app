import '../models/gleba_model.dart';
import '../services/db_helper.dart';

class GlebaService {
  final DBHelper _dbHelper = DBHelper();

  Future<int> addGleba(Gleba gleba) async {
    return await _dbHelper.insertGleba(gleba);
  }

  Future<List<Gleba>> getGlebas() async {
    final List<Gleba> glebas = await _dbHelper.getGlebas();
    return glebas;
  }

  Future<int> updateGleba(Gleba gleba) async {
    return await _dbHelper.updateGleba(gleba);
  }

  Future<void> deleteGleba(int id) async {
    await _dbHelper.deleteGleba(id);
  }
}
