import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';

class RegistroEstagioFenologicoService {
  final DBHelper _dbHelper = DBHelper();

  // Método para inserir um novo Registro de Estágio Fenológico
  Future<int> insertRegistroEstagioFenologico(
      RegistroEstagioFenologico registroEstagio) async {
    try {
      return await _dbHelper.insertRegistroEstagioFenologico(registroEstagio);
    } catch (e) {
      print("Erro no serviço ao adicionar Registro de Estágio Fenológico: $e");
      return -1;
    }
  }

  // Método para obter todos os Registros de Estágio Fenológico
  Future<List<RegistroEstagioFenologico>>
      getRegistrosEstagioFenologico() async {
    try {
      List<RegistroEstagioFenologico> registros =
          await _dbHelper.getRegistrosEstagioFenologico();

      for (var registro in registros) {
        // Carregar os nomes associados
        if (registro.cicloId != null) {
          Ciclo? ciclo = await getCicloById(registro.cicloId);
          registro.nomeCiclo = ciclo?.descricao;
        }
        if (registro.glebaId != null) {
          Gleba? gleba = await getGlebaById(registro.glebaId);
          registro.nomeGleba = gleba?.nomeIdentificador;
        }
        if (registro.estagioFenologicoId != null) {
          EstagioFenologico? estagio =
              await getEstagioFenologicoById(registro.estagioFenologicoId);
          registro.nomeEstagioFenologico = estagio?.descricao;
        }
      }

      return registros;
    } catch (e) {
      print("Erro no serviço ao obter Registros de Estágio Fenológico: $e");
      return [];
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
      return null;
    }
  }

  // Método para atualizar um Registro de Estágio Fenológico existente
  Future<int> updateRegistroEstagioFenologico(
      RegistroEstagioFenologico registroEstagio) async {
    try {
      return await _dbHelper.updateRegistroEstagioFenologico(registroEstagio);
    } catch (e) {
      print("Erro no serviço ao atualizar Registro de Estágio Fenológico: $e");
      return -1;
    }
  }

  // Método para deletar um Registro de Estágio Fenológico
  Future<int> deleteRegistroEstagioFenologico(int id) async {
    try {
      return await _dbHelper.deleteRegistroEstagioFenologico(id);
    } catch (e) {
      print("Erro no serviço ao deletar Registro de Estágio Fenológico: $e");
      return -1;
    }
  }

  // Método para recuperar o nome do ciclo pelo ID
  Future<Ciclo?> getCicloById(int? cicloId) async {
    final db = await _dbHelper;

    if (cicloId == null) return null;

    final List<Map<String, dynamic>> maps = await db.query(
      'ciclos',
      where: 'id = ?',
      whereArgs: [cicloId],
    );

    if (maps.isNotEmpty) {
      return Ciclo.fromMap(maps.first);
    }

    return null;
  }

  // Método para recuperar o nome da gleba pelo ID
  Future<Gleba?> getGlebaById(int? glebaId) async {
    final db = await _dbHelper;

    if (glebaId == null) return null;

    final List<Map<String, dynamic>> maps = await db.query(
      'glebas',
      where: 'id = ?',
      whereArgs: [glebaId],
    );

    if (maps.isNotEmpty) {
      return Gleba.fromMap(maps.first);
    }

    return null;
  }

  // Método para recuperar o nome do estágio fenológico pelo ID
  Future<EstagioFenologico?> getEstagioFenologicoById(int? estagioId) async {
    final db = await _dbHelper;

    if (estagioId == null) return null;

    final List<Map<String, dynamic>> maps = await db.query(
      'estagios_fenologicos',
      where: 'id = ?',
      whereArgs: [estagioId],
    );

    if (maps.isNotEmpty) {
      return EstagioFenologico.fromMap(maps.first);
    }

    return null;
  }
}
