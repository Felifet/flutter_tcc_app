import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/services/ciclo_service.dart';

class CicloController {
  final CicloService _cicloService = CicloService();

  Future<void> saveCiclo(Ciclo ciclo) async {
    if (ciclo.id == null) {
      // Se não houver ID, cria um novo ciclo
      await _cicloService.insertCiclo(ciclo);
    } else {
      // Se houver ID, atualiza o ciclo existente
      await _cicloService.updateCiclo(ciclo);
    }
  }

  Future<List<Ciclo>> getCiclos() async {
    return await _cicloService.getCiclos();
  }

  Future<void> deleteCiclo(int id) async {
    await _cicloService.deleteCiclo(id);
  }
}
