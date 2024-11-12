import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/registro_estagio_fenologico.dart';

class RegistroEstagioFenologicoController {
  final RegistroEstagioFenologicoService _service =
      RegistroEstagioFenologicoService();

  // Adiciona um novo registro de estágio fenológico
  Future<int> addRegistroEstagioFenologico(
      RegistroEstagioFenologico registro) async {
    try {
      return await _service.insertRegistroEstagioFenologico(registro);
    } catch (e) {
      print('Erro ao adicionar registro de estágio fenológico: $e');
      return -1;
    }
  }

  // Atualiza um registro existente de estágio fenológico
  Future<int> updateRegistroEstagioFenologico(
      RegistroEstagioFenologico registro) async {
    if (registro.id != null) {
      try {
        return await _service.updateRegistroEstagioFenologico(registro);
      } catch (e) {
        print('Erro ao atualizar registro de estágio fenológico: $e');
        return -1;
      }
    } else {
      print('Erro: ID do registro é nulo');
      return -1;
    }
  }

  // Exclui um registro de estágio fenológico pelo ID
  Future<int> deleteRegistroEstagioFenologico(int id) async {
    try {
      return await _service.deleteRegistroEstagioFenologico(id);
    } catch (e) {
      print('Erro ao deletar registro de estágio fenológico: $e');
      return -1;
    }
  }

  // Recupera todos os registros de estágio fenológico com os nomes
  Future<List<RegistroEstagioFenologico>>
      getRegistrosEstagioFenologico() async {
    try {
      return await _service.getRegistrosEstagioFenologico();
    } catch (e) {
      print('Erro ao buscar registros de estágio fenológico: $e');
      return [];
    }
  }

  // Recupera um único registro de estágio fenológico pelo ID
  Future<RegistroEstagioFenologico?> getRegistroEstagioFenologicoById(
      int id) async {
    try {
      return await _service.getRegistroEstagioFenologicoById(id);
    } catch (e) {
      print('Erro ao buscar registro de estágio fenológico: $e');
      return null;
    }
  }
}
