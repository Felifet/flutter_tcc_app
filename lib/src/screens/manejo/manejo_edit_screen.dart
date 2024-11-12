import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/screens/home_screen.dart';
import 'package:flutter_tcc_app/src/screens/menu_screen.dart';
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
              style: ElevatedButton.styleFrom(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
                textStyle: const TextStyle(fontSize: 16),
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: const Color.fromARGB(255, 5, 94, 105),
        child: Container(
          height: 20, // Ajuste a altura da BottomAppBar
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              IconButton(
                icon: const Icon(Icons.home),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.list),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (context) => MenuScreen()));
                },
              ),
              IconButton(
                icon: const Icon(Icons.exit_to_app_sharp),
                color: const Color.fromARGB(255, 255, 255, 255),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
