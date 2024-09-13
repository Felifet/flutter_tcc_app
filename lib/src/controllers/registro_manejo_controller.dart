import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';

class RegistroManejoController {
  final DBHelper _dbHelper = DBHelper(); // Instancia o DBHelper

  // Método para obter todos os registros de manejo
  Future<List<RegistroManejo>> getRegistrosManejo() async {
    try {
      final List<Map<String, dynamic>> result =
          await _dbHelper.getRegistrosManejo();
      return result.map((data) => RegistroManejo.fromMap(data)).toList();
    } catch (e) {
      print("Erro ao obter registros de manejo: $e");
      return [];
    }
  }

  // Método para salvar um registro de manejo (inserir ou atualizar)
  Future<int> saveRegistroManejo(RegistroManejo registroManejo) async {
    try {
      if (registroManejo.id == 0) {
        // Inserir novo registro
        return await _dbHelper.insertRegistroManejo(registroManejo.toMap());
      } else {
        // Atualizar registro existente
        return await _dbHelper.updateRegistroManejo(
            registroManejo.toMap(), registroManejo.id);
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
