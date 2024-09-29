import 'package:flutter_tcc_app/src/models/aplicacao_model.dart';
import '../services/db_helper.dart';

class AplicacaoService {
  final DBHelper _dbHelper = DBHelper();

  // Inserir uma nova aplicação
  Future<int> insertAplicacao(Aplicacao aplicacao) async {
    final db = await _dbHelper.database;
    return await db.insert('Aplicacao', aplicacao.toMap());
  }

  // Buscar todas as aplicações
  Future<List<Aplicacao>> getAplicacoes() async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> maps = await db.query('Aplicacao');

    return List.generate(maps.length, (i) {
      return Aplicacao.fromMap(maps[i]);
    });
  }

  // Atualizar uma aplicação
  Future<int> updateAplicacao(Aplicacao aplicacao) async {
    final db = await _dbHelper.database;
    return await db.update(
      'Aplicacao',
      aplicacao.toMap(),
      where: 'id = ?',
      whereArgs: [aplicacao.id],
    );
  }

  // Deletar uma aplicação
  Future<int> deleteAplicacao(int id) async {
    final db = await _dbHelper.database;
    return await db.delete(
      'Aplicacao',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
