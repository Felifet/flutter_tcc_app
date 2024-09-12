import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';

class EstagioFenologicoController {
  final DBHelper dbHelper = DBHelper();

  Future<List<EstagioFenologico>> getAllEstagiosFenologicos() async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('EstagioFenologico');
    return List.generate(maps.length, (i) {
      return EstagioFenologico.fromMap(maps[i]);
    });
  }

  Future<EstagioFenologico?> getEstagioFenologicoById(int id) async {
    final db = await dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query(
      'EstagioFenologico',
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return EstagioFenologico.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<int> insertEstagioFenologico(
      EstagioFenologico estagioFenologico) async {
    final db = await dbHelper.database;
    return await db.insert('EstagioFenologico', estagioFenologico.toMap());
  }

  Future<int> updateEstagioFenologico(
      EstagioFenologico estagioFenologico) async {
    final db = await dbHelper.database;
    return await db.update(
      'EstagioFenologico',
      estagioFenologico.toMap(),
      where: 'id = ?',
      whereArgs: [estagioFenologico.id],
    );
  }

  Future<int> deleteEstagioFenologico(int id) async {
    final db = await dbHelper.database;
    return await db.delete(
      'EstagioFenologico',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
