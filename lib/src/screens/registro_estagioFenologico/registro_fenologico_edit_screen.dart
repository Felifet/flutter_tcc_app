import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';

class EditRegistroEstagioScreen extends StatefulWidget {
  final RegistroEstagioFenologico registroEstagio;

  const EditRegistroEstagioScreen({super.key, required this.registroEstagio});

  @override
  _EditRegistroEstagioScreenState createState() =>
      _EditRegistroEstagioScreenState();
}

class _EditRegistroEstagioScreenState extends State<EditRegistroEstagioScreen> {
  final TextEditingController _datetimeController = TextEditingController();
  Ciclo? _selectedCiclo;
  Gleba? _selectedGleba;
  EstagioFenologico? _selectedEstagio;

  List<Ciclo> _ciclos = [];
  List<Gleba> _glebas = [];
  List<EstagioFenologico> _estagios = [];

  @override
  void initState() {
    super.initState();
    _datetimeController.text = widget.registroEstagio.datetime.toString();
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    _ciclos = await DBHelper().getCiclos();
    _glebas = await DBHelper().getGlebas();
    _estagios =
        (await DBHelper().getEstagiosFenologicos()).cast<EstagioFenologico>();
    setState(() {
      _selectedCiclo = _ciclos
          .firstWhere((ciclo) => ciclo.id == widget.registroEstagio.cicloId);
      _selectedGleba = _glebas
          .firstWhere((gleba) => gleba.id == widget.registroEstagio.glebaId);
      _selectedEstagio = _estagios.firstWhere((estagio) =>
          estagio.id == widget.registroEstagio.estagioFenologicoId);
    });
  }

  void _saveRegistroEstagio() async {
    if (_selectedCiclo != null &&
        _selectedGleba != null &&
        _selectedEstagio != null) {
      final registroEstagio = RegistroEstagioFenologico(
        id: widget.registroEstagio.id,
        datetime: DateTime.tryParse(_datetimeController.text)!,
        cicloId: _selectedCiclo!.id!,
        glebaId: _selectedGleba!.id!,
        estagioFenologicoId: _selectedEstagio!.id!,
      );
      await DBHelper().updateRegistroEstagioFenologico(registroEstagio);
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Editar Registro Estágio Fenológico')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            TextField(
              controller: _datetimeController,
              decoration: const InputDecoration(
                  labelText: 'Data e Hora (YYYY-MM-DD HH:MM)'),
              keyboardType: TextInputType.datetime,
            ),
            DropdownButtonFormField<Ciclo>(
              value: _selectedCiclo,
              hint: const Text('Selecione o Ciclo'),
              items: _ciclos.map((ciclo) {
                return DropdownMenuItem<Ciclo>(
                  value: ciclo,
                  child: Text(ciclo.descricao),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedCiclo = value;
                });
              },
            ),
            DropdownButtonFormField<Gleba>(
              value: _selectedGleba,
              hint: const Text('Selecione a Gleba'),
              items: _glebas.map((gleba) {
                return DropdownMenuItem<Gleba>(
                  value: gleba,
                  child: Text(gleba.nomeIdentificador),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedGleba = value;
                });
              },
            ),
            DropdownButtonFormField<EstagioFenologico>(
              value: _selectedEstagio,
              hint: const Text('Selecione o Estágio Fenológico'),
              items: _estagios.map((estagio) {
                return DropdownMenuItem<EstagioFenologico>(
                  value: estagio,
                  child: Text(estagio.descricao),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEstagio = value;
                });
              },
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveRegistroEstagio,
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
