import 'package:flutter_tcc_app/src/models/cultivar_model.dart';
import 'package:flutter_tcc_app/src/services/cultivar_service.dart';

class CultivarController {
  final CultivarService _cultivarService = CultivarService();

  // Adiciona uma nova cultivar ou atualiza uma existente
  Future<void> saveCultivar(Cultivar cultivar) async {
    if (cultivar.id == null) {
      // Inserir nova cultivar
      await _cultivarService.addCultivar(cultivar);
    } else {
      // Atualizar cultivar existente
      await _cultivarService.updateCultivar(cultivar);
    }
  }

  // Obtém todas as cultivares
  Future<List<Cultivar>> getCultivares() async {
    return await _cultivarService.getAllCultivares();
  }

  // Exclui uma cultivar pelo ID
  Future<void> deleteCultivar(int id) async {
    await _cultivarService.deleteCultivar(id);
  }
}
