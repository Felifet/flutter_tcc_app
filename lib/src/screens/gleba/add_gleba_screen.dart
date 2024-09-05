import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import '../../services/db_helper.dart';

class AddGlebaScreen extends StatefulWidget {
  const AddGlebaScreen({super.key});

  @override
  _AddGlebaScreenState createState() => _AddGlebaScreenState();
}

class _AddGlebaScreenState extends State<AddGlebaScreen> {
  final TextEditingController _nomeIdentificadorController =
      TextEditingController();
  final TextEditingController _areaController = TextEditingController();
  final TextEditingController _cultivarIdController = TextEditingController();

  void _saveGleba() async {
    final String nomeIdentificador = _nomeIdentificadorController.text;
    final double? area = double.tryParse(_areaController.text);
    final int? cultivarId = int.tryParse(_cultivarIdController.text);

    if (nomeIdentificador.isNotEmpty && area != null) {
      final gleba = {
        'nomeIdentificador': nomeIdentificador,
        'area': area,
        'cultivar_id': cultivarId
      };
      await DBHelper().insertGleba(gleba as Gleba);
      Navigator.pop(context); // Volta para a lista de glebas
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add Gleba')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _nomeIdentificadorController,
              decoration:
                  const InputDecoration(labelText: 'Nome Identificador'),
            ),
            TextField(
              controller: _areaController,
              decoration: const InputDecoration(labelText: 'Área (ha)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: _cultivarIdController,
              decoration: const InputDecoration(labelText: 'Cultivar ID'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveGleba,
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.blue,
              ),
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
