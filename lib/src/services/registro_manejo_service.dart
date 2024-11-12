import '../models/registro_manejo_model.dart';
import '../services/db_helper.dart';

class RegistroManejoService {
  final DBHelper _dbHelper = DBHelper();

  // Método para adicionar um novo registro de manejo
  Future<int> addRegistroManejo(RegistroManejo registro) async {
    final db = await _dbHelper.database;
    return await db.insert('RegistroManejo', registro.toMap());
  }

  // Método para pegar lista de registros de manejo com os dados relacionados
  Future<List<RegistroManejo>> getRegistrosManejo() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.rawQuery('''
      SELECT 
        rm.id,
        rm.datetime,
        rm.gleba_id,
        rm.ciclo_id,
        rm.manejo_id,
        g.nome_identificador AS gleba_nome_identificador,
        c.descricao AS ciclo_descricao,
        m.descricao AS manejo_descricao
      FROM registro_manejo rm
      JOIN gleba g ON rm.gleba_id = g.id
      JOIN ciclo c ON rm.ciclo_id = c.id
      JOIN manejo m ON rm.manejo_id = m.id
    ''');

    return List.generate(maps.length, (i) {
      return RegistroManejo.fromMap(maps[i]);
    });
  }
}
