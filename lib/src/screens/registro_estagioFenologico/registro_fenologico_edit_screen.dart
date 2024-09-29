import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/models/registro_estagiofenologico_model.dart';
import 'package:flutter_tcc_app/src/services/db_helper.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';

class EditRegistroEstagioScreen extends StatefulWidget {
  final RegistroEstagioFenologico? registroEstagio;

  const EditRegistroEstagioScreen({super.key, this.registroEstagio});

  @override
  _EditRegistroEstagioScreenState createState() =>
      _EditRegistroEstagioScreenState();
}

class _EditRegistroEstagioScreenState extends State<EditRegistroEstagioScreen> {
  final _formKey = GlobalKey<FormState>();
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
    _datetimeController.text =
        widget.registroEstagio?.datetime.toString() ?? '';
    _loadDropdownData();
  }

  Future<void> _loadDropdownData() async {
    _ciclos = await DBHelper().getCiclos();
    _glebas = await DBHelper().getGlebas();
    _estagios = (await DBHelper().getAllEstagiosFenologicos())
        .cast<EstagioFenologico>();
    setState(() {
      if (widget.registroEstagio != null) {
        _selectedCiclo = _ciclos
            .firstWhere((ciclo) => ciclo.id == widget.registroEstagio?.cicloId);
        _selectedGleba = _glebas
            .firstWhere((gleba) => gleba.id == widget.registroEstagio?.glebaId);
        _selectedEstagio = _estagios.firstWhere((estagio) =>
            estagio.id == widget.registroEstagio?.estagioFenologicoId);
      }
    });
  }

  void _saveRegistroEstagio() async {
    if (_formKey.currentState!.validate()) {
      final registroEstagio = RegistroEstagioFenologico(
        id: widget.registroEstagio?.id,
        datetime: DateTime.tryParse(_datetimeController.text)!,
        cicloId: _selectedCiclo!.id!,
        glebaId: _selectedGleba!.id!,
        estagioFenologicoId: _selectedEstagio!.id!,
      );
      if (widget.registroEstagio == null) {
        await DBHelper().insertRegistroEstagioFenologico(registroEstagio);
      } else {
        await DBHelper().updateRegistroEstagioFenologico(registroEstagio);
      }
      Navigator.pop(context);
    }
  }

  void _confirmDeleteRegistro() async {
    if (widget.registroEstagio != null) {
      final bool? confirm = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Confirmar Exclusão'),
          content:
              const Text('Você tem certeza que deseja excluir este registro?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Excluir'),
            ),
          ],
        ),
      );

      if (confirm == true) {
        await DBHelper()
            .deleteRegistroEstagioFenologico(widget.registroEstagio!.id!);
        Navigator.pop(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.registroEstagio == null
            ? 'Adicionar Registro'
            : 'Editar Registro'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: <Widget>[
              TextFormField(
                controller: _datetimeController,
                decoration: const InputDecoration(
                    labelText: 'Data e Hora (YYYY-MM-DD HH:MM)'),
                keyboardType: TextInputType.datetime,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Informe a data e hora!';
                  }
                  return null;
                },
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
                validator: (value) =>
                    value == null ? 'Selecione um ciclo' : null,
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
                validator: (value) =>
                    value == null ? 'Selecione uma gleba' : null,
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
                validator: (value) =>
                    value == null ? 'Selecione um estágio' : null,
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _confirmDeleteRegistro,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                      ),
                      child: const Text('Excluir'),
                    ),
                  ),
                  SizedBox(
                    width: 120,
                    height: 45,
                    child: ElevatedButton(
                      onPressed: _saveRegistroEstagio,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                      ),
                      child: const Text('Salvar'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
