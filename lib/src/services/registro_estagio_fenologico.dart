import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import '../services/db_helper.dart';

class RegistroEstagioFenologicoService {
  final DBHelper _dbHelper = DBHelper();

  // Método para inserir um novo Registro de Estágio Fenológico
  Future<int> insertRegistroEstagioFenologico(
      RegistroEstagioFenologico registroEstagio) async {
    try {
      return await _dbHelper.insertRegistroEstagioFenologico(registroEstagio);
    } catch (e) {
      print("Erro no serviço ao adicionar Registro de Estágio Fenológico: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Método para obter todos os Registros de Estágio Fenológico
  Future<List<RegistroEstagioFenologico>>
      getRegistrosEstagioFenologico() async {
    try {
      return await _dbHelper.getRegistrosEstagioFenologico();
    } catch (e) {
      print("Erro no serviço ao obter Registros de Estágio Fenológico: $e");
      return []; // Retorna uma lista vazia em caso de erro
    }
  }

  // Método para obter um Registro de Estágio Fenológico pelo ID
  Future<RegistroEstagioFenologico?> getRegistroEstagioFenologicoById(
      int id) async {
    try {
      return await _dbHelper.getRegistroEstagioFenologicoById(id);
    } catch (e) {
      print(
          "Erro no serviço ao obter Registro de Estágio Fenológico por ID: $e");
      return null; // Retorna null em caso de erro
    }
  }

  // Método para atualizar um Registro de Estágio Fenológico existente
  Future<int> updateRegistroEstagioFenologico(
      RegistroEstagioFenologico registroEstagio) async {
    try {
      return await _dbHelper.updateRegistroEstagioFenologico(
          registroEstagio.id as RegistroEstagioFenologico);
    } catch (e) {
      print("Erro no serviço ao atualizar Registro de Estágio Fenológico: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }

  // Método para deletar um Registro de Estágio Fenológico
  Future<int> deleteRegistroEstagioFenologico(int id) async {
    try {
      return await _dbHelper.deleteRegistroEstagioFenologico(id);
    } catch (e) {
      print("Erro no serviço ao deletar Registro de Estágio Fenológico: $e");
      return -1; // Retorna um código de erro personalizado
    }
  }
}
