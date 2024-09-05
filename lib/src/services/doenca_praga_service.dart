import '../controllers/doenca_praga_controller.dart';
import '../models/doenca_praga_model.dart';

class DoencaPragaService {
  final DoencaPragaController _controller = DoencaPragaController();

  // Adiciona uma nova DoencaPraga
  Future<void> addDoencaPraga(
      String descricaoCurta, String? descricaoLonga) async {
    try {
      final doencaPraga = DoencaPraga(
        descricaoCurta: descricaoCurta,
        descricaoLonga: descricaoLonga,
      );
      await _controller.addDoencaPraga(doencaPraga);
    } catch (e) {
      print("Erro ao adicionar Doença/Praga no serviço: $e");
      throw Exception("Erro ao adicionar Doença/Praga");
    }
  }

  // Atualiza uma DoencaPraga existente
  Future<void> updateDoencaPraga(
      int id, String descricaoCurta, String? descricaoLonga) async {
    try {
      final doencaPraga = DoencaPraga(
        id: id,
        descricaoCurta: descricaoCurta,
        descricaoLonga: descricaoLonga,
      );
      await _controller.updateDoencaPraga(doencaPraga);
    } catch (e) {
      print("Erro ao atualizar Doença/Praga no serviço: $e");
      throw Exception("Erro ao atualizar Doença/Praga");
    }
  }

  // Remove uma DoencaPraga pelo id
  Future<void> deleteDoencaPraga(int id) async {
    try {
      await _controller.deleteDoencaPraga(id);
    } catch (e) {
      print("Erro ao deletar Doença/Praga no serviço: $e");
      throw Exception("Erro ao deletar Doença/Praga");
    }
  }

  // Retorna todas as DoencaPraga
  Future<List<DoencaPraga>> getDoencasPragas() async {
    try {
      return await _controller.getDoencasPragas();
    } catch (e) {
      print("Erro ao buscar Doença/Praga no serviço: $e");
      throw Exception("Erro ao buscar Doença/Praga");
    }
  }

  // Retorna uma DoencaPraga pelo id
  Future<DoencaPraga?> getDoencaPragaById(int id) async {
    try {
      return await _controller.getDoencaPragaById(id);
    } catch (e) {
      print("Erro ao buscar Doença/Praga por id no serviço: $e");
      throw Exception("Erro ao buscar Doença/Praga por id");
    }
  }
}
