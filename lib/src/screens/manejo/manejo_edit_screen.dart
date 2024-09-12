import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/services/manejo_service.dart';

class EditManejoScreen extends StatefulWidget {
  final Manejo manejo;

  const EditManejoScreen({super.key, required this.manejo});

  @override
  _EditManejoScreenState createState() => _EditManejoScreenState();
}

class _EditManejoScreenState extends State<EditManejoScreen> {
  late TextEditingController _nomeController;
  late TextEditingController _descricaoController;
  final ManejoService _manejoService = ManejoService();

  @override
  void initState() {
    super.initState();
    _nomeController = TextEditingController(text: widget.manejo.nome);
    _descricaoController = TextEditingController(text: widget.manejo.descricao);
  }

  void _saveChanges() async {
    final nome = _nomeController.text;
    final descricao = _descricaoController.text;

    if (nome.isEmpty || descricao.isEmpty) {
      // Exibir um alerta se os campos não estiverem preenchidos
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Erro'),
          content: const Text('Por favor, preencha todos os campos.'),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(ctx).pop();
              },
            ),
          ],
        ),
      );
      return;
    }

    final updatedManejo = Manejo(
      id: widget.manejo.id,
      nome: nome,
      descricao: descricao,
    );
    await _manejoService.updateManejo(updatedManejo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar Manejo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _nomeController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _descricaoController,
              decoration: const InputDecoration(labelText: 'Descrição'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Salvar Alterações'),
            ),
          ],
        ),
      ),
    );
  }
}
