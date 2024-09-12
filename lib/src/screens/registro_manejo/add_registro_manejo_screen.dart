import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:flutter_tcc_app/src/services/registro_manejo_service.dart';
import 'package:flutter_tcc_app/src/services/ciclo_service.dart';
import 'package:flutter_tcc_app/src/services/gleba_service.dart';
import 'package:flutter_tcc_app/src/services/manejo_service.dart';

class AddRegistroManejoScreen extends StatefulWidget {
  const AddRegistroManejoScreen({super.key});

  @override
  _AddRegistroManejoScreenState createState() =>
      _AddRegistroManejoScreenState();
}

class _AddRegistroManejoScreenState extends State<AddRegistroManejoScreen> {
  final RegistroManejoService _registroManejoService = RegistroManejoService();
  final CicloService _cicloService = CicloService();
  final GlebaService _glebaService = GlebaService();
  final ManejoService _manejoService = ManejoService();

  DateTime _selectedDate = DateTime.now();
  int? _selectedCicloId;
  int? _selectedGlebaId;
  int? _selectedManejoId;

  late Future<List<Ciclo>> _ciclos;
  late Future<List<Gleba>> _glebas;
  late Future<List<Manejo>> _manejos;

  @override
  void initState() {
    super.initState();
    _ciclos = _cicloService.getCiclos();
    _glebas = _glebaService.getGlebas();
    _manejos = _manejoService.getManejos();
  }

  void _saveRegistroManejo() async {
    if (_selectedCicloId != null &&
        _selectedGlebaId != null &&
        _selectedManejoId != null) {
      RegistroManejo novoRegistro = RegistroManejo(
        id: 0,
        datetime: _selectedDate,
        cicloId: _selectedCicloId!,
        glebaId: _selectedGlebaId!,
        manejoId: _selectedManejoId!,
      );
      await _registroManejoService.addRegistroManejo(novoRegistro);
      Navigator.pop(context); // Voltar após salvar
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registrar Manejo'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Campo de data
            Row(
              children: [
                const Text('Data: '),
                TextButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: _selectedDate,
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (pickedDate != null) {
                      setState(() {
                        _selectedDate = pickedDate;
                      });
                    }
                  },
                  child: Text(_selectedDate.toLocal().toString().split(' ')[0]),
                ),
              ],
            ),

            // Combobox de Ciclos
            FutureBuilder<List<Ciclo>>(
              future: _ciclos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton<int>(
                    hint: const Text('Selecione um Ciclo'),
                    value: _selectedCicloId,
                    onChanged: (value) {
                      setState(() {
                        _selectedCicloId = value;
                      });
                    },
                    items: snapshot.data!
                        .map((ciclo) => DropdownMenuItem<int>(
                              value: ciclo.id,
                              child: Text(ciclo.descricao),
                            ))
                        .toList(),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),

            // Combobox de Glebas
            FutureBuilder<List<Gleba>>(
              future: _glebas,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton<int>(
                    hint: const Text('Selecione uma Gleba'),
                    value: _selectedGlebaId,
                    onChanged: (value) {
                      setState(() {
                        _selectedGlebaId = value;
                      });
                    },
                    items: snapshot.data!
                        .map((gleba) => DropdownMenuItem<int>(
                              value: gleba.id,
                              child: Text(gleba.nomeIdentificador),
                            ))
                        .toList(),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),

            // Combobox de Manejos
            FutureBuilder<List<Manejo>>(
              future: _manejos,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return DropdownButton<int>(
                    hint: const Text('Selecione um Manejo'),
                    value: _selectedManejoId,
                    onChanged: (value) {
                      setState(() {
                        _selectedManejoId = value;
                      });
                    },
                    items: snapshot.data!
                        .map((manejo) => DropdownMenuItem<int>(
                              value: manejo.id,
                              child: Text(manejo!.nome),
                            ))
                        .toList(),
                  );
                } else {
                  return const CircularProgressIndicator();
                }
              },
            ),

            // Botão para salvar
            ElevatedButton(
              onPressed: _saveRegistroManejo,
              child: const Text('Salvar'),
            ),
          ],
        ),
      ),
    );
  }
}
