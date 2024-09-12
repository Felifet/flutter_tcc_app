import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';

class ManejoController {
  final DBHelper _dbHelper = DBHelper();

  // Inserir novo Manejo
  Future<int> addManejo(Manejo manejo) async {
    try {
      return await _dbHelper.insertManejo(manejo);
    } catch (e) {
      print("Erro ao adicionar Manejo: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Buscar todos os Manejos
  Future<List<Manejo>> fetchManejos() async {
    try {
      return await _dbHelper.getManejos();
    } catch (e) {
      print("Erro ao buscar Manejos: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  // Atualizar um Manejo existente
  Future<int> updateManejo(Manejo manejo) async {
    try {
      return await _dbHelper.updateManejo(manejo);
    } catch (e) {
      print("Erro ao atualizar Manejo: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Deletar um Manejo
  Future<int> deleteManejo(int id) async {
    try {
      return await _dbHelper.deleteManejo(id);
    } catch (e) {
      print("Erro ao deletar Manejo: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }
}
