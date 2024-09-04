import '../models/gleba_model.dart';
import '../services/db_helper.dart';

class GlebaController {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Gleba>> getAllGlebas() async {
    return await _dbHelper.getGlebas();
  }

  Future<void> saveGleba(Gleba gleba) async {
    if (gleba.id == null) {
      await _dbHelper.insertGleba(gleba);
    } else {
      await _dbHelper.updateGleba(gleba);
    }
  }

  Future<void> deleteGleba(int id) async {
    await _dbHelper.deleteGleba(id);
  }
}
