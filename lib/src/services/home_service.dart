import 'package:flutter_tcc_app/src/services/db_helper.dart';

class HomeService {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getAplicacoesPorCiclo(int glebaId) async {
    final db = await _dbHelper.database;
    final List<Map<String, dynamic>> data = await db.rawQuery(
      '''
      SELECT 
        c.id AS ciclo_id, c.descricao AS ciclo_descricao, COUNT(a.id) AS total
      FROM Aplicacao a
      JOIN Ciclo c ON a.ciclo_id = c.id
      WHERE a.gleba_id = ?
      GROUP BY c.id
      ORDER BY c.id
      ''',
      [glebaId],
    );
    return data;
  }

  Future<List<Map<String, dynamic>>> getAllGlebas() async {
    final db = await _dbHelper.database;
    return await db.query('Gleba');
  }

  Future<List<Map<String, dynamic>>> getAplicacoesPorTipoAgrupado() async {
    final db = await _dbHelper.database;

    final query = '''
    SELECT 
        c.id AS ciclo_id, 
        c.descricao AS ciclo_descricao, 
        g.nomeIdentificador AS gleba_nome, 
        p.tipo AS produto_tipo, 
        COUNT(a.id) AS total
    FROM Aplicacao a
    left JOIN Ciclo c ON a.ciclo_id = c.id
    left JOIN Gleba g ON a.gleba_id = g.id
    left JOIN products p ON a.produto_id = p.id 
    GROUP BY c.id, g.id, p.tipo
    ''';

    final result = await db.rawQuery(query);
    return result;
  }
}
