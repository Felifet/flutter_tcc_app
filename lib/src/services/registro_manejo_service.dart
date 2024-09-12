import '../models/registro_manejo_model.dart';
import '../services/db_helper.dart';

class RegistroManejoService {
  final DBHelper _dbHelper = DBHelper();

  Future<int> addRegistroManejo(RegistroManejo registro) async {
    final db = await _dbHelper.database;
    return await db.insert('RegistroManejo', registro.toMap());
  }

  // Pegar lista de registros de manejo, se precisar
  Future<List<RegistroManejo>> getRegistrosManejo() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('RegistroManejo');

    return List.generate(maps.length, (i) {
      return RegistroManejo.fromMap(maps[i]);
    });
  }
}
