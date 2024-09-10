import '../models/cultivar_model.dart';
import '../services/db_helper.dart';

class CultivarService {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Cultivar>> getAllCultivares() async {
    return await _dbHelper.getCultivars();
  }

  Future<void> addCultivar(Cultivar cultivar) async {
    await _dbHelper.insertCultivar(cultivar);
  }

  Future<void> updateCultivar(Cultivar cultivar) async {
    await _dbHelper.updateCultivar(cultivar);
  }

  Future<void> deleteCultivar(int id) async {
    await _dbHelper.deleteCultivar(id);
  }
}
