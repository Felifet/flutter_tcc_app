import 'package:flutter_tcc_app/src/controllers/estagiofenologico_controller.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';

class EstagioFenologicoService {
  final EstagioFenologicoController _controller = EstagioFenologicoController();

  Future<List<EstagioFenologico>> getAllEstagiosFenologicos() async {
    return await _controller.getAllEstagiosFenologicos();
  }

  Future<EstagioFenologico?> getEstagioFenologicoById(int id) async {
    return await _controller.getEstagioFenologicoById(id);
  }

  Future<int> addEstagioFenologico(EstagioFenologico estagioFenologico) async {
    return await _controller.insertEstagioFenologico(estagioFenologico);
  }

  Future<int> updateEstagioFenologico(
      EstagioFenologico estagioFenologico) async {
    return await _controller.updateEstagioFenologico(estagioFenologico);
  }

  Future<int> deleteEstagioFenologico(int id) async {
    return await _controller.deleteEstagioFenologico(id);
  }
}
