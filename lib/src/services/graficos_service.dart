import 'package:flutter_tcc_app/src/services/db_helper.dart';

class GraficosService {
  final DBHelper _dbHelper = DBHelper();

  Future<List<Map<String, dynamic>>> getAplicacoesPorGlebaECiclo(
      int glebaId, int cicloId) async {
    final db = await _dbHelper.database;

    // SQL ajustado para filtrar por IDs de Gleba e Ciclo
    String queryAplicacoes = '''
      SELECT 
        p.tipo AS produto_tipo,              -- Tipo do produto
        a.datetime AS data_aplicacao,       -- Data da aplicação
        a.motivo AS motivo_aplicacao,       -- Motivo da aplicação
        p.vigencia AS produto_vigencia,     -- Vigência do produto
        p.intervaloDeSeguranca AS intervalo_seguranca -- Intervalo de segurança
      FROM Aplicacao a
      INNER JOIN products p ON a.produto_id = p.id
      INNER JOIN Gleba g ON a.gleba_id = g.id
      INNER JOIN Ciclo c ON a.ciclo_id = c.id
      WHERE a.gleba_id = ? AND a.ciclo_id = ?
    ''';

    List<dynamic> argsAplicacoes = [glebaId, cicloId];
    return await db.rawQuery(queryAplicacoes, argsAplicacoes);
  }

  // Função para buscar registros de manejo filtrados por IDs de Gleba e Ciclo
  Future<List<Map<String, dynamic>>> getRegistrosDeManejo(
      int glebaId, int cicloId) async {
    final db = await _dbHelper.database;

    String queryManejo = '''
      SELECT 
        m.nome AS manejo_nome,             -- Nome do manejo
        m.descricao AS manejo_descricao,   -- Descrição do manejo
        r.datetime AS data_manejo          -- Data do registro do manejo
      FROM RegistroManejo r
      INNER JOIN Manejo m ON r.manejo_id = m.id
      INNER JOIN Gleba g ON r.gleba_id = g.id
      INNER JOIN Ciclo c ON r.ciclo_id = c.id
      WHERE r.gleba_id = ? AND r.ciclo_id = ?
    ''';

    List<dynamic> argsManejo = [glebaId, cicloId];
    return await db.rawQuery(queryManejo, argsManejo);
  }
}
