import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/services/manejo_service.dart';

class AddManejoScreen extends StatefulWidget {
  const AddManejoScreen({super.key});

  @override
  _AddManejoScreenState createState() => _AddManejoScreenState();
}

class _AddManejoScreenState extends State<AddManejoScreen> {
  final _nomeController = TextEditingController();
  final _descricaoController = TextEditingController();
  final ManejoService _manejoService = ManejoService();

  void _saveManejo() async {
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

    final manejo = Manejo(nome: nome, descricao: descricao);
    await _manejoService.insertManejo(manejo);
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Manejo'),
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
              onPressed: _saveManejo,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
