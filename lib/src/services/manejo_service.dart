import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import '../services/db_helper.dart';

class ManejoService {
  final DBHelper _dbHelper = DBHelper();

  // Inserir um novo manejo
  Future<int> insertManejo(Manejo manejo) async {
    final db = await _dbHelper.database;
    return await db.insert('Manejo', manejo.toMap());
  }

  // Buscar todos os manejos
  Future<List<Manejo>> getManejos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Manejo');

    return List.generate(maps.length, (i) {
      return Manejo.fromMap(maps[i]);
    });
  }

  // Atualizar um manejo
  Future<int> updateManejo(Manejo manejo) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Manejo',
      manejo.toMap(),
      where: 'id = ?',
      whereArgs: [manejo.id],
    );
  }

  // Deletar um manejo
  Future<int> deleteManejo(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Manejo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
