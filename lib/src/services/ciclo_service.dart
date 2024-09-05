import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import '../services/db_helper.dart';

class CicloService {
  final DBHelper _dbHelper = DBHelper();

  // Inserir um novo ciclo
  Future<int> insertCiclo(Ciclo ciclo) async {
    final db = await _dbHelper.database;
    return await db.insert('Ciclo', ciclo.toMap());
  }

  // Buscar todos os ciclos
  Future<List<Ciclo>> getCiclos() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Ciclo');

    return List.generate(maps.length, (i) {
      return Ciclo.fromMap(maps[i]);
    });
  }

  // Atualizar um ciclo
  Future<int> updateCiclo(Ciclo ciclo) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Ciclo',
      ciclo.toMap(),
      where: 'id = ?',
      whereArgs: [ciclo.id],
    );
  }

  // Deletar um ciclo
  Future<int> deleteCiclo(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Ciclo',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
