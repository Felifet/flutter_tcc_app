import 'package:flutter/material.dart';
import 'package:flutter_tcc_app/src/controllers/registro_manejo_controller.dart';
import 'package:flutter_tcc_app/src/models/registro_manejo_model.dart';
import 'package:flutter_tcc_app/src/models/ciclo_model.dart';
import 'package:flutter_tcc_app/src/models/gleba_model.dart';
import 'package:flutter_tcc_app/src/models/manejo_model.dart';
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
  final _formKey = GlobalKey<FormState>();
  final RegistroManejoController _controller = RegistroManejoController();

  DateTime _selectedDate = DateTime.now();
  int? _cicloId;
  int? _glebaId;
  int? _manejoId;

  late Future<List<Ciclo>> _ciclosFuture;
  late Future<List<Gleba>> _glebasFuture;
  late Future<List<Manejo>> _manejosFuture;

  @override
  void initState() {
    super.initState();
    _ciclosFuture = CicloService().getCiclos();
    _glebasFuture = GlebaService().getGlebas();
    _manejosFuture = ManejoService().getManejos();
  }

  Future<void> _saveRegistroManejo() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      if (_cicloId != null && _glebaId != null && _manejoId != null) {
        RegistroManejo novoRegistro = RegistroManejo(
          id: null,
          datetime: _selectedDate,
          cicloId: _cicloId!,
          glebaId: _glebaId!,
          manejoId: _manejoId!,
        );
        await _controller.saveRegistroManejo(novoRegistro);
        Navigator.pop(context); // Volta para a lista após salvar
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Adicionar Registro de Manejo'),
      ),
      body: Form(
        key: _formKey,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Data Picker
              TextFormField(
                decoration: const InputDecoration(labelText: 'Data do Manejo'),
                readOnly: true,
                onTap: () async {
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
                initialValue: _selectedDate.toLocal().toString().split(' ')[0],
              ),
              const SizedBox(height: 16),

              // Campo cicloId
              FutureBuilder<List<Ciclo>>(
                future: _ciclosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar ciclos');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum ciclo encontrado');
                  } else {
                    return DropdownButtonFormField<int>(
                      value: _cicloId,
                      onChanged: (value) {
                        setState(() {
                          _cicloId = value;
                        });
                      },
                      items: snapshot.data!.map((ciclo) {
                        return DropdownMenuItem<int>(
                          value: ciclo.id,
                          child: Text(ciclo.descricao),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecione um Ciclo',
                      ),
                      validator: (value) => value == null
                          ? 'Por favor, selecione um ciclo'
                          : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Campo glebaId
              FutureBuilder<List<Gleba>>(
                future: _glebasFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar glebas');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhuma gleba encontrada');
                  } else {
                    return DropdownButtonFormField<int>(
                      value: _glebaId,
                      onChanged: (value) {
                        setState(() {
                          _glebaId = value;
                        });
                      },
                      items: snapshot.data!.map((gleba) {
                        return DropdownMenuItem<int>(
                          value: gleba.id,
                          child: Text(gleba.nomeIdentificador),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecione uma Gleba',
                      ),
                      validator: (value) => value == null
                          ? 'Por favor, selecione uma gleba'
                          : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 16),

              // Campo manejoId
              FutureBuilder<List<Manejo>>(
                future: _manejosFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return const Text('Erro ao carregar manejos');
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Text('Nenhum manejo encontrado');
                  } else {
                    return DropdownButtonFormField<int>(
                      value: _manejoId,
                      onChanged: (value) {
                        setState(() {
                          _manejoId = value;
                        });
                      },
                      items: snapshot.data!.map((manejo) {
                        return DropdownMenuItem<int>(
                          value: manejo.id,
                          child: Text(manejo.nome),
                        );
                      }).toList(),
                      decoration: const InputDecoration(
                        labelText: 'Selecione um Manejo',
                      ),
                      validator: (value) => value == null
                          ? 'Por favor, selecione um manejo'
                          : null,
                    );
                  }
                },
              ),
              const SizedBox(height: 24),

              // Botão para salvar
              ElevatedButton(
                onPressed: _saveRegistroManejo,
                child: const Text('Salvar'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
