import 'package:flutter/material.dart';
import '../../models/gleba_model.dart';
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
  int? _selectedCultivarId;

  List<Map<String, dynamic>> _cultivares = [];

  @override
  void initState() {
    super.initState();
    _loadCultivares();
  }

  Future<void> _loadCultivares() async {
    final db = await DBHelper().database;
    final result = await db.query('Cultivar');
    setState(() {
      _cultivares = result;
    });
  }

  void _saveGleba() async {
    final String nomeIdentificador = _nomeIdentificadorController.text;
    final double? area = double.tryParse(_areaController.text);

    if (nomeIdentificador.isNotEmpty &&
        area != null &&
        _selectedCultivarId != null) {
      final gleba = Gleba(
        nomeIdentificador: nomeIdentificador,
        area: area,
        cultivarId: _selectedCultivarId,
      );
      await DBHelper().insertGleba(gleba);
      Navigator.pop(context); // Volta para a lista de glebas
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Adicionar Gleba')),
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
            const SizedBox(height: 20),
            DropdownButtonFormField<int>(
              value: _selectedCultivarId,
              items: _cultivares.map((cultivar) {
                return DropdownMenuItem<int>(
                  value: cultivar['id'],
                  child: Text(cultivar['nome']),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCultivarId = value;
                });
              },
              decoration: const InputDecoration(labelText: 'Cultivar'),
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
