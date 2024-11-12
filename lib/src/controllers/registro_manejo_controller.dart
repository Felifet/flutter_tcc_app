import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';

class RegistroManejoController {
  final DBHelper _dbHelper = DBHelper(); // Instancia o DBHelper

  // Método para obter todos os registros de manejo com dados de gleba, ciclo e manejo
  Future<List<RegistroManejo>> getRegistrosManejo() async {
    try {
      final db = await _dbHelper.database;
      final List<Map<String, dynamic>> result = await db.rawQuery('''
        SELECT 
          rm.id,
          rm.datetime,
          rm.gleba_id,
          rm.ciclo_id,
          rm.manejo_id,
          g.nomeIdentificador  AS gleba_nome_identificador,
          c.descricao AS ciclo_descricao,
          m.descricao AS manejo_descricao
        FROM RegistroManejo rm
        JOIN gleba g ON rm.gleba_id = g.id
        JOIN ciclo c ON rm.ciclo_id = c.id
        JOIN manejo m ON rm.manejo_id = m.id
      ''');

      return result.map((data) => RegistroManejo.fromMap(data)).toList();
    } catch (e) {
      print("Erro ao obter registros de manejo: $e");
      return [];
    }
  }

  // Método para salvar um registro de manejo (inserir ou atualizar)
  Future<int> saveRegistroManejo(RegistroManejo registroManejo) async {
    try {
      if (registroManejo.id == null) {
        // Insere novo registro apenas se id for null
        return await _dbHelper.insertRegistroManejo(registroManejo.toMap());
      } else {
        // Atualiza registro existente
        return await _dbHelper.updateRegistroManejo(
            registroManejo.toMap(), registroManejo.id!);
      }
    } catch (e) {
      print("Erro ao salvar registro de manejo: $e");
      return -1; // Código de erro personalizado
    }
  }

  // Método para deletar um registro de manejo
  Future<int> deleteRegistroManejo(int id) async {
    try {
      return await _dbHelper.deleteRegistroManejo(id);
    } catch (e) {
      print("Erro ao deletar registro de manejo: $e");
      return -1; // Código de erro personalizado
    }
  }
}
