import 'package:flutter_tcc_app/src/services/db_helper.dart';
import 'package:flutter_tcc_app/src/services/doenca_praga_service.dart';
import '../models/doenca_praga_model.dart';

class DoencaPragaController {
  final DBHelper _dbHelper = DBHelper();

  // Adiciona uma nova DoencaPraga
  Future<void> addDoencaPraga(DoencaPraga doencaPraga) async {
    try {
      await _dbHelper.insertDoencaPraga(doencaPraga.toMap() as DoencaPraga);
    } catch (e) {
      print("Erro ao adicionar Doença/Praga: $e");
      throw Exception("Erro ao adicionar Doença/Praga");
    }
  }

  // Atualiza uma DoencaPraga existente
  Future<void> updateDoencaPraga(DoencaPraga doencaPraga) async {
    try {
      await _dbHelper.updateDoencaPraga(doencaPraga.toMap() as DoencaPraga);
    } catch (e) {
      print("Erro ao atualizar Doença/Praga: $e");
      throw Exception("Erro ao atualizar Doença/Praga");
    }
  }

  // Remove uma DoencaPraga pelo id
  Future<void> deleteDoencaPraga(int id) async {
    try {
      await _dbHelper.deleteDoencaPraga(id);
    } catch (e) {
      print("Erro ao deletar Doença/Praga: $e");
      throw Exception("Erro ao deletar Doença/Praga");
    }
  }

  // Retorna todas as DoencaPraga
  Future<List<DoencaPraga>> getDoencasPragas() async {
    try {
      final doencasPragasMap = await _dbHelper.getDoencasPragas();
      return doencasPragasMap
          .map((map) => DoencaPraga.fromMap(map as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Erro ao buscar Doença/Praga: $e");
      throw Exception("Erro ao buscar Doença/Praga");
    }
  }

  // Retorna uma DoencaPraga pelo id
  Future<DoencaPraga?> getDoencaPragaById(int id) async {
    try {
      final doencaPragaMap = await _dbHelper.getDoencaPragaById(id);
      if (doencaPragaMap != null) {
        return DoencaPraga.fromMap(doencaPragaMap as Map<String, dynamic>);
      }
      return null;
    } catch (e) {
      print("Erro ao buscar Doença/Praga por id: $e");
      throw Exception("Erro ao buscar Doença/Praga por id");
    }
  }
}
