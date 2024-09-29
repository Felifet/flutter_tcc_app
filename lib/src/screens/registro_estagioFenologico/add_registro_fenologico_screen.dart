import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:intl/intl.dart'; // Pacote para formatação de datas

class AddRegistroEstagioScreen extends StatefulWidget {
  const AddRegistroEstagioScreen({super.key});

  @override
  _AddRegistroEstagioScreenState createState() =>
      _AddRegistroEstagioScreenState();
}

class _AddRegistroEstagioScreenState extends State<AddRegistroEstagioScreen> {
  final TextEditingController _datetimeController = TextEditingController();
  Ciclo? _selectedCiclo;
  Gleba? _selectedGleba;
  EstagioFenologico? _selectedEstagioFenologico;

  List<Ciclo> _ciclos = [];
  List<Gleba> _glebas = [];
  List<EstagioFenologico> _estagios = [];

  @override
  void initState() {
    super.initState();
    _loadDropdownData();

    // Inicializa o campo de data/hora com o momento atual
    _datetimeController.text =
        DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now());
  }

  @override
  void dispose() {
    _datetimeController.dispose(); // Libera o controller ao finalizar
    super.dispose();
  }

  Future<void> _loadDropdownData() async {
    try {
      _ciclos = await DBHelper().getCiclos();
      _glebas = await DBHelper().getGlebas();
      _estagios = (await DBHelper().getAllEstagiosFenologicos())
          .cast<EstagioFenologico>();
      setState(() {});
    } catch (e) {
      print("Erro ao carregar dados: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Erro ao carregar dados')),
      );
    }
  }

  void _saveRegistroEstagio() async {
    final DateTime? datetime = DateTime.tryParse(_datetimeController.text);
    if (datetime == null) {
      _showError('Por favor, insira uma data e hora válidas.');
      return;
    }

    if (_selectedCiclo == null) {
      _showError('Por favor, selecione um ciclo.');
      return;
    }

    if (_selectedGleba == null) {
      _showError('Por favor, selecione uma gleba.');
      return;
    }

    if (_selectedEstagioFenologico == null) {
      _showError('Por favor, selecione um estágio fenológico.');
      return;
    }

    try {
      final registroEstagio = RegistroEstagioFenologico(
        datetime: datetime,
        cicloId: _selectedCiclo!.id!,
        glebaId: _selectedGleba!.id!,
        estagioFenologicoId: _selectedEstagioFenologico!.id!,
      );
      await DBHelper().insertRegistroEstagioFenologico(registroEstagio);
      Navigator.pop(context);
    } catch (e) {
      print("Erro ao salvar registro: $e");
      _showError('Erro ao salvar o registro.');
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:
          AppBar(title: const Text('Adicionar Registro Estágio Fenológico')),
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
              value: _selectedEstagioFenologico,
              hint: const Text('Selecione o Estágio Fenológico'),
              items: _estagios.map((estagio) {
                return DropdownMenuItem<EstagioFenologico>(
                  value: estagio,
                  child: Text(estagio.descricao),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedEstagioFenologico = value;
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
